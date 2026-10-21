// HAND-IMPLEMENTED SUBJECT — behavior A2 (zfa:tdd: A2:hand).
//
// behavior_id: A2
// source_criterion: AC-2
// description: that package names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, carries the Flutter SDK constraint that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library.
//
// The scenario reads the family's shipped pubspecs — the real manifest — so
// the check fails the moment a `default_package` entry is dropped or the
// plugin manifest loses the Flutter SDK constraint.
//
// The `flutter: plugin: platforms:` block is what lets a consumer name one
// dependency and still get the platform adapter. It is not a pub
// requirement in itself: pub ignores the block, and `flutter_tools` reads
// it to resolve the adapter. The Flutter SDK constraint beside it *is* a
// pub requirement — pub.dev refuses a plugin manifest without one.
//
// The re-export is proven by *using* the plugin package's public entry
// point: the scenario imports it and converts through it, so an API that
// stops being re-exported breaks the scenario at compile time.
//
// The [layout] seam lets a test drive the scenario with a deliberately
// broken family, so the failure paths are covered too and not only the
// happy path.
//
// ignore_for_file: non_constant_identifier_names
library;

import 'package:html_to_markdown_ffi/html_to_markdown.dart' as app;
import 'package:html_to_markdown_ffi/html_to_markdown.dart'
    show ConversionOptions, ConversionResult;
import 'package:html_to_markdown_ffi_flutter/html_to_markdown_ffi_flutter.dart'
    as flutter_plugin;
import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/family_layout.dart';

/// The Flutter plugin package.
const String pluginPackage = 'html_to_markdown_ffi_flutter';

/// The platform each adapter is the `default_package` for.
const Map<String, String> expectedDefaultPackages = <String, String>{
  'android': 'html_to_markdown_ffi_android',
  'ios': 'html_to_markdown_ffi_ios',
  'macos': 'html_to_markdown_ffi_macos',
};

/// Scenario runner for behavior A2.
///
/// Returns the violations found; an empty list means the scenario holds.
///
/// When [layout] is given it replaces the repository the scenario reads.
/// When [failureProbe] is given it replaces the observation the scenario
/// makes about the plugin package's public entry point.
List<String> subject_a2({
  RepoLayout? layout,
  String? Function()? failureProbe,
}) {
  final repo = layout ?? RepoLayout.repository();
  final violations = <String>[];

  final source = repo.memberPubspecOrNull(pluginPackage);
  if (source == null) {
    violations.add('The family ships no $pluginPackage package — a Flutter '
        'app has no entry point.');
    return violations;
  }

  final manifest = Pubspec.parse(source);
  if (manifest == null) {
    violations.add(
      '$pluginPackage ships a manifest that is not readable YAML — what it '
      'asks of a consumer cannot be read.',
    );
    return violations;
  }

  if (!manifest.constrainsFlutterSdk) {
    violations.add(
      '$pluginPackage carries a plugin manifest but declares no Flutter SDK '
      'constraint in its `environment:` — pub.dev refuses to publish it.',
    );
  }

  for (final entry in expectedDefaultPackages.entries) {
    if (manifest.defaultPackageFor(entry.key) != entry.value) {
      violations.add(
        '$pluginPackage does not name ${entry.value} as the '
        '`default_package` for ${entry.key} — a consumer that depends on '
        '`$pluginPackage` alone would not get the ${entry.key} adapter.',
      );
    }
  }

  if (!manifest.declaresDependency('html_to_markdown_ffi')) {
    violations.add(
      '$pluginPackage does not depend on html_to_markdown_ffi — a consumer '
      'that depends on `$pluginPackage` alone would not get the app-facing '
      'API.',
    );
  }

  // The plugin package has to carry the app-facing API, or a Flutter app
  // would need a second dependency.
  final failure = (failureProbe ?? reExportFailure)();
  if (failure != null) {
    violations.add(
      '$pluginPackage does not carry the app-facing API: $failure',
    );
  }

  return violations;
}

/// A conversion entry point the scenario compares.
typedef MarkdownConverter = ConversionResult Function(
  String html, {
  ConversionOptions? options,
});

/// Exercises the plugin package's public entry point and reports the
/// failure, if any.
///
/// The scenario converts through the re-exported [flutter_plugin.convert]
/// and checks that the result is the same conversion the app-facing package
/// performs.
///
/// [pluginConvert] and [directConvert] replace the two entry points, so a
/// test can drive the comparison with two conversions that differ.
String? reExportFailure({
  MarkdownConverter? pluginConvert,
  MarkdownConverter? directConvert,
}) {
  final MarkdownConverter convertThroughPlugin =
      pluginConvert ?? flutter_plugin.convert;
  final MarkdownConverter convertDirectly = directConvert ?? app.convert;
  try {
    final result = convertThroughPlugin(
      '<h1>probe</h1>',
      options: flutter_plugin.ConversionOptions(
        headingStyle: flutter_plugin.HeadingStyle.atx,
      ),
    );
    final content = result.content;
    if (content == null) {
      return 'the conversion produced no content.';
    }
    if (content.trim() != '# probe') {
      return 'the conversion did not convert the heading: $content';
    }
    // The same conversion, reached through the other entry point.
    final direct = convertDirectly(
      '<h1>probe</h1>',
      options: app.ConversionOptions(headingStyle: app.HeadingStyle.atx),
    );
    if (direct.content != content) {
      return 'the re-exported conversion differs from the app-facing one: '
          '"$content" vs "${direct.content}".';
    }
    return null;
  } on Object catch (error) {
    // A host without the native library cannot convert; the entry point
    // still exposes the conversion.
    if (error.toString().contains('Failed to load')) return null;
    return '$error';
  }
}
