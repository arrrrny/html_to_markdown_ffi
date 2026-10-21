# Traceability: 004-pure-dart-umbrella

Coverage proof for `zfa tdd plan` (bug #846): every FR/AC requirement statement maps to a behavior row or an explicit manual declaration. Verify re-checks the hash — a spec edited after plan is drift (exit 3, re-plan required).

<!-- tdd:traceability
spec-hash: sha256:127949b48d77340ede48ce1b2edb7af1bdd61531c40d0350638f37433775a74b
statements: 2
automated: 2
manual: 0
fr-manual: 0
open-gaps: 0
-->

| requirement | line | statement | behavior | status |
| --- | --- | --- | --- | --- |
| AC-1 | 33 | 1. **Given** a consumer that is not a Flutter app **When** it declares only the app-facing `html_to_markdown_ffi` package **Then** the resolution succeeds — the package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency, and it depends on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change. | A1 | automated |
| AC-2 | 35 | 2. **Given** a consumer app that is a Flutter app **When** it declares only the `html_to_markdown_ffi_flutter` package **Then** that package names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, carries the Flutter SDK constraint that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library. | A2 | automated |

