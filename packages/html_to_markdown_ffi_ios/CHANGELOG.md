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
