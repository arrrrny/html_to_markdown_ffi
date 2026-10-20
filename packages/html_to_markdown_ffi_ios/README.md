# html_to_markdown_ffi_ios

iOS adapter for `html_to_markdown_ffi`: registers the port over an injected
channel and ships the Rust native library inside the package.

## Zero-touch distribution

The adapter ships the statically linked slices as
`ios/html_to_markdown_ffi_ios/Frameworks/libhtml_to_markdown_ffi.xcframework`
(`ios-arm64` and the `arm64` + `x86_64` simulator slice) and links it
through the plugin's own Swift package
(`ios/html_to_markdown_ffi_ios/Package.swift`, a `binaryTarget` over that
xcframework). The plugin declares `ffiPlugin: true` for iOS, so Flutter
builds and links it for you.

**A consumer adds the dependency and nothing else** — no Podfile entry, no
xcconfig, no `-force_load` flag, no project-file change of any kind:

```yaml
dependencies:
  html_to_markdown_ffi_ios: ^1.2.3
```

The symbols reach Dart through `DynamicLibrary.process()`.

```dart
final getIt = GetIt.instance;
registerIosHtmlToMarkdownFfiDependencies(
  getIt,
  channel: IosHtmlToMarkdownFfiChannel.native(),
);
```
