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
  });
}
