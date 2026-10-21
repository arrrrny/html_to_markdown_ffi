// GENERATED TEST — `zfa tdd gen A1` (spec 044-test-tdd-generation).
//
// behavior_id: A1
// source_criterion: AC-1
// kind: acceptance
// description: the shared conversion contract and all three platform adapters — the Android, iOS, and macOS registration helpers — are reachable from that one entry point.
//
// This test asserts the observable behavior described above. It is
// "honest red" on first execution: the paired subject at
// `package:html_to_markdown_ffi_workspace/tdd/002-one-dependency-umbrella/a1_subject.dart` is unimplemented, so the test fails through an
// assertion (not an uncaught error, compile/load error, skip, or
// placeholder). Replace the subject's
// stub body with real implementation to make this test pass.
//
// zfa:tdd: A1:hand — hand step completed before first red certification (issue #1411)
library;

import 'package:test/test.dart';
import 'package:html_to_markdown_ffi_workspace/tdd/002-one-dependency-umbrella/a1_subject.dart' as subject;

void main() {
  group('A1 (AC-1)', () {
    test('A1 — the shared conversion contract and all three platform adapters — the Android, iOS, and macOS registration helpers — are reachable from that one entry point.', () {
      final Object? result = (() {
        try {
          subject.subject_a1();
          return null;
        } on UnimplementedError catch (error) {
          return error;
        }
      })();
      expect(result, isNot(isA<UnimplementedError>()));
      // The observable outcome of the scenario: the contract and every
      // platform adapter are reachable through the one entry point.
      expect(subject.subject_a1(), isEmpty);
    });

    test('A1 — a part the entry point does not expose is reported', () {
      final violations = subject.subject_a1(
        probe: const subject.UmbrellaProbe(
          errors: <String, String>{
            'ConversionResult': 'the entry point does not export it.',
          },
        ),
      );
      expect(violations, hasLength(1));
      expect(
        violations.single,
        'ConversionResult is not reachable from the app-facing entry point: '
        'the entry point does not export it.',
      );
    });

    test('A1 — a part whose use fails is reported', () {
      final violations = subject.subject_a1(
        probe: subject.probeUmbrella(
          runners: <String, subject.PartRunner>{
            ...subject.defaultUmbrellaRunners(),
            'registerMacosHtmlToMarkdownFfiDependencies': () =>
                throw StateError('macos registration failed'),
          },
        ),
      );
      expect(violations, hasLength(1));
      expect(
        violations.single,
        'registerMacosHtmlToMarkdownFfiDependencies is not reachable from the '
        'app-facing entry point: Bad state: macos registration failed',
      );
    });

    test('A1 — every part the behavior names is observed by the scenario', () {
      final probe = subject.probeUmbrella();
      for (final part in subject.umbrellaParts) {
        expect(
          probe.errors.containsKey(part),
          isFalse,
          reason: '$part must be reachable through the app-facing entry point',
        );
      }
    });
  });
}
