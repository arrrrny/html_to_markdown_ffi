// GENERATED TEST — `zfa tdd gen A3` (spec 044-test-tdd-generation).
//
// behavior_id: A3
// source_criterion: AC-3
// kind: acceptance
// description: the Rust native library is linked into the app by the iOS adapter package's own Swift package, exactly as the macOS adapter does.
//
// This test asserts the observable behavior described above. It is
// "honest red" on first execution: the paired subject at
// `package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/a3_subject.dart` is unimplemented, so the test fails through an
// assertion (not an uncaught error, compile/load error, skip, or
// placeholder). Replace the subject's
// stub body with real implementation to make this test pass.
// zfa:tdd: A3:hand — hand step completed before first red certification (issue #1411)
library;

import 'package:test/test.dart';
import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/a3_subject.dart' as subject;
import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/family_layout.dart';

import 'fixtures.dart';

void main() {
  group('A3 (AC-3)', () {
    test('A3 — the Rust native library is linked into the app by the iOS adapter package\'s own Swift package, exactly as the macOS adapter does.', () {
      final Object? result = (() {
        try {
          subject.subject_a3();
          return null;
        } on UnimplementedError catch (error) {
          return error;
        }
      })();
      expect(result, isNot(isA<UnimplementedError>()));
      // The observable outcome of the scenario: the iOS adapter links the native library from its own Swift package, exactly like the macOS adapter.
      expect(subject.subject_a3(), isEmpty);
    });

    group('the iOS Swift package', () {
      test('A3 — a healthy package reports no violation', () {
        expect(subject.checkIosSwiftPackage(goodIosManifest), isEmpty);
      });

      test('A3 — a missing package manifest is reported', () {
        final violations = subject.checkIosSwiftPackage(null);
        expect(violations, contains('The iOS adapter ships no Swift package manifest.'));
        expect(violations, hasLength(1));
      });

      test('A3 — a package without a binaryTarget is reported', () {
        final violations = subject.checkIosSwiftPackage(
          goodIosManifest.replaceFirst('.binaryTarget(', '.sourceTarget('),
        );
        expect(violations, contains('The iOS Swift package declares no binaryTarget.'));
        expect(violations, hasLength(1));
      });

      test('A3 — a package that does not reference the native library is reported', () {
        final violations = subject.checkIosSwiftPackage(
          goodIosManifest.replaceAll('libhtml_to_markdown_ffi', 'native_core'),
        );
        expect(violations, contains('The iOS Swift package does not reference the native library.'));
        expect(violations, contains('The iOS Swift package does not point at the shipped xcframework.'));
      });

      test('A3 — a package that does not point at the xcframework is reported', () {
        final violations = subject.checkIosSwiftPackage(
          goodIosManifest.replaceFirst(
            'Frameworks/libhtml_to_markdown_ffi.xcframework',
            'Frameworks/libnative_core.xcframework',
          ),
        );
        expect(violations, contains('The iOS Swift package does not point at the shipped xcframework.'));
      });

      test('A3 — a product name Flutter cannot look up is reported', () {
        final violations = subject.checkIosSwiftPackage(
          goodIosManifest.replaceFirst(
            'name: "html-to-markdown-ffi-ios"',
            'name: "html_to_markdown_ffi_ios"',
          ),
        );
        expect(violations, contains('The iOS Swift package declares no product named "html-to-markdown-ffi-ios".'));
        expect(violations, hasLength(1));
      });

      test('A3 — a static product is reported, because the archive is dead-stripped', () {
        final violations = subject.checkIosSwiftPackage(
          goodIosManifest.replaceFirst('type: .dynamic', 'type: .static'),
        );
        expect(violations, contains('The iOS Swift package product is not dynamic.'));
        expect(violations, hasLength(1));
      });

      test('A3 — a package without a link anchor is reported', () {
        final violations = subject.checkIosSwiftPackage(
          goodIosManifest.replaceAll(
            'html_to_markdown_ffi_ios_anchor',
            'html_to_markdown_ffi_ios_link',
          ),
        );
        expect(violations, contains('The iOS Swift package ships no link anchor target.'));
        expect(violations, hasLength(1));
      });
    });

    group('the iOS xcframework', () {
      test('A3 — a healthy xcframework reports no violation', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        expect(
          subject.checkIosXcframework(
            fixture.directory(
              'packages/html_to_markdown_ffi_ios/ios/html_to_markdown_ffi_ios/'
              'Frameworks/libhtml_to_markdown_ffi.xcframework',
            ),
          ),
          isEmpty,
        );
      });

      test('A3 — a missing xcframework is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        final violations = subject.checkIosXcframework(
          fixture.directory('packages/absent.xcframework'),
        );
        expect(violations, contains('The iOS adapter ships no xcframework.'));
        expect(violations, hasLength(1));
      });

      test('A3 — an xcframework without an archive is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        final dir = fixture.directory('empty.xcframework')..createSync(recursive: true);
        final violations = subject.checkIosXcframework(dir);
        expect(violations, contains('The iOS xcframework carries no static archive.'));
        expect(violations, hasLength(1));
      });

      test('A3 — an archive that is not a static archive is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        final dir = fixture.directory('broken.xcframework')..createSync(recursive: true);
        fixture.writeBytes(
          'broken.xcframework/libhtml_to_markdown_ffi.a',
          <int>[0x00, 0x01, 0x02, 0x03, 0x04],
        );
        final violations = subject.checkIosXcframework(dir);
        expect(
          violations,
          contains(
            'The iOS xcframework archive ${dir.path}/libhtml_to_markdown_ffi.a '
            'is not a static archive.',
          ),
        );
      });

      test('A3 — an archive without the entry point is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        final dir = fixture.directory('symbol-less.xcframework')..createSync(recursive: true);
        fixture.writeBytes(
          'symbol-less.xcframework/libhtml_to_markdown_ffi.a',
          fakeArchiveBytes(exportsEntryPoint: false),
        );
        final violations = subject.checkIosXcframework(dir);
        expect(
          violations,
          contains(
            'The iOS xcframework archive '
            '${dir.path}/libhtml_to_markdown_ffi.a does not export htm_convert.',
          ),
        );
      });
    });

    group('the parity with the macOS adapter', () {
      test('A3 — two matching packages report no violation', () {
        expect(
          subject.checkSwiftPackageParity(
            goodIosManifest,
            goodMacosManifest,
            subject.a3ParityMarkers,
          ),
          isEmpty,
        );
      });

      test('A3 — a missing iOS manifest is left to the iOS check', () {
        expect(
          subject.checkSwiftPackageParity(null, goodMacosManifest, subject.a3ParityMarkers),
          isEmpty,
        );
      });

      test('A3 — a missing macOS manifest is reported', () {
        final violations = subject.checkSwiftPackageParity(
          goodIosManifest,
          null,
          subject.a3ParityMarkers,
        );
        expect(violations, contains('The macOS adapter ships no Swift package manifest.'));
        expect(violations, hasLength(1));
      });

      test('A3 — a marker the iOS package lacks is reported', () {
        final violations = subject.checkSwiftPackageParity(
          goodIosManifest.replaceFirst('type: .dynamic', 'type: .static'),
          goodMacosManifest,
          subject.a3ParityMarkers,
        );
        expect(
          violations,
          contains('The iOS Swift package differs from the macOS one: type: .dynamic'),
        );
      });

      test('A3 — a marker the macOS package lacks is reported', () {
        final violations = subject.checkSwiftPackageParity(
          goodIosManifest,
          goodMacosManifest.replaceFirst('type: .dynamic', 'type: .static'),
          subject.a3ParityMarkers,
        );
        expect(
          violations,
          contains('The macOS Swift package differs from the iOS one: type: .dynamic'),
        );
      });
    });

    group('the scenario over a broken family', () {
      test('A3 — a healthy family reports no violation', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        expect(subject.subject_a3(layout: RepoLayout(fixture.root)), isEmpty);
      });

      test('A3 — a family whose iOS package lost its link anchor is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.write(
          'packages/html_to_markdown_ffi_ios/ios/html_to_markdown_ffi_ios/'
          'Package.swift',
          goodIosManifest.replaceAll(
            'html_to_markdown_ffi_ios_anchor',
            'html_to_markdown_ffi_ios_link',
          ),
        );
        expect(
          subject.subject_a3(layout: RepoLayout(fixture.root)),
          contains('The iOS Swift package ships no link anchor target.'),
        );
      });

      test('A3 — a family whose iOS package is not dynamic is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.write(
          'packages/html_to_markdown_ffi_ios/ios/html_to_markdown_ffi_ios/'
          'Package.swift',
          goodIosManifest.replaceFirst('type: .dynamic', 'type: .static'),
        );
        expect(
          subject.subject_a3(layout: RepoLayout(fixture.root)),
          contains('The iOS Swift package product is not dynamic.'),
        );
      });
    });
  });
}
