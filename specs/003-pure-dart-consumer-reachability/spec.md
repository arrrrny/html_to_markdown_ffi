**Template Version**: `zuraffa-1.0`

# Spec: 003-pure-dart-consumer-reachability

## Problem

A package that carries a `flutter: plugin:` manifest requires the Flutter
SDK: pub.dev rejects such a package without an `environment: flutter:`
constraint, and *any* such constraint — whatever version it names — makes the
package unresolvable for a consumer that has a plain Dart SDK. A consumer
that is not a Flutter app is therefore locked out of the family.

The family answers this with two entry points, one dependency each, and no
project-file change on either side:

- the app-facing `html_to_markdown_ffi` for a Flutter app — one dependency,
  the native library linked in by the family itself;
- the shared `html_to_markdown_ffi_platform` for everything else — one
  dependency, no Flutter SDK, the same in-process conversion.

## Acceptance Scenarios

1. **Given** a consumer that is not a Flutter app **When** it declares only the shared `html_to_markdown_ffi_platform` package **Then** the resolution succeeds — that package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change.
   **Type**: acceptance
2. **Given** a consumer app that depends on the app-facing `html_to_markdown_ffi` package **When** the app-facing package's manifest is read **Then** it still names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, and still carries the Flutter SDK constraint that a plugin manifest requires — so the zero-touch distribution of `001-zero-touch-native-distribution` survives.
   **Type**: acceptance
