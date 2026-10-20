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
  });
}
