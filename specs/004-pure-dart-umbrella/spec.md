**Template Version**: `zuraffa-1.0`

# Spec: 004-pure-dart-umbrella

## Problem

The app-facing package `html_to_markdown_ffi` carries the `flutter: plugin:`
manifest, so it carries the Flutter SDK constraint that pub.dev requires
beside such a manifest. Any consumer that is not a Flutter app — a CLI, a
server, a background worker — cannot resolve it: pub reports *"requires the
Flutter SDK, version solving failed"*.

The family already ships a Flutter-free package,
`html_to_markdown_ffi_platform`, but it is the *lower* layer. It offers the
conversion, not the app-facing zuraffa stack: the service facade, the DI
registration, the use case. A pure-Dart consumer that wants the app-facing
API today has to choose between the API and the Flutter SDK.

The family answers this the way `dart_curl` and `dart_curl_flutter` do: the
*engine* is pure Dart, and the *plugin* is the Flutter-specific wrapper.

- `html_to_markdown_ffi` — pure Dart. No Flutter SDK, no plugin manifest.
  The app-facing API. One dependency for a CLI, a server, a worker.
- `html_to_markdown_ffi_flutter` — the Flutter plugin. It carries the plugin
  manifest, names the three adapters as their platform's `default_package`,
  and re-exports the app-facing API under one name. One dependency for a
  Flutter app, and the native library is linked in by the family itself.

Neither side asks the consumer to change a project file.

## Acceptance Scenarios

1. **Given** a consumer that is not a Flutter app **When** it declares only the app-facing `html_to_markdown_ffi` package **Then** the resolution succeeds — the package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency, and it depends on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.
   **Type**: acceptance
2. **Given** a consumer app that is a Flutter app **When** it declares only the `html_to_markdown_ffi_flutter` package **Then** that package names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, carries the Flutter SDK constraint that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library.
   **Type**: acceptance

## Non-Goals

- The app-facing package keeps its public API unchanged: `convert()`,
  `ConversionOptions`, `HeadingStyle`, `LinkStyle`, `CodeBlockStyle` and the
  rest keep their names and their import path
  `package:html_to_markdown_ffi/html_to_markdown.dart`.
- The three platform adapters are unchanged: they keep their plugin
  manifests, their `ffiPlugin: true` declarations, and their bundled native
  libraries.
- `html_to_markdown_ffi_platform` is unchanged: it stays the shared,
  Flutter-free core both entry points build on.
