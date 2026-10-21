# Engine Plan: 003-pure-dart-consumer-reachability (CORE + BOTH)

The engine lane (issue #1000): pure Dart — behaviors whose lane is CORE or BOTH. The noFlutter guard rejects any behavior that references Flutter at plan time, so this file stays engine-only.

## Outer loop: acceptance behaviors

One per acceptance criterion in `spec.md`.

| id | behavior | traces | state |
| -- | -------- | ------ | ----- |
| A1 | the resolution succeeds — that package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change. | AC-1 | PENDING |
| A2 | it still names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, and still carries the Flutter SDK constraint that a plugin manifest requires — so the zero-touch distribution of `001-zero-touch-native-distribution` survives. | AC-2 | PENDING |

## Routing provenance

Per-behavior routing decisions (issue #951): what each decision consulted — a declared marker/contract row, or the labeled legacy fallback to migrate.

route: A1 -> acceptance lane [declared: type marker, spec line 24]
route: A2 -> acceptance lane [declared: type marker, spec line 26]


