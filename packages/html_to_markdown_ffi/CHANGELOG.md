## 1.2.4 - 2026-10-21

- The app-facing package is now a real federated plugin: it declares
  `default_package` for android, ios and macos and depends on the three
  adapters, so a consumer needs only `html_to_markdown_ffi: ^1.2.4` and
  Flutter resolves the implementations itself. Before this release the
  consumer had to declare the adapters too.
- The shared FFI stack (native loader, bindings, port contract, models,
  visitor, typed exceptions) moved to `html_to_markdown_ffi_platform`, which
  every adapter already depended on — that is what made the one-dependency
  wiring possible without a pub dependency cycle.
- `package:html_to_markdown_ffi/html_to_markdown.dart` still exports the same
  names.

## 1.2.3 - 2026-10-20

- The platform envelope is now the shared `zuraffa_ffi_platform` envelope:
  `PlatformHtmlToMarkdownFfiEnvelope` is an alias of `PlatformFfiEnvelope`
  instead of a byte-identical copy of it. The public name is unchanged, so
  every existing import and call site keeps working.
- `zuraffa` widened to `^7.2.0`, `zorphy_annotation` to `^2.4.3`.
- The family resolves through one pub workspace with one shared lockfile.

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

- Zuraffa-native rebuild (spec 064 / epic #214): the preserved public API
  (`convert`, options, results, visitor, exceptions) now backed by the
  zuraffa stack — port, service, generated domain, and a native datasource
  wrapping the existing dart:ffi bridge.
- Native binaries moved to the federated adapters (byte-identical
  artifacts); the loader chain is preserved with an additive resolver seam.

## 1.0.0

- Initial zuraffa-native scaffold (`zfa package create-plugin`).
