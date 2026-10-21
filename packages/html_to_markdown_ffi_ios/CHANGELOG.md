## 1.2.5 - 2026-10-21

- **A pure-Dart consumer is no longer locked out of the family** (spec
  `003-pure-dart-consumer-reachability`).

  1.2.4 made the app-facing package depend on the Flutter SDK. The cost was
  real: pub treats an `environment: flutter:` constraint and a
  `flutter: {sdk: flutter}` dependency as hard requirements, so a consumer
  with a plain Dart SDK could not resolve the family at all:

      Because html_to_markdown_ffi_macos >=1.2.3 which requires the Flutter
      SDK, version solving failed.

  A pure-Dart consumer was therefore pinned to 1.2.3 forever — every later
  release was invisible to it.

  A package cannot be both a Flutter plugin and pure-Dart-resolvable:
  pub.dev refuses to publish a package that carries a `flutter: plugin:`
  manifest without an `environment: flutter:` constraint, and *any* value of
  that constraint — whatever version it names — makes the package
  unresolvable for a standalone Dart SDK. The two requirements are
  incompatible.

  So the family grows a second entry point, and both are one dependency with
  no project-file change:

  - **A Flutter app** depends on `html_to_markdown_ffi`. The native library
    is linked in by the family itself — unchanged, and still one dependency.
  - **Everything else** — a CLI, a server, a background worker — depends on
    `html_to_markdown_ffi_platform`, which asks for no Flutter SDK and
    declares no plugin manifest.

  The shared package was already the family's Flutter-free core; what it
  lacked was a way to *use*. It now offers the conversion directly:

  ```dart
  import 'package:html_to_markdown_ffi_platform/html_to_markdown_ffi_platform.dart';

  final result = convert('<h1>Hello</h1>');
  ```

  The conversion runs over the same in-process `dart:ffi` bridge the
  federated adapters and the app-facing package use, so it is the same
  conversion — not a second implementation. The app-facing package's own
  `convert()` additionally prefers a registered platform adapter over the
  direct bridge, which a pure-Dart consumer has no way to register.

  Verified both ways: a consumer with a standalone Dart SDK resolves
  `html_to_markdown_ffi_platform` alone, analyzes clean, compiles to an
  executable and converts; a Flutter app resolves the three platform
  adapters on its own and links the native library into the macOS app
  bundle, the iOS simulator build and the Android APK.

- **The Flutter SDK floor drops from `>=3.41.0` to `>=3.27.0`** on the four
  packages that carry a plugin manifest. The old floor was the Flutter
  version that happened to be installed when the constraint was written, not
  a requirement the family has. `>=3.27.0` is where Flutter's Swift Package
  Manager support for plugins landed, and it is what `dart_curl_flutter`
  already declares in this ecosystem.

- The app-facing package no longer depends on the Flutter SDK. Nothing in
  the family imports `package:flutter` — the three adapters are pure Dart
  that ship prebuilt artifacts (an xcframework for iOS and macOS, `jniLibs`
  for Android).

- The unused `mocktail` dev-dependency is dropped from the workspace root.

## 1.2.4 - 2026-10-21

- The adapter no longer depends on the app-facing package; the shared FFI
  stack it imports now comes from `html_to_markdown_ffi_platform`. That is
  what lets the app-facing package declare this adapter through
  `default_package`, so a consumer needs only `html_to_markdown_ffi`.
- The native distribution is unchanged: the Swift package still ships the
  `libhtml_to_markdown_ffi.xcframework` as a dynamic product with a link
  anchor, and the consumer's project files still need no change.

## 1.2.3 - 2026-10-20

- **Fixes the zero-touch distribution introduced in 1.2.2.** The 1.2.2
  arrangement did not actually put the native library in the app: the Swift
  package's product was named `html_to_markdown_ffi_ios`, but Flutter's Swift
  Package Manager integration looks a plugin's product up by the plugin name
  with underscores turned into dashes (the product name becomes the
  CFBundleIdentifier, which cannot contain underscores) — and the product was
  `static`, so SwiftPM copied the binary target's archive into the build but
  never linked it. Nothing referenced `htm_convert` by name, the linker
  dead-stripped the archive, and the finished app exported **zero** `htm_*`
  symbols. The adapter now ships:
  - a product named `html-to-markdown-ffi-ios`, the way Flutter looks it up;
  - the product as `type: .dynamic`, so Xcode links the archive and embeds
    `html-to-markdown-ffi-ios.framework` in the app bundle;
  - a C target `html_to_markdown_ffi_ios_anchor` holding the reference
    `void (*const html_to_markdown_ffi_ios_link_anchor)(void) = htm_convert;`,
    which keeps the archive in the link.

  A consumer app still adds the dependency and changes nothing else — no
  Podfile entry, no xcconfig, no `-force_load` flag.
- The family resolves through one pub workspace with one shared lockfile, the
  platform envelope is the shared `zuraffa_ffi_platform` one, and `zuraffa`
  is widened to `^7.2.0`.

## 1.2.2 - 2026-10-20

- Ships the Rust `libhtml_to_markdown_ffi` archive to iOS apps natively: the
  package is now a Flutter `ffiPlugin` with an SPM `Package.swift` whose
  `binaryTarget` carries `libhtml_to_markdown_ffi.xcframework`
  (device arm64 + simulator arm64/x86_64). Xcode force-loads static-archive
  binaryTargets, so the `htm_*` symbols reach Dart's
  `DynamicLibrary.process()` with **zero manual `-force_load` wiring** in the
  host project — retire any `Runner/Frameworks/libhtml_to_markdown_ffi.a`
  xcconfig/pbxproj links when adopting this version.

## 1.2.1 - 2026-09-23

- Widened the `zuraffa` constraint from `^6.2.2` to `^7.0.0` across all five
  packages so the family resolves alongside zuraffa 7.x. No API changes — the
  full suite passes unchanged against 7.0.1.

## 1.2.0 - 2026-09-13

- **Zuraffa migration (spec 064 / issue zuraffa#687)**: rebuilt as a
  zuraffa-native federated plugin monorepo — `html_to_markdown_ffi` (app),
  `html_to_markdown_ffi_platform` (envelope core), and
  `html_to_markdown_ffi_android` / `_ios` / `_macos` adapters.
- Public API preserved: `convert()`, `ConversionOptions`,
  `ConversionResult`, `Visitor`, exceptions, and every pre-existing
  `package:html_to_markdown_ffi/...` import path keep working unchanged.
- Native binaries moved from the app package `native/` into the federated
  adapters (byte-for-byte the same artifacts). The loader chain gains an
  additive adapter-resolver seam; env var, legacy bundle, cache, Cargo
  workspace, and download paths are preserved.
- New zuraffa stack: `HtmlToMarkdownFfiPort` / `HtmlToMarkdownFfiService`
  / `registerHtmlToMarkdownFfiDependencies`, generated domain
  (`HtmConversion` entity, repository, datasource, use case via
  `zfa entity create` + `zfa make`); the datasource wraps the preserved
  dart:ffi bridge.
- Dependency: new hosted `zuraffa` dependency; `ffi` / `http` unchanged.
- Known behavior preserved from 1.1.0: the `Visitor` bridge remains the
  documented stub (visitors are accepted; rendering is default).

# Changelog

## 1.1.0

- Initial release of the `html_to_markdown_ffi` federated family (spec 064
  / epic #214 zuraffa migration): shared iOS adapter with statically linked slices for the family.

## 1.0.0

- Initial zuraffa-native scaffold (`zfa package create-plugin`).
