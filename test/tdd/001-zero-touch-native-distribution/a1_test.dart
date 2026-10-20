// GENERATED TEST — `zfa tdd gen A1` (spec 044-test-tdd-generation).
//
// behavior_id: A1
// source_criterion: AC-1
// kind: acceptance
// description: the Rust native library is linked into the app by the macOS adapter package's own Swift package (a `binaryTarget` over the shipped xcframework), and the consumer's project files contain no reference to the native library.
//
// This test asserts the observable behavior described above. It is
// "honest red" on first execution: the paired subject at
// `package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/a1_subject.dart` is unimplemented, so the test fails through an
// assertion (not an uncaught error, compile/load error, skip, or
// placeholder). Replace the subject's
// stub body with real implementation to make this test pass.
// zfa:tdd: A1:hand — hand step completed before first red certification (issue #1411)
library;

import 'package:test/test.dart';
import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/a1_subject.dart' as subject;
import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/family_layout.dart';

import 'fixtures.dart';

void main() {
  group('A1 (AC-1)', () {
    test('A1 — the Rust native library is linked into the app by the macOS adapter package\'s own Swift package (a `binaryTarget` over the shipped xcframework), and the consumer\'s project files contain no reference to the native library.', () {
      final Object? result = (() {
        try {
          subject.subject_a1();
          return null;
        } on UnimplementedError catch (error) {
          return error;
        }
      })();
      expect(result, isNot(isA<UnimplementedError>()));
      // The observable outcome of the scenario: the macOS adapter links the native library from its own Swift package — no consumer project change.
      expect(subject.subject_a1(), isEmpty);
    });

    group('the macOS Swift package', () {
      test('A1 — a healthy package reports no violation', () {
        expect(subject.checkMacosSwiftPackage(goodMacosManifest), isEmpty);
      });

      test('A1 — a missing package manifest is reported', () {
        final violations = subject.checkMacosSwiftPackage(null);
        expect(violations, contains('The macOS adapter ships no Swift package manifest.'));
        expect(violations, hasLength(1));
      });

      test('A1 — a package without a binaryTarget is reported', () {
        final violations = subject.checkMacosSwiftPackage(
          goodMacosManifest.replaceFirst('.binaryTarget(', '.sourceTarget('),
        );
        expect(violations, contains('The macOS Swift package declares no binaryTarget.'));
        expect(violations, hasLength(1));
      });

      test('A1 — a package that does not reference the native library is reported', () {
        final violations = subject.checkMacosSwiftPackage(
          goodMacosManifest.replaceAll('libhtml_to_markdown_ffi', 'native_core'),
        );
        expect(violations, contains('The macOS Swift package does not reference the native library.'));
        expect(violations, contains('The macOS Swift package does not point at the shipped xcframework.'));
      });

      test('A1 — a package that does not point at the xcframework is reported', () {
        final violations = subject.checkMacosSwiftPackage(
          goodMacosManifest.replaceFirst(
            'Frameworks/libhtml_to_markdown_ffi.xcframework',
            'Frameworks/libnative_core.xcframework',
          ),
        );
        expect(violations, contains('The macOS Swift package does not point at the shipped xcframework.'));
      });

      test('A1 — a product name Flutter cannot look up is reported', () {
        final violations = subject.checkMacosSwiftPackage(
          goodMacosManifest.replaceFirst(
            'name: "html-to-markdown-ffi-macos"',
            'name: "html_to_markdown_ffi_macos"',
          ),
        );
        expect(violations, contains('The macOS Swift package declares no product named "html-to-markdown-ffi-macos".'));
        expect(violations, hasLength(1));
      });

      test('A1 — a static product is reported, because the archive is dead-stripped', () {
        final violations = subject.checkMacosSwiftPackage(
          goodMacosManifest.replaceFirst('type: .dynamic', 'type: .static'),
        );
        expect(violations, contains('The macOS Swift package product is not dynamic.'));
        expect(violations, hasLength(1));
      });

      test('A1 — a package without a link anchor is reported', () {
        final violations = subject.checkMacosSwiftPackage(
          goodMacosManifest.replaceAll(
            'html_to_markdown_ffi_macos_anchor',
            'html_to_markdown_ffi_macos_link',
          ),
        );
        expect(violations, contains('The macOS Swift package ships no link anchor target.'));
        expect(violations, hasLength(1));
      });
    });

    group('the macOS xcframework', () {
      test('A1 — a healthy xcframework reports no violation', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        expect(
          subject.checkMacosXcframework(
            fixture.directory(
              'packages/html_to_markdown_ffi_macos/macos/'
              'html_to_markdown_ffi_macos/Frameworks/'
              'libhtml_to_markdown_ffi.xcframework',
            ),
          ),
          isEmpty,
        );
      });

      test('A1 — a missing xcframework is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        final violations = subject.checkMacosXcframework(
          fixture.directory('packages/absent.xcframework'),
        );
        expect(violations, contains('The macOS adapter ships no xcframework.'));
        expect(violations, hasLength(1));
      });

      test('A1 — an xcframework without an archive is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        final dir = fixture.directory('empty.xcframework')..createSync(recursive: true);
        fixture.write(
          'empty.xcframework/Info.plist',
          '<plist><dict><key>LibraryIdentifier</key>'
          '<string>macos-arm64</string></dict></plist>\n',
        );
        final violations = subject.checkMacosXcframework(dir);
        expect(violations, contains('The macOS xcframework carries no static archive.'));
        expect(violations, hasLength(1));
      });

      test('A1 — an archive that is not a static archive is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        final dir = fixture.directory('broken.xcframework')..createSync(recursive: true);
        fixture.writeBytes(
          'broken.xcframework/libhtml_to_markdown_ffi.a',
          <int>[0x00, 0x01, 0x02, 0x03, 0x04],
        );
        final violations = subject.checkMacosXcframework(dir);
        expect(
          violations,
          contains(
            'The macOS xcframework archive ${dir.path}/libhtml_to_markdown_ffi.a '
            'is not a static archive.',
          ),
        );
      });

      test('A1 — an archive without the entry point is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        final dir = fixture.directory('symbol-less.xcframework')..createSync(recursive: true);
        fixture.writeBytes(
          'symbol-less.xcframework/libhtml_to_markdown_ffi.a',
          fakeArchiveBytes(exportsEntryPoint: false),
        );
        final violations = subject.checkMacosXcframework(dir);
        expect(
          violations,
          contains(
            'The macOS xcframework archive '
            '${dir.path}/libhtml_to_markdown_ffi.a does not export htm_convert.',
          ),
        );
      });

      test('A1 — an xcframework that declares no macOS library is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        final dir = fixture.directory('no-plist.xcframework')..createSync(recursive: true);
        fixture.writeBytes(
          'no-plist.xcframework/libhtml_to_markdown_ffi.a',
          fakeArchiveBytes(),
        );
        final violations = subject.checkMacosXcframework(dir);
        expect(violations, contains('The macOS xcframework declares no macOS library.'));
      });
    });

    group('the scenario over a broken family', () {
      test('A1 — a healthy family reports no violation', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        expect(subject.subject_a1(layout: RepoLayout(fixture.root)), isEmpty);
      });

      test('A1 — a family whose macOS package lost its link anchor is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.write(
          'packages/html_to_markdown_ffi_macos/macos/html_to_markdown_ffi_macos/'
          'Package.swift',
          goodMacosManifest.replaceAll(
            'html_to_markdown_ffi_macos_anchor',
            'html_to_markdown_ffi_macos_link',
          ),
        );
        expect(
          subject.subject_a1(layout: RepoLayout(fixture.root)),
          contains('The macOS Swift package ships no link anchor target.'),
        );
      });

      test('A1 — a family that ships consumer project wiring is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.write(
          'packages/html_to_markdown_ffi_macos/macos/Consumer.xcconfig',
          'OTHER_LDFLAGS = -lhtml_to_markdown_ffi\n',
        );
        expect(
          subject.subject_a1(layout: RepoLayout(fixture.root)),
          contains(
            'The family ships consumer project wiring: packages/'
            'html_to_markdown_ffi_macos/macos/Consumer.xcconfig',
          ),
        );
      });
    });
  });
}
