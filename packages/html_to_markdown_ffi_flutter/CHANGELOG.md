## 1.2.8 - 2026-10-29

### Dependencies

- The whole fleet rides the unified zuraffa family line: `zuraffa` moves from `^7.2.0` to `^7.3.0` in every package, and `html_to_markdown_ffi_platform` takes `zuraffa_ffi_platform: ^7.3.0` (previously `^0.2.1` — the platform-interface package joined the family's unified version line). No code changes.

# Changelog

## 1.2.7 - 2026-10-21

- **The app-facing package is pure Dart again** (spec
  `004-pure-dart-umbrella`).

  1.2.4 turned `html_to_markdown_ffi` into a Flutter plugin, and a package
  that carries a `flutter: plugin:` manifest asks for the Flutter SDK:
  pub.dev refuses to publish it without an `environment: flutter:`
  constraint, and *any* value of that constraint makes it unresolvable for
  a consumer that has a plain Dart SDK.

      Because resolve_test_umbrella depends on html_to_markdown_ffi >=1.2.4
      which requires the Flutter SDK, version solving failed.

  The family now splits the way `dart_curl` and `dart_curl_flutter` do — the
  engine is pure Dart, the plugin is the Flutter-specific wrapper:

  | Consumer | Declare | Flutter SDK |
  | -------- | ------- | ----------- |
  | A Flutter app | `html_to_markdown_ffi_flutter: ^1.2.7` | required |
  | A CLI, server or worker | `html_to_markdown_ffi: ^1.2.7` | **not** required |

  - `html_to_markdown_ffi` is the engine. Pure Dart, no plugin manifest, and
    the app-facing API is unchanged: `convert()`, `ConversionOptions`,
    `HeadingStyle`, `LinkStyle`, `CodeBlockStyle`, the service facade and
    the DI registration all keep their names and their import path
    `package:html_to_markdown_ffi/html_to_markdown.dart`.
  - `html_to_markdown_ffi_flutter` is the new Flutter plugin. It carries the
    plugin manifest, names the Android, iOS, and macOS adapters as their
    platform's `default_package`, and re-exports the engine's API — and the
    three adapters' registration helpers — under one name.

  One dependency either way, and no project-file change on either side.

  A pure-Dart consumer that already declares `html_to_markdown_ffi: ^1.2.1`
  resolves 1.2.7 and is unblocked: the constraint admits it.

  **Breaking for a Flutter app.** A Flutter app that declared
  `html_to_markdown_ffi` to get the native library linked in now declares
  `html_to_markdown_ffi_flutter` instead. It is still one dependency, still
  no project-file change, and the adapter resolution is unchanged.
