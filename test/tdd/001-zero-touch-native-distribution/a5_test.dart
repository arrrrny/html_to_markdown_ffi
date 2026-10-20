// GENERATED TEST — `zfa tdd gen A5` (spec 044-test-tdd-generation).
//
// behavior_id: A5
// source_criterion: AC-5
// kind: acceptance
// description: all five family packages resolve through one pub workspace on the latest zuraffa release, and every member carries the same release version.
//
// This test asserts the observable behavior described above. It is
// "honest red" on first execution: the paired subject at
// `package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/a5_subject.dart` is unimplemented, so the test fails through an
// assertion (not an uncaught error, compile/load error, skip, or
// placeholder). Replace the subject's
// stub body with real implementation to make this test pass.
// zfa:tdd: A5:hand — hand step completed before first red certification (issue #1411)
library;

import 'package:test/test.dart';
import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/a5_subject.dart' as subject;
import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/family_layout.dart';

import 'fixtures.dart';

void main() {
  group('A5 (AC-5)', () {
    test('A5 — all five family packages resolve through one pub workspace on the latest zuraffa release, and every member carries the same release version.', () {
      final Object? result = (() {
        try {
          subject.subject_a5();
          return null;
        } on UnimplementedError catch (error) {
          return error;
        }
      })();
      expect(result, isNot(isA<UnimplementedError>()));
      // The observable outcome of the scenario: the family resolves through one workspace on the latest zuraffa release, at one release version.
      expect(subject.subject_a5(), isEmpty);
    });

    group('the workspace root', () {
      test('A5 — a healthy root pubspec reports no violation', () {
        expect(subject.checkWorkspaceRoot(goodRootPubspec()), isEmpty);
      });

      test('A5 — a missing root pubspec is reported', () {
        final violations = subject.checkWorkspaceRoot(null);
        expect(violations, contains('The repository has no root pubspec.'));
        expect(violations, hasLength(1));
      });

      test('A5 — a root that declares no workspace is reported', () {
        final violations = subject.checkWorkspaceRoot(
          goodRootPubspec(declaresWorkspace: false),
        );
        expect(violations, contains('The repository root declares no pub workspace.'));
      });

      test('A5 — a root that leaves a member out of the workspace is reported', () {
        final violations = subject.checkWorkspaceRoot(
          without(goodRootPubspec(), '  - packages/html_to_markdown_ffi_macos\n'),
        );
        expect(
          violations,
          contains('The workspace does not list html_to_markdown_ffi_macos.'),
        );
      });

      test('A5 — a publishable root is reported', () {
        final violations = subject.checkWorkspaceRoot(
          goodRootPubspec(publishable: true),
        );
        expect(violations, contains('The workspace root is publishable.'));
      });
    });

    group('the workspace resolution', () {
      test('A5 — a healthy family reports no violation', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        expect(
          subject.checkMemberResolution(RepoLayout(fixture.root)),
          isEmpty,
        );
      });

      test('A5 — a member outside the workspace is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.write(
          'packages/html_to_markdown_ffi_macos/pubspec.yaml',
          goodMemberPubspec(
            'html_to_markdown_ffi_macos',
            ffiPlatform: 'macos',
            resolvesThroughWorkspace: false,
          ),
        );
        expect(
          subject.checkMemberResolution(RepoLayout(fixture.root)),
          contains('html_to_markdown_ffi_macos does not resolve through the workspace.'),
        );
      });

      test('A5 — a member without a pubspec is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.delete('packages/html_to_markdown_ffi_ios/pubspec.yaml');
        expect(
          subject.checkMemberResolution(RepoLayout(fixture.root)),
          contains('html_to_markdown_ffi_ios ships no pubspec.'),
        );
      });
    });

    group('the zuraffa release', () {
      test('A5 — a healthy family reports no violation', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        expect(
          subject.checkZuraffaRelease(RepoLayout(fixture.root)),
          isEmpty,
        );
      });

      test('A5 — a member that does not admit the latest zuraffa is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.write(
          'packages/html_to_markdown_ffi_macos/pubspec.yaml',
          goodMemberPubspec(
            'html_to_markdown_ffi_macos',
            ffiPlatform: 'macos',
            zuraffaConstraint: '^6.0.0',
          ),
        );
        expect(
          subject.checkZuraffaRelease(RepoLayout(fixture.root)),
          contains(
            'html_to_markdown_ffi_macos does not admit zuraffa 7.2.0 '
            '(constraint: ^6.0.0).',
          ),
        );
      });

      test('A5 — a member that declares no zuraffa dependency is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.write(
          'packages/html_to_markdown_ffi_macos/pubspec.yaml',
          without(
            goodMemberPubspec('html_to_markdown_ffi_macos', ffiPlatform: 'macos'),
            '  zuraffa: ^7.2.0\n',
          ),
        );
        expect(
          subject.checkZuraffaRelease(RepoLayout(fixture.root)),
          contains('html_to_markdown_ffi_macos declares no zuraffa dependency.'),
        );
      });

      test('A5 — a member on a different zuraffa constraint is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.write(
          'packages/html_to_markdown_ffi_macos/pubspec.yaml',
          goodMemberPubspec(
            'html_to_markdown_ffi_macos',
            ffiPlatform: 'macos',
            zuraffaConstraint: '^7.2.1',
          ),
        );
        expect(
          subject.checkZuraffaRelease(RepoLayout(fixture.root)),
          contains(
            'html_to_markdown_ffi_macos declares a different zuraffa '
            'constraint than the rest of the family (^7.2.1 vs ^7.2.0).',
          ),
        );
      });
    });

    group('the release version', () {
      test('A5 — a healthy family reports no violation', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        expect(
          subject.checkReleaseVersions(RepoLayout(fixture.root)),
          isEmpty,
        );
      });

      test('A5 — a member on a different version is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.write(
          'packages/html_to_markdown_ffi_macos/pubspec.yaml',
          goodMemberPubspec(
            'html_to_markdown_ffi_macos',
            ffiPlatform: 'macos',
            version: '1.2.2',
          ),
        );
        expect(
          subject.checkReleaseVersions(RepoLayout(fixture.root)),
          contains(
            'html_to_markdown_ffi_macos carries version 1.2.2 while the family '
            'carries 1.2.3.',
          ),
        );
      });

      test('A5 — a member without a version is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.write(
          'packages/html_to_markdown_ffi_macos/pubspec.yaml',
          without(
            goodMemberPubspec('html_to_markdown_ffi_macos', ffiPlatform: 'macos'),
            'version: 1.2.3\n',
          ),
        );
        expect(
          subject.checkReleaseVersions(RepoLayout(fixture.root)),
          contains('html_to_markdown_ffi_macos declares no version.'),
        );
      });
    });

    group('the scenario over a broken family', () {
      test('A5 — a healthy family reports no violation', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        expect(subject.subject_a5(layout: RepoLayout(fixture.root)), isEmpty);
      });

      test('A5 — a family that is not a workspace is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.write(
          'pubspec.yaml',
          goodRootPubspec(declaresWorkspace: false),
        );
        expect(
          subject.subject_a5(layout: RepoLayout(fixture.root)),
          contains('The repository root declares no pub workspace.'),
        );
      });
    });
  });
}
