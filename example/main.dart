import 'package:html_to_markdown_ffi/html_to_markdown.dart';

/// Example usage of the html_to_markdown package.
void main() {
  // Basic conversion
  final basic = convert('<h1>Hello World</h1><p>This is a <strong>test</strong>.</p>');
  print('=== Basic ===');
  print(basic.content);
  print('');

  // With options
  final withOptions = convert(
    '<h1>Title</h1>',
    options: ConversionOptions()
      ..headingStyle = HeadingStyle.setext
      ..extractMetadata = true,
  );
  print('=== Setext Heading ===');
  print(withOptions.content);
  print('');

  // Metadata extraction
  final withMeta = convert(
    '<html><head><title>My Site</title>'
    '<meta name="description" content="A great site">'
    '</head><body><p>Hello</p></body></html>',
    options: ConversionOptions()..extractMetadata = true,
  );
  print('=== Metadata ===');
  print('Title: ${withMeta.metadata?.title}');
  print('Description: ${withMeta.metadata?.description}');
  print('Warnings: ${withMeta.warnings.length}');
  print('');

  // Filtering
  final filtered = convert(
    '<div><script>alert("xss")</script><p>Safe content</p><style>.a{}</style></div>',
    options: ConversionOptions()..stripTags = ['script', 'style'],
  );
  print('=== Filtered ===');
  print(filtered.content);
}
