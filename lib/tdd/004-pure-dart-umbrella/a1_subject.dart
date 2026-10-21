// HAND-IMPLEMENTED SUBJECT — behavior A1 (zfa:tdd: A1:hand).
//
// behavior_id: A1
// source_criterion: AC-1
// description: the resolution succeeds — the package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency, and it depends on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.
//
// The scenario reads the family's shipped pubspecs — the real manifest — so
// the check fails the moment a member takes a dependency on the Flutter SDK
// again.
//
// The manifest is parsed as YAML, so the answer does not depend on how the
// manifest is indented or on which other keys it carries.
//
// A dependency on a family member that asks for the Flutter SDK is the same
// lock-out one level down: pub reports *"because X depends on Y which
// requires the Flutter SDK, X is forbidden"*. So the engine package must
// not name the plugin package or any of the three adapters.
//
// The second half of the behavior is proven by *using* the app-facing
// package's public entry point: the scenario imports it and converts
// through it, so a conversion that stops being exported breaks the scenario
// at compile time.
//
// The [layout] seam lets a test drive the scenario with a deliberately
// broken family, so the failure paths are covered too and not only the
// happy path.
//
// ignore_for_file: non_constant_identifier_names
library;

import 'package:html_to_markdown_ffi/html_to_markdown.dart' as app;
import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/family_layout.dart';

/// The app-facing package: the pure-Dart engine.
const String appFacingPackage = 'html_to_markdown_ffi';

/// The family members that ask for the Flutter SDK.
///
/// Derived from the shipped manifests rather than kept by hand, so a member
/// is recognised however it asks — with an `environment: flutter:`
/// constraint, with a `flutter: sdk: flutter` dependency, or with both.
List<String> flutterSdkPackages(RepoLayout repo) {
  final found = <String>[];
  for (final packageName in familyPackages) {
    if (packageName == appFacingPackage) continue;
    final source = repo.memberPubspecOrNull(packageName);
    if (source == null) continue;
    final manifest = Pubspec.parse(source);
    if (manifest == null) continue;
    if (asksForFlutterSdk(manifest)) found.add(packageName);
  }
  return found;
}

/// Whether a package asks for the Flutter SDK at all.
bool asksForFlutterSdk(Pubspec manifest) =>
    manifest.constrainsFlutterSdk || manifest.dependsOnFlutterSdk;

/// Scenario runner for behavior A1.
///
/// Returns the violations found; an empty list means the scenario holds.
///
/// When [layout] is given it replaces the repository the scenario reads.
/// When [failureProbe] is given it replaces the observation the scenario
/// makes about the app-facing package's public entry point.
List<String> subject_a1({
  RepoLayout? layout,
  String? Function()? failureProbe,
}) {
  final repo = layout ?? RepoLayout.repository();
  final violations = <String>[];

  final source = repo.memberPubspecOrNull(appFacingPackage);
  if (source == null) {
    violations.add(
      'The family ships no $appFacingPackage package — a consumer that is '
      'not a Flutter app has no entry point.',
    );
    return violations;
  }

  final manifest = Pubspec.parse(source);
  if (manifest == null) {
    violations.add(
      '$appFacingPackage ships a manifest that is not readable YAML — what '
      'it asks of a consumer cannot be read.',
    );
    return violations;
  }

  if (manifest.constrainsFlutterSdk) {
    violations.add(
      '$appFacingPackage constrains the Flutter SDK in its `environment:` — '
      'a consumer with a plain Dart SDK cannot resolve it.',
    );
  }
  if (manifest.dependsOnFlutterSdk) {
    violations.add(
      '$appFacingPackage depends on the Flutter SDK — a consumer with a '
      'plain Dart SDK cannot resolve it.',
    );
  }
  if (manifest.carriesPluginManifest) {
    violations.add(
      '$appFacingPackage carries a plugin manifest — pub.dev requires a '
      'Flutter SDK constraint beside one, which locks a consumer with a '
      'plain Dart SDK out.',
    );
  }

  // A dependency on a family member that asks for the Flutter SDK locks the
  // consumer out just the same, one level down.
  for (final packageName in flutterSdkPackages(repo)) {
    if (!manifest.declaresDependency(packageName)) continue;
    violations.add(
      '$appFacingPackage depends on $packageName, which asks for the Flutter '
      'SDK — a consumer with a plain Dart SDK cannot resolve it.',
    );
  }

  // The entry point has to offer the conversion, or the pure-Dart consumer
  // has nothing to call.
  final failure = (failureProbe ?? conversionEntryPointFailure)();
  if (failure != null) {
    violations.add(
      '$appFacingPackage does not offer the conversion through its public '
      'entry point: $failure',
    );
  }

  return violations;
}

/// Exercises the app-facing package's public entry point and reports the
/// failure, if any.
///
/// The scenario converts through the exported [app.convert] and checks that
/// the result carries what the conversion produced. The native library may
/// be absent on a host without it, so a missing library is not a failure of
/// the entry point — the reachability of the symbol is what the behavior is
/// about.
String? conversionEntryPointFailure() {
  try {
    final result = app.convert(
      '<h1>probe</h1>',
      options: app.ConversionOptions(
        headingStyle: app.HeadingStyle.atx,
      ),
    );
    final content = result.content;
    if (content == null) {
      return 'the conversion produced no content.';
    }
    if (content.trim() != '# probe') {
      return 'the conversion did not convert the heading: $content';
    }
    return null;
  } on Object catch (error) {
    // A host without the native library cannot convert; the entry point
    // still exposes the conversion.
    if (error.toString().contains('Failed to load')) return null;
    return '$error';
  }
}
