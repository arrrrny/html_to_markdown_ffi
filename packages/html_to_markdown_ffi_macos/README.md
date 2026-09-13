# html_to_markdown_ffi_macos

macOS adapter for `html_to_markdown_ffi`: bundles the prebuilt
`libhtml_to_markdown_ffi.dylib` for arm64 and x64 and registers the port
over an injected channel. Loading dlopens the bundled dylib — the
pre-migration loader logic, preserved.

```dart
final getIt = GetIt.instance;
registerMacosHtmlToMarkdownFfiDependencies(
  getIt,
  channel: MacosHtmlToMarkdownFfiChannel.native(),
);
final service = getIt<HtmlToMarkdownFfiService>();
```
