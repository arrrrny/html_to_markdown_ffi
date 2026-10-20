# TDD Verification — feature `001-zero-touch-native-distribution`

Generated fresh by `zfa tdd verify --feature 001-zero-touch-native-distribution`.

## Gate

- gate: `pass`

## Mutation buckets (FR-014)

- killed: 175
- survived: 0
- timed_out: 0

## Behavior scope (FR-018)

- `A1` — traces: `AC-1`
- `A2` — traces: `AC-2`
- `A3` — traces: `AC-3`
- `A4` — traces: `AC-4`
- `A5` — traces: `AC-5`

## Behavior kinds (issue #1376)

- presence: 0
- absence: 0
- route-outcome: 0
- enabled-state: 0
- sequence: 0

- `A1` — not traced: no scenario-assertions header in test/tdd/001-zero-touch-native-distribution/a1_test.dart
- `A2` — not traced: no scenario-assertions header in test/tdd/001-zero-touch-native-distribution/a2_test.dart
- `A3` — not traced: no scenario-assertions header in test/tdd/001-zero-touch-native-distribution/a3_test.dart
- `A4` — not traced: no scenario-assertions header in test/tdd/001-zero-touch-native-distribution/a4_test.dart
- `A5` — not traced: no scenario-assertions header in test/tdd/001-zero-touch-native-distribution/a5_test.dart

## Restoration (FR-021)

- restoration_verified: true
- restoration_scope_count: 5
- restoration_scope (subjects only, never tests):
  - `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/001-zero-touch-native-distribution/a1_subject.dart`
  - `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/001-zero-touch-native-distribution/a2_subject.dart`
  - `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/001-zero-touch-native-distribution/a3_subject.dart`
  - `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/001-zero-touch-native-distribution/a4_subject.dart`
  - `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/001-zero-touch-native-distribution/a5_subject.dart`

## Repro diagnostics (FR-020, non-sensitive)

- runner_command: `dart run mutation_test`
- exit_code: 0
- elapsed_seconds: 2607
- report_path: `/Users/arrrrny/Developer/html_to_markdown_ffi/.dart_tool/zfa/tdd-verify-report/mutation-test-report.md`
- preflight_scope_ran (bug #924, per-behavior):
  - `test/tdd/001-zero-touch-native-distribution/a1_test.dart`
  - `test/tdd/001-zero-touch-native-distribution/a2_test.dart`
  - `test/tdd/001-zero-touch-native-distribution/a3_test.dart`
  - `test/tdd/001-zero-touch-native-distribution/a4_test.dart`
  - `test/tdd/001-zero-touch-native-distribution/a5_test.dart`

## Mutation run

- mutation_was_run: true
- mutation_score: 1.0000

## Evidence binding (bug #837)

- spec_hash: fb7c7823b763ab9b8cf508ea7e6183d050f41fc210bd06efa083bca001aff3b6
- subject_hash: `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/001-zero-touch-native-distribution/a1_subject.dart` 6e9c701742022edbf71059bf8725b32b803c6888d47c83c98f7d5c449c4313a9
- subject_hash: `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/001-zero-touch-native-distribution/a2_subject.dart` 555fe6a48547f88f17d73116c3c48c8acc41ffd25d913a5124d91d7bb373dc14
- subject_hash: `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/001-zero-touch-native-distribution/a3_subject.dart` 49bd815ad78800177a86926e3b48d0aa07c037c251c850a5890184f7a743a110
- subject_hash: `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/001-zero-touch-native-distribution/a4_subject.dart` 4d16c429532582c90a9f78d87b77c3768775972c5147a0f76e8cd17163e77d98
- subject_hash: `/Users/arrrrny/Developer/html_to_markdown_ffi/lib/tdd/001-zero-touch-native-distribution/a5_subject.dart` 3929c040449e879d4805777a05a43511ab3f759c12b61daee3a3be2beb1f36f4
