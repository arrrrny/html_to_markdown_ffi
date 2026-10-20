# Test List: 001-zero-touch-native-distribution

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md`.

| id | behavior | traces | state |
| -- | -------- | ------ | ----- |
| A1 | the Rust native library is linked into the app by the macOS adapter package's own Swift package (a `binaryTarget` over the shipped xcframework), and the consumer's project files contain no reference to the native library. | AC-1 | PENDING |
| A2 | the Rust native library is packaged into the app from the Android adapter package's own `jniLibs`, and the consumer's project files contain no reference to the native library. | AC-2 | PENDING |
| A3 | the Rust native library is linked into the app by the iOS adapter package's own Swift package, exactly as the macOS adapter does. | AC-3 | PENDING |
| A4 | the conversion goes through the shared `zuraffa_ffi_platform` envelope, and the adapter declares no envelope of its own. | AC-4 | PENDING |
| A5 | all five family packages resolve through one pub workspace on the latest zuraffa release, and every member carries the same release version. | AC-5 | PENDING |

## Outer loop: widget behaviors

UI acceptance scenarios (bug #830): asserted through a testWidgets pair — a view-builder subject stub plus a widget test that pumps the view and asserts the scenario.

The `kind` cell is the finder-kind taxonomy (issue #1140): the scenario verbs' predicted assertion classes — presence, absence, route-outcome, enabled-state, sequence — or `none` when no finder is derivable. `zfa tdd gen` selects the assertion template by it and refuses a row whose kind column drifted from the scenario prose; verify-red's kind gate (issue #959/#964) certifies on the same vocabulary.

| id | behavior | kind | traces | state |
| -- | -------- | ---- | ------ | ----- |

## Inner loop: unit behaviors

One per functional requirement in `spec.md`.

| id | behavior | traces | state |
| -- | -------- | ------ | ----- |

## Routing provenance

Per-behavior routing decisions (issue #951): what each decision consulted — a declared marker/contract row, or the labeled legacy fallback to migrate.

route: A1 -> acceptance lane [declared: type marker, spec line 8]
route: A2 -> acceptance lane [declared: type marker, spec line 10]
route: A3 -> acceptance lane [declared: type marker, spec line 12]
route: A4 -> acceptance lane [declared: type marker, spec line 14]
route: A5 -> acceptance lane [declared: type marker, spec line 16]

