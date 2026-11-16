## 1.3.2 - 2026-11-16

### macOS: the per-slice dylibs are back

- `html_to_markdown_ffi_macos` ships
  `native/macos-arm64/libhtml_to_markdown_ffi.dylib` and
  `native/macos-x64/libhtml_to_markdown_ffi.dylib` again. 1.3.0 retired them
  (issue [#6](https://github.com/arrrrny/html_to_markdown_ffi/issues/6)) on
  the grounds that the xcframework is the only macOS delivery surface —
  true for an app, false for everything else. An xcframework is an Xcode
  input: a plain Dart process cannot dlopen one, so a host that resolves the
  library by path (a widget test, a CLI, a locator chain) had no artifact
  left to find. Consumers probe these exact paths by name — zuraffa_browser's
  `NativeLibraryLocator` puts
  `html_to_markdown_ffi_macos/native/macos-<arch>/libhtml_to_markdown_ffi.dylib`
  third in its chain — so on a fresh machine every probe missed and the
  engine threw `MarkdownEngineUnavailableException` instead of ever reaching
  the download fallback.
- This is **not** the duplicate-engine problem #6 warned about. That was a
  *manual* embed + codesign build phase copying a dylib into
  `Contents/Frameworks` beside the SPM-embedded framework. Nothing here
  embeds anything: the dylib is only ever opened by path, and the platform
  loader's chain is unchanged, so an app that links the xcframework keeps
  reaching the symbols through `DynamicLibrary.process()`.
- `scripts/build_native.sh` emits both slices and normalises each one —
  `install_name_tool -id @rpath/…` to replace the build-tree install id
  cargo bakes in, then an ad-hoc signature, without which arm64 will not
  dlopen. Rebuild with `./scripts/build_native.sh macos`.
- The macOS adapter's delivery test now locks the dylibs in rather than
  asserting their absence.
- **The same binaries ship in `html_to_markdown_ffi_platform/native/macos-<rid>/`**,
  which is what a consumer with only `html_to_markdown_ffi` resolves through.
  The loader probes that copy as step 8 of its chain and
  `downloadIfNeeded()` short-circuits on it, so a plain-Dart macOS host needs
  no environment variable, no `~/.html_to_markdown_ffi/` cache and no GitHub
  download. The probe is correct only because it checks for a real symbol:
  `DynamicLibrary.process()` and `executable()` open on any process whether
  or not the symbols exist, so the bundled copy would otherwise be
  unreachable — and an app that embeds the macOS xcframework keeps using the
  linked copy instead of loading a second one.
- `resolution: workspace` is now declared by all six member packages. Without
  it pub refuses to resolve the workspace, so `dart test` at the repository
  root aborted before running a single test — and with it, `scripts/
  test_all.sh` runs its first stage again.

## 1.3.1 - 2026-11-16

### Dependencies

- The family rides the unified zuraffa line at `^7.5.0` — `zuraffa`, `zuraffa_ffi`
  and `zuraffa_ffi_platform` move to `^7.5.0` across every package, aligning the
  declared constraints to the versions already resolved by the 1.3.0 lockfile.
  No code changes; the full suite passes unchanged against 7.5.0.

## 1.2.9

- Merge publish-1.2.8 into master (changelog: fold native_library restore + family line into the 1.2.9 recovery note)

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

- The adapter no longer depends on the app-facing package; the shared FFI
  stack it imports now comes from `html_to_markdown_ffi_platform`. That is
  what lets the app-facing package declare this adapter through
  `default_package`, so a consumer needs only `html_to_markdown_ffi`.
- The native distribution is unchanged: the adapter still ships
  `libhtml_to_markdown_ffi.so` for `armeabi-v7a`, `arm64-v8a` and `x86_64`
  in its own `jniLibs`, and the consumer's project files still need no
  change.

## 1.2.3 - 2026-10-20

- Zero-touch distribution: the adapter ships `libhtml_to_markdown_ffi.so` for
  `armeabi-v7a`, `arm64-v8a` and `x86_64` in its own
  `android/src/main/jniLibs/<abi>/`, and its Gradle module packages those
  `jniLibs`. The plugin is an `ffiPlugin`, so a consumer app adds the
  dependency and changes no project file of its own — no `jniLibs` copy, no
  Gradle edit.
- `zuraffa` widened to `^7.2.0`.

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
  / epic #214 zuraffa migration): shared Android adapter with bundled armeabi-v7a / arm64-v8a / x86_64 binaries for the family.

## 1.0.0

- Initial zuraffa-native scaffold (`zfa package create-plugin`).
