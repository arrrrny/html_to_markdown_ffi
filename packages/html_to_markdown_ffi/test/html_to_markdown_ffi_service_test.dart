// Spec 064 (B2 tier): the service contract over a fake port — the
// preserved public API flows through the zuraffa facade with typed
// failures. Offline: no native library is touched (fake port + fake
// repository).
import 'package:test/test.dart';
import 'package:zuraffa/zuraffa.dart';
import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';

import 'fakes/fake_htm_port.dart';

class _FakeRepository implements HtmConversionRepository {
  _FakeRepository(this.answer);

  final HtmConversion answer;

  @override
  Future<HtmConversion> get(QueryParams<HtmConversion> params) async =>
      answer;

  @override
  Future<HtmConversion> update(
          UpdateParams<String, HtmConversionPatch> params) async =>
      answer;

  @override
  Future<HtmConversion> toggle(
          ToggleParams<String, Field<HtmConversion, dynamic>> params) async =>
      answer;
}

void main() {
  group('HtmlToMarkdownFfiService over a fake port', () {
    test('convert routes through the port sync path', () {
      final port = FakeHtmPort(
        syncAnswer: const ConversionResult(content: '# Title'),
      );
      final service = HtmlToMarkdownFfiService(port: port);

      final result = service.convert('<h1>Title</h1>',
          options: ConversionOptions(bullets: '*'));

      expect(result.content, '# Title');
      expect(port.calls, contains('convertSync'));
      expect(port.lastOptions?.bullets, '*',
          reason: 'the sync path must pass options through to the port');
    });

    test('convertAsync routes through the port async path', () async {
      final port = FakeHtmPort(
        asyncAnswer: const ConversionResult(content: '*em*'),
      );
      final service = HtmlToMarkdownFfiService(port: port);

      final result = await service.convertAsync('<em>em</em>');

      expect(result.content, '*em*');
      expect(port.calls, contains('convert'));
    });

    test('conversion options reach the port', () async {
      final port = FakeHtmPort();
      final service = HtmlToMarkdownFfiService(port: port);

      await service.convertAsync('<h1>Hi</h1>',
          options: ConversionOptions(headingStyle: HeadingStyle.setext));

      expect(port.lastOptions?.headingStyle, HeadingStyle.setext);
    });

    test('supported delegates to the port', () async {
      final service = HtmlToMarkdownFfiService(port: FakeHtmPort());
      expect(await service.supported(), isTrue);
    });
  });

  group('UnwiredHtmlToMarkdownFfiPort', () {
    test('surfaces the typed port_not_wired failure', () async {
      final service =
          HtmlToMarkdownFfiService(port: const UnwiredHtmlToMarkdownFfiPort());

      expect(
        () => service.convert('<p>x</p>'),
        throwsA(isA<HtmlToMarkdownFfiException>()
            .having((e) => e.code, 'code', 'port_not_wired')),
      );
      await expectLater(
        service.convertAsync('<p>x</p>'),
        throwsA(isA<HtmlToMarkdownFfiException>()
            .having((e) => e.code, 'code', 'port_not_wired')),
      );
    });
  });

  group('datasource path through the generated stack', () {
    test('convertAsync without a port flows usecase -> repository -> '
        'datasource seam', () async {
      final done = HtmConversion(
        id: 'prepared',
        html: '<h1>Title</h1>',
        optionsJson: '{}',
        resultJson: '{"content":"# Title","warnings":[]}',
      );
      final service = HtmlToMarkdownFfiService(
        repository: _FakeRepository(done),
      );

      final result = await service.convertAsync('<h1>Title</h1>');

      expect(result.content, '# Title');
    });
  });

  group('boundary mapping (public types <-> internal entity)', () {
    test('buildConversionRequest encodes options json', () {
      final request = buildConversionRequest(
        '<b>bold</b>',
        id: 'id-1',
        options: ConversionOptions(bullets: '*'),
      );
      expect(request.id, 'id-1');
      expect(request.html, '<b>bold</b>');
      expect(request.optionsJson, contains('"bullets":"*"'));
    });

    test('toConversionResult decodes the bridge result json', () {
      final result = conversionResultFromJson(
          '{"content":"hi","tables":[],"images":[],"warnings":[]}');
      expect(result.content, 'hi');
    });
  });

  group('DI registration', () {
    test('registerHtmlToMarkdownFfiDependencies wires the service', () async {
      final getIt = GetIt.instance;
      await getIt.reset();
      registerHtmlToMarkdownFfiDependencies(
        getIt,
        port: FakeHtmPort(syncAnswer: const ConversionResult(content: 'wired')),
      );
      addTearDown(getIt.reset);

      final service = getIt<HtmlToMarkdownFfiService>();
      expect(service.convert('<p>x</p>').content, 'wired');
    });
  });
}
