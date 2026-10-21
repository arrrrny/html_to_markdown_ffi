# Changelog

## 1.2.6 - 2026-10-21

- **The pure-Dart entry point carries the conversion.** The
  `html_to_markdown_ffi_platform` 1.2.5 that reached pub.dev was published
  from an earlier state of the family and shipped without
  `lib/convert.dart`, so the entry point it offered had no conversion to
  call. 1.2.6 carries the intended content: `convert()`,
  `convertAsync()` and `nativeConverterAvailable`, over the same
  in-process `dart:ffi` bridge the rest of the family uses.

  A consumer that declares `html_to_markdown_ffi_platform: ^1.2.5` resolves
  1.2.6 — the constraint admits it — and gets the conversion. The other four
  members were published correctly at 1.2.5 and are unchanged here.

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

- **One dependency is now enough** (spec `001-zero-touch-native-distribution`).
  The app-facing package is a real federated plugin: it declares
  `default_package` for android, ios and macos, and depends on the three
  adapters. Flutter resolves the implementations on the consumer's behalf.

  Before this release the app-facing package was a plain Dart package with no
  `flutter: plugin:` block, so a consumer who added only
  `html_to_markdown_ffi` resolved **zero** Flutter plugins and got no native
  library at all — they had to declare the adapters themselves, which is
  itself a project-file change.

  ```yaml
  dependencies:
    html_to_markdown_ffi: ^1.2.4
  ```

  The adapters could not simply be depended on from the app-facing package,
  because they import the shared FFI stack (the native loader, the bindings,
  the port contract, the models, the visitor and the typed exceptions) *from*
  the app-facing package. Wiring `default_package` while that dependency
  pointed the other way would have made pub see a cycle. So the shared stack
  moves down into `html_to_markdown_ffi_platform`, which every adapter
  already depends on:

      html_to_markdown_ffi                    -> platform, android, ios, macos
      html_to_markdown_ffi_{android,ios,macos} -> platform
      html_to_markdown_ffi_platform           -> zuraffa_ffi_platform

  The supported consumer import path
  `package:html_to_markdown_ffi/html_to_markdown.dart` still exports the same
  names.

- The workspace now resolves `zuraffa_ffi` and `zuraffa_ffi_platform` from
  pub.dev (`^0.2.1`) instead of a local path override, so the scenarios
  assert against the published package — the same artifact a consumer
  resolves. `zuraffa_ffi` 0.2.1 is itself the one-dependency release: the
  app-facing package pulls the platform core and the three platform
  adapters in, so nothing in this family pulls a second copy of the shared
  FFI stack.

- **Dependencies moved to their latest releases**: `zuraffa` is at `^7.2.0`
  (the current latest), `zorphy_annotation` and `zorphy` are at `^2.4.4`
  (was `^2.4.3`), and the shared FFI core is at `zuraffa_ffi_platform
  ^0.2.1` — the release that carries the port contract, and therefore the
  one the family's envelope alias resolves against.

- **One dependency really is one dependency** (spec
  `002-one-dependency-umbrella`). The app-facing package now re-exports the
  three adapters, so the whole family's public API — the conversion
  contract, the facade, and the Android, iOS and macOS registration
  helpers — is reachable from `package:html_to_markdown_ffi/
  html_to_markdown_ffi.dart` alone:

  ```dart
  import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';

  registerMacosHtmlToMarkdownFfiDependencies(
    getIt,
    channel: MacosHtmlToMarkdownFfiChannel.native(),
  );
  ```

  Before this release that call needed a second dependency on
  `html_to_markdown_ffi_macos` (and a different one per platform). The
  adapters were already in the dependency graph, so this only surfaces
  what the consumer already had; it adds no new edge and keeps the graph
  acyclic.

## 1.2.3 - 2026-10-20

- **Zero-touch native distribution** (spec `001-zero-touch-native-distribution`):
  the macOS, iOS and Android adapters now ship the Rust native library inside
  the plugin package, so a consumer app adds the dependency and nothing else —
  no Podfile entry, no xcconfig, no `-force_load` flag, no `jniLibs` copy in
  the app project, no Gradle edit.
  - **iOS 1.2.2's zero-touch claim was broken twice over, and is fixed here.**
    The product was named `html_to_markdown_ffi_ios` with underscores, but
    Flutter's Swift Package Manager integration looks a plugin's product up by
    the plugin name with underscores turned into dashes — the product name
    becomes the CFBundleIdentifier, which cannot contain underscores. And the
    product was `static`, so SwiftPM copied the binary target's archive into
    the build but never linked it: nothing referenced `htm_convert` by name,
    the linker dead-stripped it, and the finished app exported **zero**
    `htm_*` symbols. The product is now `html-to-markdown-ffi-ios` and
    `type: .dynamic`, and a small C target (`html_to_markdown_ffi_ios_anchor`)
    holds the reference `void (*const html_to_markdown_ffi_ios_link_anchor)(void)
    = htm_convert;` that keeps the archive in the link.
  - **macOS** now uses the same shape as the fixed iOS adapter: a Swift package
    (`macos/html_to_markdown_ffi_macos/Package.swift`) with a `binaryTarget`
    over `Frameworks/libhtml_to_markdown_ffi.xcframework` (universal
    `arm64` + `x86_64` static archive exporting the `htm_*` C API), a
    `html-to-markdown-ffi-macos` dynamic product, a
    `html_to_markdown_ffi_macos_anchor` C target, plus `ffiPlugin: true`. The
    symbols reach Dart through `DynamicLibrary.process()`.
  - **Android** ships `libhtml_to_markdown_ffi.so` for `armeabi-v7a`,
    `arm64-v8a` and `x86_64` under `android/src/main/jniLibs/<abi>/`, with a
    Gradle module that packages those `jniLibs`, plus `ffiPlugin: true`.
- **Shared envelope**: `html_to_markdown_ffi_platform` now depends on
  `zuraffa_ffi_platform` and its envelope is an alias of the shared
  `PlatformFfiEnvelope` instead of a byte-identical copy of it. The public
  name `PlatformHtmlToMarkdownFfiEnvelope` is preserved.
- **Dependencies**: `zuraffa` widened to `^7.2.0`, `zorphy_annotation` to
  `^2.4.3`.
- **Workspace**: the five packages resolve through one pub workspace with
  one shared lockfile.

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

## 1.1.0 - 2026-08-05

- Bake prebuilt native binaries into the package (`native/`): macOS arm64 + x64
  dylibs, iOS static libs (device arm64, simulator arm64 + x64), and Android
  `.so` files (arm64-v8a, armeabi-v7a, x86_64).
- `NativeLibrary` now loads the bundled binary automatically; the GitHub
  release download remains as a fallback for platforms without bundled
  artifacts.

## 1.0.1

- Add `~/.html_to_markdown_ffi/` to native library search paths
- Add auto-download from GitHub release when library not found
- Support `HTML_TO_MARKDOWN_FFI_LIB_PATH` and `HTML_TO_MARKDOWN_FFI_VERSION` env vars

## 1.0.0 (2026-05-10)

- Initial release of the Dart/Flutter bindings for html-to-markdown.
- Core `convert()` function with `dart:ffi` bindings to the Rust engine.
- Full `ConversionOptions` support (43 fields, matching Rust core).
- `ConversionResult` with metadata, tables, images, warnings, and document structure.
- `Visitor` abstract class with 38 element-level callbacks.
- Comprehensive test suite: 76 tests across 9 files (smoke, conversion, options, metadata, result, visitor, edge cases, real-world, structure).
- Platform support: macOS, Linux, Windows, Android, iOS.
- 150-280 MB/s throughput via Rust FFI.
