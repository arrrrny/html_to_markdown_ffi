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

The symbols reach Dart through `DynamicLibrary.process()`. The bundled
`native/macos-arm64` and `native/macos-x64` dylibs stay in the package as the
fallback for plain-Dart hosts (e.g. `dart test`); an app build uses the
xcframework.

```dart
final getIt = GetIt.instance;
registerMacosHtmlToMarkdownFfiDependencies(
  getIt,
  channel: MacosHtmlToMarkdownFfiChannel.native(),
);
final service = getIt<HtmlToMarkdownFfiService>();
```
