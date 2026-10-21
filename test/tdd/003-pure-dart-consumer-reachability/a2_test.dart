// GENERATED TEST — `zfa tdd gen A2` (spec 044-test-tdd-generation).
//
// behavior_id: A2
// source_criterion: AC-2
// kind: acceptance
// description: it still names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, and still carries the Flutter SDK constraint that a plugin manifest requires — so the zero-touch distribution of `001-zero-touch-native-distribution` survives.
//
// This test asserts the observable behavior described above. It is
// "honest red" on first execution: the paired subject at
// `package:html_to_markdown_ffi_workspace/tdd/003-pure-dart-consumer-reachability/a2_subject.dart` is unimplemented, so the test fails through an
// assertion (not an uncaught error, compile/load error, skip, or
// placeholder). Replace the subject's
// stub body with real implementation to make the test pass.
//
// zfa:tdd: A2:hand — hand step completed before first red certification (issue #1411)
library;

import 'package:test/test.dart';
import 'package:html_to_markdown_ffi_workspace/tdd/003-pure-dart-consumer-reachability/a2_subject.dart' as subject;
import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/family_layout.dart';

import '../001-zero-touch-native-distribution/fixtures.dart';

/// A manifest with all three `default_package` entries and the Flutter SDK
/// constraint.
const String completeManifest = '''
name: html_to_markdown_ffi
version: 1.2.5

environment:
  sdk: ^3.11.0
  flutter: ">=3.27.0"

dependencies:
  html_to_markdown_ffi_android: ^1.2.5
  html_to_markdown_ffi_ios: ^1.2.5
  html_to_markdown_ffi_macos: ^1.2.5

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

/// The app-facing manifest with the macOS entry dropped.
const String manifestWithoutMacos = '''
name: html_to_markdown_ffi
version: 1.2.5

environment:
  sdk: ^3.11.0
  flutter: ">=3.27.0"

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
name: html_to_markdown_ffi
version: 1.2.5

environment:
  sdk: ^3.11.0
  flutter: ">=3.27.0"

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
name: html_to_markdown_ffi
version: 1.2.5

environment:
  sdk: ^3.11.0

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
const String malformedManifest = 'name: html_to_markdown_ffi_android\nfoo: [1, 2\n';

void main() {
  group('A2 (AC-2)', () {
    test('A2 — it still names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, and still carries the Flutter SDK constraint that a plugin manifest requires — so the zero-touch distribution of `001-zero-touch-native-distribution` survives.', () {
      final Object? result = (() {
        try {
          subject.subject_a2();
          return null;
        } on UnimplementedError catch (error) {
          return error;
        }
      })();
      expect(result, isNot(isA<UnimplementedError>()));
      // The observable outcome of the scenario: the shipped family still
      // points every platform at its adapter, and every plugin package
      // still carries the constraint pub.dev requires.
      expect(subject.subject_a2(), isEmpty);
    });

    test('A2 — a platform without a `default_package` is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        fixture.write('packages/$packageName/pubspec.yaml', completeManifest);
      }
      fixture.write(
        'packages/html_to_markdown_ffi/pubspec.yaml',
        manifestWithoutMacos,
      );

      final violations = subject.subject_a2(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'The app-facing package does not name html_to_markdown_ffi_macos as '
        'the `default_package` for macos — a consumer that depends on '
        '`html_to_markdown_ffi` alone would not get the macos adapter.',
      );
    });

    test('A2 — a platform pointing at the wrong adapter is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        fixture.write('packages/$packageName/pubspec.yaml', completeManifest);
      }
      fixture.write(
        'packages/html_to_markdown_ffi/pubspec.yaml',
        manifestWithWrongAdapter,
      );

      final violations = subject.subject_a2(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'The app-facing package does not name html_to_markdown_ffi_android as '
        'the `default_package` for android — a consumer that depends on '
        '`html_to_markdown_ffi` alone would not get the android adapter.',
      );
    });

    test('A2 — a plugin package without the Flutter constraint is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        fixture.write('packages/$packageName/pubspec.yaml', completeManifest);
      }
      fixture.write(
        'packages/html_to_markdown_ffi_macos/pubspec.yaml',
        manifestWithoutFlutterConstraint,
      );

      final violations = subject.subject_a2(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'html_to_markdown_ffi_macos carries a plugin manifest but declares no '
        'Flutter SDK constraint in its `environment:` — pub.dev refuses to '
        'publish it.',
      );
    });

    test('A2 — an app-facing package with no pubspec is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        if (packageName == 'html_to_markdown_ffi') continue;
        fixture.write('packages/$packageName/pubspec.yaml', completeManifest);
      }

      final violations = subject.subject_a2(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(violations.single, 'The app-facing package ships no pubspec.');
    });

    test('A2 — a plugin package with no pubspec is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        if (packageName == 'html_to_markdown_ffi_ios') continue;
        fixture.write('packages/$packageName/pubspec.yaml', completeManifest);
      }

      final violations = subject.subject_a2(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(violations.single, 'html_to_markdown_ffi_ios ships no pubspec.');
    });

    test('A2 — a plugin package with an unreadable manifest is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        fixture.write('packages/$packageName/pubspec.yaml', completeManifest);
      }
      fixture.write(
        'packages/html_to_markdown_ffi_android/pubspec.yaml',
        malformedManifest,
      );

      final violations = subject.subject_a2(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'html_to_markdown_ffi_android ships a manifest that is not readable '
        'YAML — what it asks of a consumer cannot be read.',
      );
    });

    test('A2 — every platform the behavior names is checked', () {
      expect(
        subject.expectedDefaultPackages.keys.toSet(),
        <String>{'android', 'ios', 'macos'},
      );
      for (final entry in subject.expectedDefaultPackages.entries) {
        expect(
          subject.declaresDefaultPackage(
            completeManifest,
            entry.key,
            entry.value,
          ),
          isTrue,
          reason: '${entry.key} must name ${entry.value} as its default',
        );
      }
    });

    test('A2 — every plugin package is checked for the constraint', () {
      expect(
        subject.pluginPackages.toSet(),
        <String>{
          'html_to_markdown_ffi',
          'html_to_markdown_ffi_android',
          'html_to_markdown_ffi_ios',
          'html_to_markdown_ffi_macos',
        },
      );
    });
  });
}
