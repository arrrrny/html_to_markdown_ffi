// GENERATED TEST — `zfa tdd gen A2` (spec 044-test-tdd-generation).
//
// behavior_id: A2
// source_criterion: AC-2
// kind: acceptance
// description: that package names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, carries the Flutter SDK constraint that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library.
//
// This test asserts the observable behavior described above. It is
// "honest red" on first execution: the paired subject at
// `package:html_to_markdown_ffi_workspace/tdd/004-pure-dart-umbrella/a2_subject.dart` is unimplemented, so the test fails through an
// assertion (not an uncaught error, compile/load error, skip, or
// placeholder). Replace the subject's
// stub body with real implementation to make the test pass.
//
// zfa:tdd: A2:hand — hand step completed before first red certification (issue #1411)
library;

import 'package:test/test.dart';
import 'package:html_to_markdown_ffi/html_to_markdown.dart' as app;
import 'package:html_to_markdown_ffi_workspace/tdd/004-pure-dart-umbrella/a2_subject.dart' as subject;
import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/family_layout.dart';

import '../001-zero-touch-native-distribution/fixtures.dart';

/// A manifest with all three `default_package` entries and the Flutter SDK
/// constraint.
const String completeManifest = '''
name: html_to_markdown_ffi_flutter
version: 1.2.7

environment:
  sdk: ^3.11.0
  flutter: ">=3.27.0"

dependencies:
  html_to_markdown_ffi: ^1.2.7
  html_to_markdown_ffi_android: ^1.2.7
  html_to_markdown_ffi_ios: ^1.2.7
  html_to_markdown_ffi_macos: ^1.2.7

flutter:
  plugin:
    platforms:
      android:
        default_package: html_to_markdown_ffi_android
      ios:
        default_package: html_to_markdown_ffi_ios
      macos:
        default_package: html_to_markdown_ffi_macos
''';

/// The plugin manifest with the macOS entry dropped.
const String manifestWithoutMacos = '''
name: html_to_markdown_ffi_flutter
version: 1.2.7

environment:
  sdk: ^3.11.0
  flutter: ">=3.27.0"

dependencies:
  html_to_markdown_ffi: ^1.2.7

flutter:
  plugin:
    platforms:
      android:
        default_package: html_to_markdown_ffi_android
      ios:
        default_package: html_to_markdown_ffi_ios
''';

/// A manifest that names the wrong adapter for Android.
const String manifestWithWrongAdapter = '''
name: html_to_markdown_ffi_flutter
version: 1.2.7

environment:
  sdk: ^3.11.0
  flutter: ">=3.27.0"

dependencies:
  html_to_markdown_ffi: ^1.2.7

flutter:
  plugin:
    platforms:
      android:
        default_package: html_to_markdown_ffi_macos
      ios:
        default_package: html_to_markdown_ffi_ios
      macos:
        default_package: html_to_markdown_ffi_macos
''';

/// A manifest that carries a plugin manifest but no Flutter SDK constraint.
const String manifestWithoutFlutterConstraint = '''
name: html_to_markdown_ffi_flutter
version: 1.2.7

environment:
  sdk: ^3.11.0

dependencies:
  html_to_markdown_ffi: ^1.2.7

flutter:
  plugin:
    platforms:
      android:
        default_package: html_to_markdown_ffi_android
      ios:
        default_package: html_to_markdown_ffi_ios
      macos:
        default_package: html_to_markdown_ffi_macos
''';

/// A manifest that does not depend on the app-facing package.
const String manifestWithoutAppFacing = '''
name: html_to_markdown_ffi_flutter
version: 1.2.7

environment:
  sdk: ^3.11.0
  flutter: ">=3.27.0"

dependencies:
  html_to_markdown_ffi_android: ^1.2.7
  html_to_markdown_ffi_ios: ^1.2.7
  html_to_markdown_ffi_macos: ^1.2.7

flutter:
  plugin:
    platforms:
      android:
        default_package: html_to_markdown_ffi_android
      ios:
        default_package: html_to_markdown_ffi_ios
      macos:
        default_package: html_to_markdown_ffi_macos
''';

/// A manifest that is not YAML at all.
const String malformedManifest = 'name: html_to_markdown_ffi_flutter\nfoo: [1, 2\n';

void main() {
  group('A2 (AC-2)', () {
    test('A2 — that package names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, carries the Flutter SDK constraint that a plugin manifest requires, and re-exports the app-facing package\'s public API — so one dependency still gives the consumer both the conversion and the linked-in native library.', () {
      final Object? result = (() {
        try {
          subject.subject_a2();
          return null;
        } on UnimplementedError catch (error) {
          return error;
        }
      })();
      expect(result, isNot(isA<UnimplementedError>()));
      // The observable outcome of the scenario: the plugin package names
      // every platform's adapter and carries the app-facing API.
      expect(subject.subject_a2(), isEmpty);
    });

    test('A2 — a missing plugin package is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        if (packageName == subject.pluginPackage) continue;
        fixture.write('packages/$packageName/pubspec.yaml', completeManifest);
      }

      final violations = subject.subject_a2(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'The family ships no html_to_markdown_ffi_flutter package — a '
        'Flutter app has no entry point.',
      );
    });

    test('A2 — a manifest that is not YAML is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        fixture.write('packages/$packageName/pubspec.yaml', completeManifest);
      }
      fixture.write(
        'packages/html_to_markdown_ffi_flutter/pubspec.yaml',
        malformedManifest,
      );

      final violations = subject.subject_a2(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'html_to_markdown_ffi_flutter ships a manifest that is not readable '
        'YAML — what it asks of a consumer cannot be read.',
      );
    });

    test('A2 — a plugin package without the Flutter constraint is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        fixture.write('packages/$packageName/pubspec.yaml', completeManifest);
      }
      fixture.write(
        'packages/html_to_markdown_ffi_flutter/pubspec.yaml',
        manifestWithoutFlutterConstraint,
      );

      final violations = subject.subject_a2(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'html_to_markdown_ffi_flutter carries a plugin manifest but declares '
        'no Flutter SDK constraint in its `environment:` — pub.dev refuses to '
        'publish it.',
      );
    });

    test('A2 — a platform without a `default_package` is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        fixture.write('packages/$packageName/pubspec.yaml', completeManifest);
      }
      fixture.write(
        'packages/html_to_markdown_ffi_flutter/pubspec.yaml',
        manifestWithoutMacos,
      );

      final violations = subject.subject_a2(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'html_to_markdown_ffi_flutter does not name '
        'html_to_markdown_ffi_macos as the `default_package` for macos — a '
        'consumer that depends on `html_to_markdown_ffi_flutter` alone would '
        'not get the macos adapter.',
      );
    });

    test('A2 — a platform pointing at the wrong adapter is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        fixture.write('packages/$packageName/pubspec.yaml', completeManifest);
      }
      fixture.write(
        'packages/html_to_markdown_ffi_flutter/pubspec.yaml',
        manifestWithWrongAdapter,
      );

      final violations = subject.subject_a2(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'html_to_markdown_ffi_flutter does not name '
        'html_to_markdown_ffi_android as the `default_package` for android — '
        'a consumer that depends on `html_to_markdown_ffi_flutter` alone '
        'would not get the android adapter.',
      );
    });

    test('A2 — a plugin package without the app-facing dependency is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        fixture.write('packages/$packageName/pubspec.yaml', completeManifest);
      }
      fixture.write(
        'packages/html_to_markdown_ffi_flutter/pubspec.yaml',
        manifestWithoutAppFacing,
      );

      final violations = subject.subject_a2(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'html_to_markdown_ffi_flutter does not depend on '
        'html_to_markdown_ffi — a consumer that depends on '
        '`html_to_markdown_ffi_flutter` alone would not get the app-facing '
        'API.',
      );
    });

    test('A2 — the plugin package carries the app-facing API', () {
      expect(subject.reExportFailure(), isNull);
    });

    test('A2 — a re-export that converts differently is reported', () {
      // Two entry points that convert the same HTML differently: the
      // re-export is not the app-facing conversion.
      final failure = subject.reExportFailure(
        pluginConvert: (html, {options}) =>
            const app.ConversionResult(content: '# probe'),
        directConvert: (html, {options}) =>
            const app.ConversionResult(content: '# other'),
      );

      expect(
        failure,
        'the re-exported conversion differs from the app-facing one: '
        '"# probe" vs "# other".',
      );
    });

    test('A2 — a re-export that does not convert is reported', () {
      final violations = subject.subject_a2(
        failureProbe: () => 'the conversion produced no content.',
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'html_to_markdown_ffi_flutter does not carry the app-facing API: the '
        'conversion produced no content.',
      );
    });

    test('A2 — every platform the behavior names is checked', () {
      expect(
        subject.expectedDefaultPackages.keys.toSet(),
        <String>{'android', 'ios', 'macos'},
      );
    });
  });
}
