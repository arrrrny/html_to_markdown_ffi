# TDD Verification — feature `002-one-dependency-umbrella`

Generated fresh by `zfa tdd verify --feature 002-one-dependency-umbrella`.

## Gate

- gate: `pass`

## Mutation buckets (FR-014)

- killed: 26
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

- `A1` — not traced: no scenario-assertions header in test/tdd/002-one-dependency-umbrella/a1_test.dart
- `A2` — not traced: no scenario-assertions header in test/tdd/002-one-dependency-umbrella/a2_test.dart

## Restoration (FR-021)

- restoration_verified: true
- restoration_scope_count: 2
- restoration_scope (subjects only, never tests):
  - `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/002-one-dependency-umbrella/a1_subject.dart`
  - `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/002-one-dependency-umbrella/a2_subject.dart`

## Repro diagnostics (FR-020, non-sensitive)

- runner_command: `dart run mutation_test`
- exit_code: 0
- elapsed_seconds: 92
- report_path: `/Users/arrrrny/Developer/html_to_markdown_ffi/.dart_tool/zfa/tdd-verify-report/mutation-test-report.md`
- preflight_scope_ran (bug #924, per-behavior):
  - `test/tdd/002-one-dependency-umbrella/a1_test.dart`
  - `test/tdd/002-one-dependency-umbrella/a2_test.dart`

## Mutation run

- mutation_was_run: true
- mutation_score: 1.0000

## Evidence binding (bug #837)

- spec_hash: 2c25e250313dfdd34cf746a639023083be23838f59422cec65026b7ccb6f8bba
- subject_hash: `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/002-one-dependency-umbrella/a1_subject.dart` 4125eda6a671f7fdff01ac55431c9d9d7d0660f079d88789797e6d25ff93b43e
- subject_hash: `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/002-one-dependency-umbrella/a2_subject.dart` 46ea95fae5979b9703aa57a6bb9f845aed374eda214e2e0e41d9458277c42901
