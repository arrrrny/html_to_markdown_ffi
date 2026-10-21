# Engine Plan: 004-pure-dart-umbrella (CORE + BOTH)

The engine lane (issue #1000): pure Dart — behaviors whose lane is CORE or BOTH. The noFlutter guard rejects any behavior that references Flutter at plan time, so this file stays engine-only.

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md`.

| id | behavior | traces | state |
| -- | -------- | ------ | ----- |
| A1 | the resolution succeeds — the package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency, and it depends on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change. | AC-1 | PENDING |
| A2 | that package names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, carries the Flutter SDK constraint that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library. | AC-2 | PENDING |

## Routing provenance

Per-behavior routing decisions (issue #951): what each decision consulted — a declared marker/contract row, or the labeled legacy fallback to migrate.

route: A1 -> acceptance lane [declared: type marker, spec line 34]
route: A2 -> acceptance lane [declared: type marker, spec line 36]


