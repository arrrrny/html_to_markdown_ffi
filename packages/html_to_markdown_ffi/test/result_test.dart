import 'package:html_to_markdown_ffi/html_to_markdown.dart';
import 'package:test/test.dart';

void main() {
  group('Conversion result', () {
    test('content is present', () {
      final result = convert('<p>Hello</p>');
      expect(result.content, isNotNull);
      expect(result.content, contains('Hello'));
    });

    test('warnings is always a list', () {
      final result = convert('<p>Hello</p>');
      expect(result.warnings, isA<List<ProcessingWarning>>());
    });

    test('tables is always a list', () {
      final result = convert('<p>Hello</p>');
      expect(result.tables, isA<List>());
    });

    test('images is always a list', () {
      final result = convert('<p>Hello</p>');
      expect(result.images, isA<List>());
    });

    test('result from table HTML has content', () {
      final result = convert(
        '<table><tr><th>Col1</th><th>Col2</th></tr>'
        '<tr><td>A</td><td>B</td></tr></table>',
      );
      expect(result.content, contains('Col1'));
      expect(result.content, contains('Col2'));
    });
  });
}
