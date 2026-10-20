## 1.2.4 - 2026-10-21

- The adapter no longer depends on the app-facing package; the shared FFI
  stack it imports now comes from `html_to_markdown_ffi_platform`. That is
  what lets the app-facing package declare this adapter through
  `default_package`, so a consumer needs only `html_to_markdown_ffi`.
- The native distribution is unchanged: the Swift package still ships the
  `libhtml_to_markdown_ffi.xcframework` as a dynamic product with a link
  anchor, and the consumer's project files still need no change.

## 1.2.3 - 2026-10-20

- Zero-touch distribution: the adapter ships the Rust static archive as a
  universal (`arm64` + `x86_64`) `libhtml_to_markdown_ffi.xcframework` and
  links it through its own Swift package (`Package.swift` with a
  `binaryTarget`). The plugin is an `ffiPlugin`, so a consumer app adds the
  dependency and changes no project file of its own.
- The Swift package uses the shape that actually reaches the app, matching
  the fixed iOS adapter: the product is named `html-to-markdown-ffi-macos`
  (Flutter looks a plugin's product up by the plugin name with underscores
  turned into dashes), the product is `type: .dynamic` (a static product
  contributes only its own object files, so the binary target's archive would
  be dropped from the link), and a C target `html_to_markdown_ffi_macos_anchor`
  holds the reference `void (*const html_to_markdown_ffi_macos_link_anchor)(void)
  = htm_convert;` so the linker keeps the archive.
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
  / epic #214 zuraffa migration): shared macOS adapter with bundled arm64 / x64 dylibs for the family.

## 1.0.0

- Initial zuraffa-native scaffold (`zfa package create-plugin`).
