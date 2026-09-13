// Spec 064 (T027): adapter test harness over a fake injected channel —
// success decode, typed taxonomy, timeout, unwired registration, and the
// sync path guard. Offline on any host.
import 'dart:async';
import 'dart:convert' show jsonEncode;
import 'dart:io' show Platform;

import 'package:test/test.dart';
import 'package:zuraffa/zuraffa.dart';
import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';
import 'package:html_to_markdown_ffi_ios/html_to_markdown_ffi_ios.dart';

void main() {
  group('IosHtmlToMarkdownFfiAdapter', () {
    test('isSupported decodes the native payload', () async {
      final channel = IosHtmlToMarkdownFfiChannel(
        invoke: (_, __) async => {'supported': true},
      );
      final port = IosHtmlToMarkdownFfiPort(channel: channel);

      expect(await port.isSupported(), isTrue);
    });

    test('convert decodes the result json through the envelope', () async {
      final channel = IosHtmlToMarkdownFfiChannel(
        invoke: (method, args) async => {
          'resultJson':
              jsonEncode({'content': '# Title', 'warnings': []}),
        },
      );
      final port = IosHtmlToMarkdownFfiPort(channel: channel);

      final result = await port.convert(id: 't1', html: '<h1>Title</h1>');

      expect(result.content, '# Title');
    });

    test('native error payloads surface as typed failures', () async {
      final channel = IosHtmlToMarkdownFfiChannel(
        invoke: (_, __) async => {
          'error': {'code': 'not_supported', 'message': 'no engine'},
        },
      );

      await expectLater(
        channel.call('isSupported', const {}),
        throwsA(
          isA<IosHtmlToMarkdownFfiException>()
              .having((e) => e.code, 'code', 'not_supported')
              .having((e) => e.recoverable, 'recoverable', isTrue),
        ),
      );
    });

    test('timeout surfaces as the typed recoverable timeout', () async {
      final channel = IosHtmlToMarkdownFfiChannel(
        invoke: (_, __) => Completer<Map<String, Object?>>().future,
        timeout: const Duration(milliseconds: 20),
      );

      await expectLater(
        channel.call('isSupported', const {}),
        throwsA(
          isA<IosHtmlToMarkdownFfiException>()
              .having((e) => e.code, 'code', 'timeout'),
        ),
      );
    });

    test('without a wired channel registration stays safe and typed',
        () async {
      final getIt = GetIt.instance;
      await getIt.reset();
      registerIosHtmlToMarkdownFfiDependencies(getIt);
      addTearDown(getIt.reset);

      final port = getIt<HtmlToMarkdownFfiPort>();
      await expectLater(
        port.isSupported(),
        throwsA(
          isA<IosHtmlToMarkdownFfiException>()
              .having((e) => e.code, 'code', 'channel_not_wired'),
        ),
      );
    });

    test('convertSync guard is honest on this host', () {
      final port = IosHtmlToMarkdownFfiPort(
        channel: IosHtmlToMarkdownFfiChannel(
          invoke: (_, __) async => {'supported': true},
        ),
      );
      final nativeHost = {
        'macos': Platform.isMacOS,
        'android': Platform.isAndroid,
        'ios': Platform.isIOS,
      }['ios']!;

      if (nativeHost) {
        // On the native host the guard lets the call through (it may fail
        // on a missing binary, but not with sync_unsupported).
        try {
          port.convertSync(id: 't', html: '<p>x</p>');
        } on IosHtmlToMarkdownFfiException catch (e) {
          expect(e.code, isNot('sync_unsupported'));
        }
      } else {
        expect(
          () => port.convertSync(id: 't', html: '<p>x</p>'),
          throwsA(isA<IosHtmlToMarkdownFfiException>()
              .having((e) => e.code, 'code', 'sync_unsupported')),
        );
      }
    });
  });
}
