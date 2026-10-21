// GENERATED TEST — `zfa tdd gen A4` (spec 044-test-tdd-generation).
//
// behavior_id: A4
// source_criterion: AC-4
// kind: acceptance
// description: the conversion goes through the shared `zuraffa_ffi_platform` envelope, and the adapter declares no envelope of its own.
//
// This test asserts the observable behavior described above. It is
// "honest red" on first execution: the paired subject at
// `package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/a4_subject.dart` is unimplemented, so the test fails through an
// assertion (not an uncaught error, compile/load error, skip, or
// placeholder). Replace the subject's
// stub body with real implementation to make this test pass.
// zfa:tdd: A4:hand — hand step completed before first red certification (issue #1411)
library;

import 'package:test/test.dart';
import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/a4_subject.dart' as subject;
import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/family_layout.dart';

import 'fixtures.dart';

void main() {
  group('A4 (AC-4)', () {
    test('A4 — the conversion goes through the shared `zuraffa_ffi_platform` envelope, and the adapter declares no envelope of its own.', () {
      final Object? result = (() {
        try {
          subject.subject_a4();
          return null;
        } on UnimplementedError catch (error) {
          return error;
        }
      })();
      expect(result, isNot(isA<UnimplementedError>()));
      // The observable outcome of the scenario: the conversion runs on the shared `zuraffa_ffi_platform` envelope — the family declares no envelope of its own.
      expect(subject.subject_a4(), isEmpty);
    });

    group('the shared envelope', () {
      test('A4 — an envelope that is the shared one reports no violation', () {
        expect(subject.checkSharedEnvelope(true), isEmpty);
      });

      test('A4 — an envelope of its own is reported', () {
        final violations = subject.checkSharedEnvelope(false);
        expect(
          violations,
          contains(
            'The html family envelope is not the shared zuraffa_ffi_platform '
            'envelope.',
          ),
        );
        expect(violations, hasLength(1));
      });
    });

    group('the envelope source', () {
      test('A4 — a healthy envelope source reports no violation', () {
        expect(subject.checkEnvelopeSource(goodEnvelopeSource), isEmpty);
      });

      test('A4 — a missing envelope source is reported', () {
        final violations = subject.checkEnvelopeSource(null);
        expect(violations, contains('The html family ships no envelope source.'));
        expect(violations, hasLength(1));
      });

      test('A4 — an envelope class of its own is reported', () {
        final violations = subject.checkEnvelopeSource(
          goodEnvelopeSource.replaceFirst(
            'typedef PlatformHtmlToMarkdownFfiEnvelope = PlatformFfiEnvelope;',
            'class PlatformHtmlToMarkdownFfiEnvelope {}',
          ),
        );
        expect(violations, contains('The html family declares an envelope class of its own.'));
        expect(violations, contains('The html family envelope is not an alias of the shared envelope.'));
      });

      test('A4 — an envelope that is not an alias of the shared one is reported', () {
        final violations = subject.checkEnvelopeSource(
          goodEnvelopeSource.replaceFirst(
            'typedef PlatformHtmlToMarkdownFfiEnvelope = PlatformFfiEnvelope;',
            'class PlatformHtmlToMarkdownFfiEnvelope {}',
          ),
        );
        expect(
          violations,
          contains('The html family envelope is not an alias of the shared envelope.'),
        );
      });
    });

    group('the shared envelope dependency', () {
      test('A4 — a constraint that admits the shared release reports no violation', () {
        expect(subject.checkSharedConstraint('^0.2.1'), isEmpty);
      });

      test('A4 — a missing dependency is reported', () {
        final violations = subject.checkSharedConstraint(null);
        expect(
          violations,
          contains('The html platform package declares no `zuraffa_ffi_platform` dependency.'),
        );
        expect(violations, hasLength(1));
      });

      test('A4 — a constraint below the shared release but still admitting it is reported as valid', () {
        // `^0.2.0` has a lower floor than 0.2.1 but still admits it: pub's
        // caret in the `0.x` line spans the whole minor.
        expect(subject.checkSharedConstraint('^0.2.0'), isEmpty);
      });

      test('A4 — a constraint that does not admit the shared release is reported', () {
        final violations = subject.checkSharedConstraint('^0.1.0');
        expect(
          violations,
          contains(
            'The html platform package does not depend on a shared envelope '
            'core that carries 0.2.1 (constraint: ^0.1.0).',
          ),
        );
        expect(violations, hasLength(1));
      });
    });

    group('the scenario over a broken family', () {
      test('A4 — a healthy family reports no violation', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        expect(subject.subject_a4(layout: RepoLayout(fixture.root)), isEmpty);
      });

      test('A4 — a family that dropped the shared envelope dependency is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.write(
          'packages/html_to_markdown_ffi_platform/pubspec.yaml',
          goodMemberPubspec('html_to_markdown_ffi_platform'),
        );
        expect(
          subject.subject_a4(layout: RepoLayout(fixture.root)),
          contains('The html platform package declares no `zuraffa_ffi_platform` dependency.'),
        );
      });

      test('A4 — a family that re-implements the envelope is reported', () {
        final fixture = Fixture.create();
        addTearDown(fixture.dispose);
        buildHealthyFamily(fixture);
        fixture.write(
          'packages/html_to_markdown_ffi_platform/lib/src/'
          'platform_html_to_markdown_ffi_envelope.dart',
          goodEnvelopeSource.replaceFirst(
            'typedef PlatformHtmlToMarkdownFfiEnvelope = PlatformFfiEnvelope;',
            'class PlatformHtmlToMarkdownFfiEnvelope {}',
          ),
        );
        expect(
          subject.subject_a4(layout: RepoLayout(fixture.root)),
          contains('The html family declares an envelope class of its own.'),
        );
      });
    });
  });
}
