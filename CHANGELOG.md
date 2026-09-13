# Changelog

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
