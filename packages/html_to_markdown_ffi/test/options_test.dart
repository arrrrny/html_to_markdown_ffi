import 'package:html_to_markdown_ffi/html_to_markdown.dart';
import 'package:test/test.dart';

void main() {
  group('Conversion options', () {
    test('heading style atx', () {
      final result = convert(
        '<h1>Title</h1>',
        options: ConversionOptions()..headingStyle = HeadingStyle.atx,
      );
      expect(result.content, contains('# Title'));
    });

    test('heading style setext', () {
      final result = convert(
        '<h1>Title</h1>',
        options: ConversionOptions()..headingStyle = HeadingStyle.setext,
      );
      // setext produces underlined headings
      expect(result.content, contains('Title'));
      expect(result.content, contains('===='));
    });

    test('link style referenced', () {
      final result = convert(
        '<a href="https://example.com">Example</a>',
        options: ConversionOptions()..linkStyle = LinkStyle.referenced,
      );
      expect(result.content, contains('Example'));
      expect(result.content, contains('https://example.com'));
    });

    test('wrap enabled', () {
      final result = convert(
        '<p>This is a very long paragraph that should be wrapped at the specified width.</p>',
        options: ConversionOptions()
          ..wrap = true
          ..wrapWidth = 20,
      );
      expect(result.content, isNotNull);
    });

    test('extract metadata', () {
      final result = convert(
        '<html><head><title>My Page</title></head><body><p>Content</p></body></html>',
        options: ConversionOptions()..extractMetadata = true,
      );
      expect(result.metadata, isNotNull);
      expect(result.metadata!.title, equals('My Page'));
    });

    test('strip tags', () {
      final result = convert(
        '<div><script>alert("xss")</script><p>Safe</p></div>',
        options: ConversionOptions()..stripTags = ['script'],
      );
      expect(result.content, isNot(contains('alert')));
      expect(result.content, contains('Safe'));
    });

    test('preserve tags', () {
      final result = convert(
        '<div><pre>code block</pre><p>text</p></div>',
        options: ConversionOptions()..preserveTags = ['pre'],
      );
      expect(result.content, isNotNull);
    });

    test('max depth', () {
      final result = convert(
        '<div><div><div><div><div>deep</div></div></div></div></div>',
        options: ConversionOptions()..maxDepth = 2,
      );
      expect(result.content, isNotNull);
    });
  });
}
