# html_to_markdown_ffi_macos

macOS adapter for `html_to_markdown_ffi`: registers the port over an
injected channel and ships the Rust native library inside the package.

## Zero-touch distribution

The adapter ships the Rust static archive as
`macos/html_to_markdown_ffi_macos/Frameworks/libhtml_to_markdown_ffi.xcframework`
(a universal `arm64` + `x86_64` archive exporting the `htm_*` C API) and
links it through the plugin's own Swift package
(`macos/html_to_markdown_ffi_macos/Package.swift`, a `binaryTarget` over that
xcframework). The plugin declares `ffiPlugin: true` for macOS, so Flutter
builds and links it for you.

**A consumer adds the dependency and nothing else** — no Podfile entry, no
xcconfig, no `-force_load` flag, no project-file change of any kind:

```yaml
dependencies:
  html_to_markdown_ffi_macos: ^1.2.3
```

The symbols reach Dart through `DynamicLibrary.process()`.

### How the archive survives the link

Two details of the Swift package are load-bearing, and both were found by
building a real consumer app rather than by reading the manifest:

- **The product is dynamic.** `.library(name: "html-to-markdown-ffi-macos",
  type: .dynamic, ...)`. A static product contributes only the object files
  it compiles itself; the `binaryTarget`'s archive is not merged into it.
  A dynamic product is linked against the archive and embedded in the app
  bundle (`Contents/Frameworks/html-to-markdown-ffi-macos.framework`), so
  the library is loaded at launch and its symbols are in the global
  namespace that `DynamicLibrary.process()` searches.
- **The product name uses dashes.** Flutter's Swift Package Manager
  integration looks a plugin's product up by the plugin name with
  underscores turned into dashes
  (`flutter_tools/lib/src/macos/swift_package_manager.dart` — the product
  name becomes the `CFBundleIdentifier`, which cannot contain
  underscores). The product must therefore be `html-to-markdown-ffi-macos`,
  not `html_to_markdown_ffi_macos`.
- **A C anchor keeps the archive in the link.** A static archive contributes
  only the object members the linker needs, and nothing in the app
  references `htm_convert` by name, so the archive would be dropped
  silently. The `html_to_markdown_ffi_macos_anchor` target takes the address
  of `htm_convert`, which creates the undefined reference that keeps it.

## Migrating to SPM embedding

Since 1.2.9 the xcframework behind the Swift package's `binaryTarget` is the
**only** macOS delivery surface: the raw `native/macos-arm64` /
`native/macos-x64` `libhtml_to_markdown_ffi.dylib` copies are retired. If you
are upgrading from a pre-SPM integration:

- **Delete any manual embed/codesign build phase** from your Xcode project
  (a phase that copies a `libhtml_to_markdown_ffi.dylib` into
  `Contents/Frameworks` and re-signs it). Keeping it alongside the SPM
  integration ships **two copies of the same engine** in the app bundle —
  the SPM-embedded `html-to-markdown-ffi-macos.framework` and the
  hand-embedded dylib — and the extra CodeSign step is a common source of
  build failures (e.g. `errSecInternalComponent` when the login keychain
  disallows interaction).
- **Remove the dependency on the raw dylib path** from any script that
  resolves the library by `native/<rid>/` — set
  `HTML_TO_MARKDOWN_FFI_LIB_PATH` or register an `HtmNativeLibraries`
  resolver instead if you load outside a Flutter app build.

The platform loader (`html_to_markdown_ffi_platform`) follows the same
retirement: its macOS sibling-adapter probe and the legacy bundled-`native/`
probe are gone, so a plain-Dart macOS host resolves through the env var →
resolver seam → sibling (Android only) → `~/.html_to_markdown_ffi/` cache →
`target/release` → GitHub release download chain — with the release assets
for `_defaultVersion` (v1.0.0) carrying the arm64/x64 dylibs the download
fallback needs. An app build embeds and Xcode re-signs the framework
automatically; there is nothing left to wire by hand.

```dart
final getIt = GetIt.instance;
registerMacosHtmlToMarkdownFfiDependencies(
  getIt,
  channel: MacosHtmlToMarkdownFfiChannel.native(),
);
final service = getIt<HtmlToMarkdownFfiService>();
```
