## 1.2.4 - 2026-10-21

- The package now owns the shared FFI stack the adapters need: the native
  library loader, the `htm_convert` bindings, the `HtmlToMarkdownFfiPort`
  contract, the conversion models, the visitor and the typed exceptions.
  They used to live in the app-facing package, which is what forced a
  consumer to declare the adapters by hand.
- It no longer depends on the app-facing package, so the family's dependency
  graph is acyclic: app -> {platform, android, ios, macos}, adapters ->
  platform.

## 1.2.3 - 2026-10-20

- The envelope core is now the shared `zuraffa_ffi_platform` package:
  `PlatformHtmlToMarkdownFfiEnvelope` is an alias of `PlatformFfiEnvelope`
  and the duplicated implementation is gone. The public name is unchanged.
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
  / epic #214 zuraffa migration): shared envelope core (transport seam, typed error mapping, resolver seam) for the family.

## 1.0.0

- Initial zuraffa-native scaffold (`zfa package create-plugin`).
