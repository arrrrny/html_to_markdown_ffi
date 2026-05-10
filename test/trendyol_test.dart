import 'dart:io';

import 'package:html_to_markdown_ffi/html_to_markdown.dart';
import 'package:test/test.dart';

void main() {
  group('Trendyol product page', () {
    test('converts real product HTML to Markdown', () {
      // Read the test fixture
      final html = _loadFixture('test/htmls/trendyol-product.html');

      // Convert with metadata extraction
      final result = convert(
        html,
        options: ConversionOptions()
          ..extractMetadata = true
          ..stripTags = ['script', 'style', 'noscript'],
      );

      // Show the full output
      print('');
      print('══════════════════════════════════════════════════');
      print('  TRENDYOL PRODUCT → MARKDOWN OUTPUT');
      print('══════════════════════════════════════════════════');
      print('');
      print('--- CONTENT ---');
      print(result.content ?? '(no content)');
      print('');
      print('--- METADATA ---');
      if (result.metadata != null) {
        final m = result.metadata!;
        print('  title:       ${m.title}');
        print('  description: ${m.description}');
        print('  author:      ${m.author}');
        print('  language:    ${m.language}');
        print('  keywords:    ${m.keywords}');
        print('  canonical:   ${m.canonicalUrl}');
        print('  links:       ${m.links.length}');
        print('  images:      ${m.images.length}');
        print('  structured:  ${m.structuredData.length}');
      } else {
        print('  (null)');
      }
      print('');
      print('--- TABLES (${result.tables.length}) ---');
      for (final t in result.tables) {
        print(t);
      }
      print('');
      print('--- WARNINGS (${result.warnings.length}) ---');
      for (final w in result.warnings) {
        print('  [${w.kind}] ${w.message}');
      }
      print('');
      print('══════════════════════════════════════════════════');
      print('');

      // Assertions
      expect(result.content, isNotNull);
      expect(result.content, isNotEmpty);
      if (result.metadata != null) {
        expect(result.metadata!.title, isNotNull);
      }
    });
  });
}

/// Loads a test fixture file relative to the project root.
String _loadFixture(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    // Try relative to package root
    final altPath = path.replaceFirst('test/', '');
    final altFile = File(altPath);
    if (altFile.existsSync()) {
      return altFile.readAsStringSync();
    }
  }
  return file.readAsStringSync();
}
