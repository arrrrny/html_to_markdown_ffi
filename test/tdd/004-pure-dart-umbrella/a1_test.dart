// GENERATED TEST — `zfa tdd gen A1` (spec 044-test-tdd-generation).
//
// behavior_id: A1
// source_criterion: AC-1
// kind: acceptance
// description: the resolution succeeds — the package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency, and it depends on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.
//
// This test asserts the observable behavior described above. It is
// "honest red" on first execution: the paired subject at
// `package:html_to_markdown_ffi_workspace/tdd/004-pure-dart-umbrella/a1_subject.dart` is unimplemented, so the test fails through an
// assertion (not an uncaught error, compile/load error, skip, or
// placeholder). Replace the subject's
// stub body with real implementation to make the test pass.
//
// zfa:tdd: A1:hand — hand step completed before first red certification (issue #1411)
library;

import 'package:test/test.dart';
import 'package:html_to_markdown_ffi/html_to_markdown.dart' as app;
import 'package:html_to_markdown_ffi_workspace/tdd/004-pure-dart-umbrella/a1_subject.dart' as subject;
import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/family_layout.dart';

import '../001-zero-touch-native-distribution/fixtures.dart';

/// A manifest that asks for nothing from the Flutter SDK.
const String plainPubspec = '''
name: html_to_markdown_ffi
version: 1.2.7

environment:
  sdk: ^3.11.0

dependencies:
  ffi: ^2.1.0
  zuraffa: ^7.2.0
  html_to_markdown_ffi_platform: ^1.2.7
''';

/// A manifest that constrains the Flutter SDK in its `environment:`.
const String environmentConstrainedPubspec = '''
name: html_to_markdown_ffi
version: 1.2.7

environment:
  sdk: ^3.11.0
  flutter: ">=3.27.0"

dependencies:
  html_to_markdown_ffi_platform: ^1.2.7
''';

/// A manifest that depends on the Flutter SDK.
const String sdkDependentPubspec = '''
name: html_to_markdown_ffi
version: 1.2.7

environment:
  sdk: ^3.11.0

dependencies:
  flutter:
    sdk: flutter
  html_to_markdown_ffi_platform: ^1.2.7
''';

/// A manifest that carries a plugin manifest.
const String pluginManifestPubspec = '''
name: html_to_markdown_ffi
version: 1.2.7

environment:
  sdk: ^3.11.0
  flutter: ">=3.27.0"

dependencies:
  html_to_markdown_ffi_platform: ^1.2.7

flutter:
  plugin:
    platforms:
      macos:
        default_package: html_to_markdown_ffi_macos
''';

/// A manifest that depends on a family member that asks for the Flutter
/// SDK.
const String adapterDependentPubspec = '''
name: html_to_markdown_ffi
version: 1.2.7

environment:
  sdk: ^3.11.0

dependencies:
  html_to_markdown_ffi_platform: ^1.2.7
  html_to_markdown_ffi_macos: ^1.2.7
  html_to_markdown_ffi_ios: ^1.2.7
''';

/// A member that asks for the Flutter SDK through its `environment:` only.
const String flutterConstrainedMemberPubspec = '''
name: html_to_markdown_ffi_macos
version: 1.2.7

environment:
  sdk: ^3.11.0
  flutter: ">=3.27.0"

dependencies:
  html_to_markdown_ffi_platform: ^1.2.7
''';

/// A member that asks for the Flutter SDK through a dependency only.
const String flutterSdkDependentMemberPubspec = '''
name: html_to_markdown_ffi_ios
version: 1.2.7

environment:
  sdk: ^3.11.0

dependencies:
  flutter:
    sdk: flutter
  html_to_markdown_ffi_platform: ^1.2.7
''';

/// A manifest that is not YAML at all.
const String malformedPubspec = 'name: html_to_markdown_ffi\nfoo: [1, 2\n';

void main() {
  group('A1 (AC-1)', () {
    test('A1 — the resolution succeeds — the package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency, and it depends on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.', () {
      final Object? result = (() {
        try {
          subject.subject_a1();
          return null;
        } on UnimplementedError catch (error) {
          return error;
        }
      })();
      expect(result, isNot(isA<UnimplementedError>()));
      // The observable outcome of the scenario: the shipped app-facing
      // package asks for no Flutter SDK and offers the conversion.
      expect(subject.subject_a1(), isEmpty);
    });

    test('A1 — the family names its pure-Dart app-facing package', () {
      expect(subject.appFacingPackage, 'html_to_markdown_ffi');
      expect(familyPackages, contains(subject.appFacingPackage));
    });

    test('A1 — a package that constrains the Flutter SDK is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        fixture.write('packages/$packageName/pubspec.yaml', plainPubspec);
      }
      fixture.write(
        'packages/html_to_markdown_ffi/pubspec.yaml',
        environmentConstrainedPubspec,
      );

      final violations = subject.subject_a1(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'html_to_markdown_ffi constrains the Flutter SDK in its '
        '`environment:` — a consumer with a plain Dart SDK cannot resolve '
        'it.',
      );
    });

    test('A1 — a package that depends on the Flutter SDK is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        fixture.write('packages/$packageName/pubspec.yaml', plainPubspec);
      }
      fixture.write(
        'packages/html_to_markdown_ffi/pubspec.yaml',
        sdkDependentPubspec,
      );

      final violations = subject.subject_a1(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'html_to_markdown_ffi depends on the Flutter SDK — a consumer with a '
        'plain Dart SDK cannot resolve it.',
      );
    });

    test('A1 — a package that carries a plugin manifest is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        fixture.write('packages/$packageName/pubspec.yaml', plainPubspec);
      }
      fixture.write(
        'packages/html_to_markdown_ffi/pubspec.yaml',
        pluginManifestPubspec,
      );

      final violations = subject.subject_a1(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(2));
      expect(
        violations,
        contains(
          'html_to_markdown_ffi carries a plugin manifest — pub.dev requires '
          'a Flutter SDK constraint beside one, which locks a consumer with '
          'a plain Dart SDK out.',
        ),
      );
    });

    test('A1 — a package that depends on a Flutter-requiring member is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        fixture.write('packages/$packageName/pubspec.yaml', plainPubspec);
      }
      fixture.write(
        'packages/html_to_markdown_ffi_macos/pubspec.yaml',
        flutterConstrainedMemberPubspec,
      );
      fixture.write(
        'packages/html_to_markdown_ffi_ios/pubspec.yaml',
        flutterSdkDependentMemberPubspec,
      );
      fixture.write(
        'packages/html_to_markdown_ffi/pubspec.yaml',
        adapterDependentPubspec,
      );

      final violations = subject.subject_a1(
        layout: RepoLayout(fixture.root),
      );

      // A member that asks for the Flutter SDK through its `environment:` and
      // a member that asks through a dependency both lock the consumer out.
      expect(violations, hasLength(2));
      expect(
        violations,
        contains(
          'html_to_markdown_ffi depends on html_to_markdown_ffi_macos, which '
          'asks for the Flutter SDK — a consumer with a plain Dart SDK cannot '
          'resolve it.',
        ),
      );
      expect(
        violations,
        contains(
          'html_to_markdown_ffi depends on html_to_markdown_ffi_ios, which '
          'asks for the Flutter SDK — a consumer with a plain Dart SDK cannot '
          'resolve it.',
        ),
      );
    });

    test('A1 — a missing package is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        if (packageName == subject.appFacingPackage) continue;
        fixture.write('packages/$packageName/pubspec.yaml', plainPubspec);
      }

      final violations = subject.subject_a1(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'The family ships no html_to_markdown_ffi package — a consumer that '
        'is not a Flutter app has no entry point.',
      );
    });

    test('A1 — a manifest that is not YAML is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        fixture.write('packages/$packageName/pubspec.yaml', plainPubspec);
      }
      fixture.write(
        'packages/html_to_markdown_ffi/pubspec.yaml',
        malformedPubspec,
      );

      final violations = subject.subject_a1(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'html_to_markdown_ffi ships a manifest that is not readable YAML — '
        'what it asks of a consumer cannot be read.',
      );
    });

    test('A1 — the entry point offers the conversion', () {
      expect(subject.conversionEntryPointFailure(), isNull);
    });

    test('A1 — the entry point offers the native-library loader', () {
      // A pure-Dart consumer does not bundle the native library, so the
      // entry point has to offer the download as well as the conversion.
      final Object loader = app.NativeLibrary.downloadIfNeeded;
      expect(loader, isA<Future<bool> Function()>());
    });

    test('A1 — an entry point that does not convert is reported', () {
      final violations = subject.subject_a1(
        failureProbe: () => 'the conversion produced no content.',
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'html_to_markdown_ffi does not offer the conversion through its '
        'public entry point: the conversion produced no content.',
      );
    });

    test('A1 — every Flutter-requiring member is checked', () {
      expect(
        subject.flutterSdkPackages(RepoLayout.repository()).toSet(),
        <String>{
          'html_to_markdown_ffi_flutter',
          'html_to_markdown_ffi_android',
          'html_to_markdown_ffi_ios',
          'html_to_markdown_ffi_macos',
        },
      );
    });
  });
}
