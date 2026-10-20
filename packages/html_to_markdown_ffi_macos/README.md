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

The bundled `native/macos-arm64` and `native/macos-x64` dylibs stay in the
package as the fallback for plain-Dart hosts (e.g. `dart test`); an app build
uses the xcframework.

```dart
final getIt = GetIt.instance;
registerMacosHtmlToMarkdownFfiDependencies(
  getIt,
  channel: MacosHtmlToMarkdownFfiChannel.native(),
);
final service = getIt<HtmlToMarkdownFfiService>();
```
