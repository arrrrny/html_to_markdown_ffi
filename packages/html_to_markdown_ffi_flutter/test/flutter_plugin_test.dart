import 'package:html_to_markdown_ffi/html_to_markdown.dart' as engine;
import 'package:html_to_markdown_ffi_flutter/html_to_markdown_ffi_flutter.dart'
    as plugin;
import 'package:test/test.dart';

void main() {
  group('html_to_markdown_ffi_flutter', () {
    test('re-exports the app-facing conversion', () {
      // The same conversion, reached through the plugin's entry point and
      // through the engine's. A consumer that depends on the plugin alone
      // must not need a second dependency.
      final throughPlugin = plugin.convert(
        '<h1>probe</h1>',
        options: plugin.ConversionOptions(
          headingStyle: plugin.HeadingStyle.atx,
        ),
      );
      final throughEngine = engine.convert(
        '<h1>probe</h1>',
        options: engine.ConversionOptions(headingStyle: engine.HeadingStyle.atx),
      );

      expect(throughPlugin.content, throughEngine.content);
    });

    test('re-exports the three platform adapters', () {
      // The registration helpers of every adapter are reachable from the
      // plugin's one entry point.
      expect(plugin.registerAndroidHtmlToMarkdownFfiDependencies, isNotNull);
      expect(plugin.registerIosHtmlToMarkdownFfiDependencies, isNotNull);
      expect(plugin.registerMacosHtmlToMarkdownFfiDependencies, isNotNull);
    });

    test('re-exports the zuraffa stack', () {
      expect(plugin.registerHtmlToMarkdownFfiDependencies, isNotNull);
      expect(plugin.HtmlToMarkdownFfiService.native, isNotNull);
    });
  });
}
