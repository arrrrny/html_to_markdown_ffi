# TDD Verification — feature `004-pure-dart-umbrella`

Generated fresh by `zfa tdd verify --feature 004-pure-dart-umbrella`.

## Gate

- gate: `pass`

## Mutation buckets (FR-014)

- killed: 64
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

- `A1` — not traced: no scenario-assertions header in test/tdd/004-pure-dart-umbrella/a1_test.dart
- `A2` — not traced: no scenario-assertions header in test/tdd/004-pure-dart-umbrella/a2_test.dart

## Restoration (FR-021)

- restoration_verified: true
- restoration_scope_count: 2
- restoration_scope (subjects only, never tests):
  - `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/004-pure-dart-umbrella/a1_subject.dart`
  - `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/004-pure-dart-umbrella/a2_subject.dart`

## Repro diagnostics (FR-020, non-sensitive)

- runner_command: `dart run mutation_test`
- exit_code: 0
- elapsed_seconds: 1942
- report_path: `/Users/arrrrny/Developer/html_to_markdown_ffi/.dart_tool/zfa/tdd-verify-report/mutation-test-report.md`
- preflight_scope_ran (bug #924, per-behavior):
  - `test/tdd/004-pure-dart-umbrella/a1_test.dart`
  - `test/tdd/004-pure-dart-umbrella/a2_test.dart`

## Mutation run

- mutation_was_run: true
- mutation_score: 1.0000

## Evidence binding (bug #837)

- spec_hash: 9bf947ef68ce01c80463ca277949d1bb5de122fac1e385b8c97269c563d2009a
- subject_hash: `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/004-pure-dart-umbrella/a1_subject.dart` b3af565a50dad9c537143f742f6045dd4c1be8d2d568c783d95977cb0e2b5c80
- subject_hash: `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/004-pure-dart-umbrella/a2_subject.dart` f2cae98942a859c714f91c7f51bd61feb63a877af7dff5025da87c84d662785a
