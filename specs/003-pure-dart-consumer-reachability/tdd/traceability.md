# Traceability: 003-pure-dart-consumer-reachability

Coverage proof for `zfa tdd plan` (bug #846): every FR/AC requirement statement maps to a behavior row or an explicit manual declaration. Verify re-checks the hash — a spec edited after plan is drift (exit 3, re-plan required).

<!-- tdd:traceability
spec-hash: sha256:aded8b00c01ba77612a85b1f1bb4306758c8802d5852ead59cf89dfad1912652
statements: 2
automated: 2
manual: 0
fr-manual: 0
open-gaps: 0
-->

| requirement | line | statement | behavior | status |
| --- | --- | --- | --- | --- |
| AC-1 | 23 | 1. **Given** a consumer that is not a Flutter app **When** it declares only the shared `html_to_markdown_ffi_platform` package **Then** the resolution succeeds — that package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change. | A1 | automated |
| AC-2 | 25 | 2. **Given** a consumer app that depends on the app-facing `html_to_markdown_ffi` package **When** the app-facing package's manifest is read **Then** it still names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, and still carries the Flutter SDK constraint that a plugin manifest requires — so the zero-touch distribution of `001-zero-touch-native-distribution` survives. | A2 | automated |

