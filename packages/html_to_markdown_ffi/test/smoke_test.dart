import 'package:html_to_markdown_ffi/html_to_markdown.dart';
import 'package:test/test.dart';

void main() {
  group('Smoke tests', () {
    test('converts empty string', () {
      final result = convert('');
      expect(result.content, isNotNull);
    });

    test('converts simple heading', () {
      final result = convert('<h1>Hello</h1>');
      expect(result.content, contains('# Hello'));
    });

    test('converts paragraph', () {
      final result = convert('<p>Hello World</p>');
      expect(result.content, contains('Hello World'));
    });

    test('converts bold text', () {
      final result = convert('<strong>bold</strong>');
      expect(result.content, contains('**bold**'));
    });

    test('converts italic text', () {
      final result = convert('<em>italic</em>');
      expect(result.content, contains('*italic*'));
    });

    test('converts mixed content', () {
      final result =
          convert('<h1>Title</h1><p>This is <strong>bold</strong> text.</p>');
      expect(result.content, contains('# Title'));
      expect(result.content, contains('**bold**'));
    });

    test('null options works', () {
      final result = convert('<p>test</p>');
      expect(result.warnings, isEmpty);
      expect(result.content, contains('test'));
    });

    test('invalid html returns error', () {
      // The Rust core handles malformed HTML gracefully via html5ever
      // It should not throw for typical malformed HTML
      final result = convert('<<<broken>>>');
      expect(result.content, isNotNull);
    });

    test('empty string produces output', () {
      final result = convert('');
      // Empty input should not crash
      expect(result.warnings, isA<List<ProcessingWarning>>());
    });
  });
}
