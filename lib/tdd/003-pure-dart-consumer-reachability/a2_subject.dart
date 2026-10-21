// HAND-IMPLEMENTED SUBJECT — behavior A2 (zfa:tdd: A2:hand).
//
// behavior_id: A2
// source_criterion: AC-2
// description: it still names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, and still carries the Flutter SDK constraint that a plugin manifest requires — so the zero-touch distribution of `001-zero-touch-native-distribution` survives.
//
// The scenario reads the family's shipped pubspecs — the real manifest — so
// the check fails the moment a `default_package` entry is dropped or a
// plugin manifest loses the Flutter SDK constraint.
//
// The `flutter: plugin: platforms:` block is what lets a consumer name one
// dependency and still get the platform adapter. It is not a pub
// requirement in itself: pub ignores the block, and `flutter_tools` reads
// it to resolve the adapter. The Flutter SDK constraint beside it *is* a
// pub requirement — pub.dev refuses a plugin manifest without one.
//
// The plugin manifest lives in the Flutter plugin package, not in the pure
// Dart engine package: an engine package that carried one would ask for
// the Flutter SDK and lock a CLI out of the family.
//
// The [layout] seam lets a test drive the scenario with a deliberately
// broken family, so the failure paths are covered too and not only the
// happy path.
//
// ignore_for_file: non_constant_identifier_names
library;

import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/family_layout.dart';

/// The platform each adapter is the `default_package` for.
const Map<String, String> expectedDefaultPackages = <String, String>{
  'android': 'html_to_markdown_ffi_android',
  'ios': 'html_to_markdown_ffi_ios',
  'macos': 'html_to_markdown_ffi_macos',
};

/// The package that carries the plugin manifest.
const String pluginPackage = 'html_to_markdown_ffi_flutter';

/// The packages that carry a plugin manifest and therefore require the
/// Flutter SDK.
const List<String> pluginPackages = <String>[
  'html_to_markdown_ffi_flutter',
  'html_to_markdown_ffi_android',
  'html_to_markdown_ffi_ios',
  'html_to_markdown_ffi_macos',
];

/// Whether the manifest names [adapter] as the `default_package` for
/// [platform].
bool declaresDefaultPackage(String pubspec, String platform, String adapter) {
  final manifest = Pubspec.parse(pubspec);
  if (manifest == null) return false;
  return manifest.defaultPackageFor(platform) == adapter;
}

/// Scenario runner for behavior A2.
///
/// Returns the violations found; an empty list means the scenario holds.
///
/// When [layout] is given it replaces the repository the scenario reads.
List<String> subject_a2({RepoLayout? layout}) {
  final repo = layout ?? RepoLayout.repository();
  final violations = <String>[];

  final source = repo.memberPubspecOrNull(pluginPackage);
  if (source == null) {
    violations.add('The plugin package ships no pubspec.');
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

  for (final entry in expectedDefaultPackages.entries) {
    if (manifest.defaultPackageFor(entry.key) != entry.value) {
      violations.add(
        'The plugin package does not name ${entry.value} as the '
        '`default_package` for ${entry.key} — a consumer that depends on '
        '`$pluginPackage` alone would not get the ${entry.key} adapter.',
      );
    }
  }

  // Every package that carries a plugin manifest must declare the Flutter
  // SDK constraint: pub.dev rejects the package otherwise.
  for (final packageName in pluginPackages) {
    final manifestSource = repo.memberPubspecOrNull(packageName);
    if (manifestSource == null) {
      violations.add('$packageName ships no pubspec.');
      continue;
    }
    final packageManifest = Pubspec.parse(manifestSource);
    if (packageManifest == null) {
      violations.add(
        '$packageName ships a manifest that is not readable YAML — what it '
        'asks of a consumer cannot be read.',
      );
      continue;
    }
    if (!packageManifest.constrainsFlutterSdk) {
      violations.add(
        '$packageName carries a plugin manifest but declares no Flutter SDK '
        'constraint in its `environment:` — pub.dev refuses to publish it.',
      );
    }
  }

  return violations;
}
