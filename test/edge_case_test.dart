import 'package:html_to_markdown_ffi/html_to_markdown.dart';
import 'package:test/test.dart';

void main() {
  group('Edge cases', () {
    test('empty string', () {
      final result = convert('');
      expect(result.content, isNotNull);
    });

    test('whitespace only', () {
      final result = convert('   \n\t  ');
      expect(result.content, isNotNull);
    });

    test('null bytes in content', () {
      final result = convert('<p>test\u0000data</p>');
      expect(result.content, isNotNull);
    });

    test('deeply nested elements', () {
      var html = '<div>';
      for (var i = 0; i < 100; i++) {
        html += '<div>';
      }
      html += 'deep';
      for (var i = 0; i < 100; i++) {
        html += '</div>';
      }
      final result = convert(html);
      expect(result.content, isNotNull);
    });

    test('HTML comments', () {
      final result = convert('<!-- comment --><p>visible</p>');
      expect(result.content, contains('visible'));
    });

    test('CDATA section', () {
      final result =
          convert('<p><![CDATA[some data]]></p>');
      expect(result.content, isNotNull);
    });

    test('special Unicode characters', () {
      final result = convert('<p>\u00a9 \u2122 \u2764</p>');
      expect(result.content, isNotNull);
    });

    test('multiple consecutive conversions', () {
      for (var i = 0; i < 100; i++) {
        convert('<p>test $i</p>');
      }
      // No crash means pass
    });

    test('max depth truncation', () {
      final options = ConversionOptions()..maxDepth = 3;
      final result = convert(
        '<div><div><div><div><div><p>deep</p></div></div></div></div></div>',
        options: options,
      );
      expect(result.content, isNotNull);
    });
  });
}
