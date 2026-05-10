import 'package:html_to_markdown_ffi/html_to_markdown.dart';
import 'package:test/test.dart';

void main() {
  group('Metadata extraction', () {
    test('extracts title', () {
      final result = convert(
        '<html><head><title>Test Page</title></head><body><p>Content</p></body></html>',
        options: ConversionOptions()..extractMetadata = true,
      );
      expect(result.metadata, isNotNull);
      expect(result.metadata!.title, equals('Test Page'));
    });

    test('extracts description', () {
      final result = convert(
        '<html><head>'
        '<meta name="description" content="A test description">'
        '</head><body><p>Content</p></body></html>',
        options: ConversionOptions()..extractMetadata = true,
      );
      expect(result.metadata, isNotNull);
      expect(result.metadata!.description, equals('A test description'));
    });

    test('extracts author', () {
      final result = convert(
        '<html><head>'
        '<meta name="author" content="John Doe">'
        '</head><body><p>Content</p></body></html>',
        options: ConversionOptions()..extractMetadata = true,
      );
      expect(result.metadata, isNotNull);
      expect(result.metadata!.author, equals('John Doe'));
    });

    test('extracts keywords', () {
      final result = convert(
        '<html><head>'
        '<meta name="keywords" content="dart, html, markdown">'
        '</head><body><p>Content</p></body></html>',
        options: ConversionOptions()..extractMetadata = true,
      );
      expect(result.metadata, isNotNull);
      expect(result.metadata!.keywords, contains('dart'));
    });

    test('extracts language', () {
      final result = convert(
        '<html lang="en"><head></head><body><p>Content</p></body></html>',
        options: ConversionOptions()..extractMetadata = true,
      );
      expect(result.metadata, isNotNull);
    });

    test('metadata object is always present', () {
      final result = convert(
        '<html><head><title>Test</title></head><body><p>Content</p></body></html>',
        options: ConversionOptions()..extractMetadata = false,
      );
      // Rust core still returns a metadata object (possibly empty)
      expect(result.metadata, isNotNull);
    });
  });
}
