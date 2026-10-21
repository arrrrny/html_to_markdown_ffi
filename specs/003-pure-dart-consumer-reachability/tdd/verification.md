# TDD Verification — feature `003-pure-dart-consumer-reachability`

Generated fresh by `zfa tdd verify --feature 003-pure-dart-consumer-reachability`.

## Gate

- gate: `pass`

## Mutation buckets (FR-014)

- killed: 47
- survived: 0
- timed_out: 0

## Behavior scope (FR-018)

- `A1` — traces: `AC-1`
- `A2` — traces: `AC-2`

## Behavior kinds (issue #1376)

- presence: 0
- absence: 0
- route-outcome: 0
- enabled-state: 0
- sequence: 0

- `A1` — not traced: no scenario-assertions header in test/tdd/003-pure-dart-consumer-reachability/a1_test.dart
- `A2` — not traced: no scenario-assertions header in test/tdd/003-pure-dart-consumer-reachability/a2_test.dart

## Restoration (FR-021)

- restoration_verified: true
- restoration_scope_count: 2
- restoration_scope (subjects only, never tests):
  - `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/003-pure-dart-consumer-reachability/a1_subject.dart`
  - `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/003-pure-dart-consumer-reachability/a2_subject.dart`

## Repro diagnostics (FR-020, non-sensitive)

- runner_command: `dart run mutation_test`
- exit_code: 0
- elapsed_seconds: 1215
- report_path: `/Users/arrrrny/Developer/html_to_markdown_ffi/.dart_tool/zfa/tdd-verify-report/mutation-test-report.md`
- preflight_scope_ran (bug #924, per-behavior):
  - `test/tdd/003-pure-dart-consumer-reachability/a1_test.dart`
  - `test/tdd/003-pure-dart-consumer-reachability/a2_test.dart`

## Mutation run

- mutation_was_run: true
- mutation_score: 1.0000

## Evidence binding (bug #837)

- spec_hash: 9550c843a99cc861c2881bec9e58cf3c887cd3c4169df63b99f45320defb99a7
- subject_hash: `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/003-pure-dart-consumer-reachability/a1_subject.dart` 9687fc8928823ac6180546c0c49b1c80d9c6006a1129924db8c4be2975dbf03f
- subject_hash: `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/003-pure-dart-consumer-reachability/a2_subject.dart` 74b912f676d0fc0b3defbae2f03fed2734bfadd06a6065dc66ba132fa6a0ee9b
