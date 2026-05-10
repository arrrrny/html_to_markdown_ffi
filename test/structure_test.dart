import 'package:html_to_markdown_ffi/html_to_markdown.dart';
import 'package:test/test.dart';

void main() {
  group('Document structure', () {
    test('simple document has content', () {
      final result = convert('<p>Hello</p>');
      expect(result.content, isNotNull);
    });

    test('nested document structure', () {
      final result = convert(
        '<div><section><article><p>text</p></article></section></div>',
      );
      expect(result.content, isNotNull);
      expect(result.content, contains('text'));
    });

    test('multiple sibling elements', () {
      final result = convert(
        '<h1>Title</h1><p>Paragraph</p><hr><p>More</p>',
      );
      expect(result.content, contains('# Title'));
      expect(result.content, contains('Paragraph'));
      expect(result.content, contains('---'));
    });
  });
}
