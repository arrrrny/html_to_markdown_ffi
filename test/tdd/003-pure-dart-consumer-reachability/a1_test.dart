// GENERATED TEST — `zfa tdd gen A1` (spec 044-test-tdd-generation).
//
// behavior_id: A1
// source_criterion: AC-1
// kind: acceptance
// description: the resolution succeeds — that package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change.
//
// This test asserts the observable behavior described above. It is
// "honest red" on first execution: the paired subject at
// `package:html_to_markdown_ffi_workspace/tdd/003-pure-dart-consumer-reachability/a1_subject.dart` is unimplemented, so the test fails through an
// assertion (not an uncaught error, compile/load error, skip, or
// placeholder). Replace the subject's
// stub body with real implementation to make the test pass.
//
// zfa:tdd: A1:hand — hand step completed before first red certification (issue #1411)
library;

import 'package:test/test.dart';
import 'package:html_to_markdown_ffi_workspace/tdd/003-pure-dart-consumer-reachability/a1_subject.dart' as subject;
import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/family_layout.dart';

import '../001-zero-touch-native-distribution/fixtures.dart';

/// A manifest that asks for nothing from the Flutter SDK.
const String plainPubspec = '''
name: html_to_markdown_ffi_platform
version: 1.2.5

environment:
  sdk: ^3.11.0

dependencies:
  ffi: ^2.1.0
  zuraffa_ffi_platform: ^0.2.1
''';

/// A manifest that constrains the Flutter SDK in its `environment:`.
const String environmentConstrainedPubspec = '''
name: html_to_markdown_ffi_platform
version: 1.2.5

environment:
  sdk: ^3.11.0
  flutter: ">=3.27.0"

dependencies:
  ffi: ^2.1.0
''';

/// A manifest that depends on the Flutter SDK.
const String sdkDependentPubspec = '''
name: html_to_markdown_ffi_platform
version: 1.2.5

environment:
  sdk: ^3.11.0

dependencies:
  flutter:
    sdk: flutter
  ffi: ^2.1.0
''';

/// A manifest whose `flutter` dependency is a hosted package, next to a
/// sibling dependency that happens to be an SDK package.
const String hostedFlutterPubspec = '''
name: html_to_markdown_ffi_platform
version: 1.2.5

environment:
  sdk: ^3.11.0

dependencies:
  flutter:
    hosted: https://pub.dev
    version: ^1.0.0
  package:
    sdk: flutter
''';

/// A manifest that is not YAML at all.
const String malformedPubspec = 'name: html_to_markdown_ffi_platform\nfoo: [1, 2\n';

void main() {
  group('A1 (AC-1)', () {
    test('A1 — the resolution succeeds — that package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change.', () {
      final Object? result = (() {
        try {
          subject.subject_a1();
          return null;
        } on UnimplementedError catch (error) {
          return error;
        }
      })();
      expect(result, isNot(isA<UnimplementedError>()));
      // The observable outcome of the scenario: the shipped family's
      // Flutter-free entry point asks for no Flutter SDK and offers the
      // conversion.
      expect(subject.subject_a1(), isEmpty);
    });

    test('A1 — the family names its Flutter-free entry point', () {
      expect(subject.pureDartEntryPoint, 'html_to_markdown_ffi_platform');
      expect(familyPackages, contains(subject.pureDartEntryPoint));
    });

    test('A1 — an entry point that constrains the Flutter SDK is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        fixture.write('packages/$packageName/pubspec.yaml', plainPubspec);
      }
      fixture.write(
        'packages/html_to_markdown_ffi_platform/pubspec.yaml',
        environmentConstrainedPubspec,
      );

      final violations = subject.subject_a1(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'html_to_markdown_ffi_platform constrains the Flutter SDK in its '
        '`environment:` — a consumer with a plain Dart SDK cannot resolve '
        'it.',
      );
    });

    test('A1 — an entry point that depends on the Flutter SDK is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        fixture.write('packages/$packageName/pubspec.yaml', plainPubspec);
      }
      fixture.write(
        'packages/html_to_markdown_ffi_platform/pubspec.yaml',
        sdkDependentPubspec,
      );

      final violations = subject.subject_a1(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'html_to_markdown_ffi_platform depends on the Flutter SDK — a '
        'consumer with a plain Dart SDK cannot resolve it.',
      );
    });

    test('A1 — a missing entry point is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        if (packageName == subject.pureDartEntryPoint) continue;
        fixture.write('packages/$packageName/pubspec.yaml', plainPubspec);
      }

      final violations = subject.subject_a1(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'The family ships no html_to_markdown_ffi_platform package — a '
        'consumer that is not a Flutter app has no entry point.',
      );
    });

    test('A1 — a manifest that is not YAML is reported', () {
      final fixture = Fixture.create();
      addTearDown(fixture.dispose);
      for (final packageName in familyPackages) {
        fixture.write('packages/$packageName/pubspec.yaml', plainPubspec);
      }
      fixture.write(
        'packages/html_to_markdown_ffi_platform/pubspec.yaml',
        malformedPubspec,
      );

      final violations = subject.subject_a1(
        layout: RepoLayout(fixture.root),
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'html_to_markdown_ffi_platform ships a manifest that is not readable '
        'YAML — what it asks of a consumer cannot be read.',
      );
    });

    test('A1 — the plugin manifest is not mistaken for a requirement', () {
      final manifest = subject.Pubspec.parse(plainPubspec)!;

      expect(manifest.constrainsFlutterSdk, isFalse);
      expect(manifest.dependsOnFlutterSdk, isFalse);
      expect(subject.asksForFlutterSdk(manifest), isFalse);
    });

    test('A1 — both requirement shapes are recognised', () {
      final constrained = subject.Pubspec.parse(environmentConstrainedPubspec)!;
      final dependent = subject.Pubspec.parse(sdkDependentPubspec)!;

      expect(constrained.constrainsFlutterSdk, isTrue);
      expect(constrained.dependsOnFlutterSdk, isFalse);
      expect(subject.asksForFlutterSdk(constrained), isTrue);
      expect(dependent.constrainsFlutterSdk, isFalse);
      expect(dependent.dependsOnFlutterSdk, isTrue);
      expect(subject.asksForFlutterSdk(dependent), isTrue);
    });

    test('A1 — a `sdk: flutter` of another dependency is not this one', () {
      final manifest = subject.Pubspec.parse(hostedFlutterPubspec)!;

      expect(
        manifest.dependsOnFlutterSdk,
        isFalse,
        reason: 'the hosted `flutter` package is not the Flutter SDK',
      );
    });

    test('A1 — the entry point offers the conversion', () {
      expect(subject.conversionEntryPointFailure(), isNull);
    });

    test('A1 — an entry point that does not convert is reported', () {
      final violations = subject.subject_a1(
        failureProbe: () => 'the conversion produced no content.',
      );

      expect(violations, hasLength(1));
      expect(
        violations.single,
        'html_to_markdown_ffi_platform does not offer the conversion through '
        'its public entry point: the conversion produced no content.',
      );
    });
  });
}
