# Engine Plan: 001-zero-touch-native-distribution (CORE + BOTH)

The engine lane (issue #1000): pure Dart — behaviors whose lane is CORE or BOTH. The noFlutter guard rejects any behavior that references Flutter at plan time, so this file stays engine-only.

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md`.

| id | behavior | traces | state |
| -- | -------- | ------ | ----- |
| A1 | the Rust native library is linked into the app by the macOS adapter package's own Swift package (a `binaryTarget` over the shipped xcframework), and the consumer's project files contain no reference to the native library. | AC-1 | PENDING |
| A2 | the Rust native library is packaged into the app from the Android adapter package's own `jniLibs`, and the consumer's project files contain no reference to the native library. | AC-2 | PENDING |
| A3 | the Rust native library is linked into the app by the iOS adapter package's own Swift package, exactly as the macOS adapter does. | AC-3 | PENDING |
| A4 | the conversion goes through the shared `zuraffa_ffi_platform` envelope, and the adapter declares no envelope of its own. | AC-4 | PENDING |
| A5 | all five family packages resolve through one pub workspace on the latest zuraffa release, and every member carries the same release version. | AC-5 | PENDING |

## Routing provenance

Per-behavior routing decisions (issue #951): what each decision consulted — a declared marker/contract row, or the labeled legacy fallback to migrate.

route: A1 -> acceptance lane [declared: type marker, spec line 8]
route: A2 -> acceptance lane [declared: type marker, spec line 10]
route: A3 -> acceptance lane [declared: type marker, spec line 12]
route: A4 -> acceptance lane [declared: type marker, spec line 14]
route: A5 -> acceptance lane [declared: type marker, spec line 16]


