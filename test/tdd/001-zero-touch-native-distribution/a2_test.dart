// GENERATED TEST — `zfa tdd gen A2` (spec 044-test-tdd-generation).
//
// behavior_id: A2
// source_criterion: AC-2
// kind: acceptance
// description: the Rust native library is packaged into the app from the Android adapter package's own `jniLibs`, and the consumer's project files contain no reference to the native library.
//
// This test asserts the observable behavior described above. It is
// "honest red" on first execution: the paired subject at
// `package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/a2_subject.dart` is unimplemented, so the test fails through an
// assertion (not an uncaught error, compile/load error, skip, or
// placeholder). Replace the subject's
// stub body with real implementation to make this test pass.
// zfa:tdd: A2:hand — hand step completed before first red certification (issue #1411)
library;

import 'package:test/test.dart';
import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/a2_subject.dart' as subject;
import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/family_layout.dart';

import 'fixtures.dart';

void main() {
  group('A2 (AC-2)', () {
    test('A2 — the Rust native library is packaged into the app from the Android adapter package\'s own `jniLibs`, and the consumer\'s project files contain no reference to the native library.', () {
      final Object? result = (() {
        try {
          subject.subject_a2();
          return null;
        } on UnimplementedError catch (error) {
          return error;
        }
      })();
      expect(result, isNot(isA<UnimplementedError>()));
      // The observable outcome of the scenario: the Android adapter packages the native library from its own `jniLibs` — no consumer project change.
      expect(subject.subject_a2(), isEmpty);
    });

    group('the Android native libraries', () {
      test('A2 — a healthy jniLibs tree reports no violation', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        expect(
          subject.checkAndroidLibraries(
            fixture.directory(
              'packages/html_to_markdown_ffi_android/android/src/main/jniLibs',
            ),
            androidAbis,
          ),
          isEmpty,
        );
      });

      test('A2 — a missing ABI is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.delete(
          'packages/html_to_markdown_ffi_android/android/src/main/jniLibs/'
          'arm64-v8a/libhtml_to_markdown_ffi.so',
        );
        final violations = subject.checkAndroidLibraries(
          fixture.directory(
            'packages/html_to_markdown_ffi_android/android/src/main/jniLibs',
          ),
          androidAbis,
        );
        expect(violations, contains('The Android adapter ships no library for arm64-v8a.'));
        expect(violations, hasLength(1));
      });

      test('A2 — a library that is not an ELF is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.writeBytes(
          'packages/html_to_markdown_ffi_android/android/src/main/jniLibs/'
          'arm64-v8a/libhtml_to_markdown_ffi.so',
          <int>[0x00, 0x01, 0x02, 0x03, 0x04, ...'htm_convert'.codeUnits],
        );
        final violations = subject.checkAndroidLibraries(
          fixture.directory(
            'packages/html_to_markdown_ffi_android/android/src/main/jniLibs',
          ),
          androidAbis,
        );
        expect(violations, contains('The arm64-v8a library is not an ELF shared object.'));
        expect(violations, hasLength(1));
      });

      test('A2 — a library without the entry point is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.writeBytes(
          'packages/html_to_markdown_ffi_android/android/src/main/jniLibs/'
          'arm64-v8a/libhtml_to_markdown_ffi.so',
          fakeElfBytes(exportsEntryPoint: false),
        );
        final violations = subject.checkAndroidLibraries(
          fixture.directory(
            'packages/html_to_markdown_ffi_android/android/src/main/jniLibs',
          ),
          androidAbis,
        );
        expect(violations, contains('The arm64-v8a library does not export htm_convert.'));
        expect(violations, hasLength(1));
      });
    });

    group('the Android Gradle module', () {
      test('A2 — a healthy Gradle module reports no violation', () {
        expect(
          subject.checkAndroidGradle(
            'android {\n    sourceSets {\n'
            '        jniLibs.srcDirs = ["src/main/jniLibs"]\n'
            '    }\n}\n',
          ),
          isEmpty,
        );
      });

      test('A2 — a missing Gradle module is reported', () {
        final violations = subject.checkAndroidGradle(null);
        expect(violations, contains('The Android adapter ships no Gradle module.'));
        expect(violations, hasLength(1));
      });

      test('A2 — a Gradle module that packages no jniLibs is reported', () {
        final violations = subject.checkAndroidGradle(
          'android {\n    sourceSets {\n    }\n}\n',
        );
        expect(violations, contains('The Android Gradle module packages no `jniLibs`.'));
        expect(violations, hasLength(1));
      });
    });

    group('the Android manifest', () {
      test('A2 — a present manifest reports no violation', () {
        expect(subject.checkAndroidManifest(true), isEmpty);
      });

      test('A2 — a missing manifest is reported', () {
        final violations = subject.checkAndroidManifest(false);
        expect(violations, contains('The Android adapter ships no manifest.'));
        expect(violations, hasLength(1));
      });
    });

    group('the scenario over a broken family', () {
      test('A2 — a healthy family reports no violation', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        expect(subject.subject_a2(layout: RepoLayout(fixture.root)), isEmpty);
      });

      test('A2 — a family whose Gradle module stopped packaging jniLibs is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.write(
          'packages/html_to_markdown_ffi_android/android/build.gradle',
          'android {\n    sourceSets {\n    }\n}\n',
        );
        expect(
          subject.subject_a2(layout: RepoLayout(fixture.root)),
          contains('The Android Gradle module packages no `jniLibs`.'),
        );
      });

      test('A2 — a family that lost the `ffiPlugin` declaration is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.write(
          'packages/html_to_markdown_ffi_android/pubspec.yaml',
          goodMemberPubspec('html_to_markdown_ffi_android'),
        );
        expect(
          subject.subject_a2(layout: RepoLayout(fixture.root)),
          contains('The android adapter does not declare `ffiPlugin: true`.'),
        );
      });
    });
  });
}
