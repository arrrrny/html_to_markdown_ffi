# html_to_markdown_ffi_ios

iOS adapter for `html_to_markdown_ffi`: bundles the statically linked
slices (`ios-arm64`, `ios-sim-arm64`, `ios-sim-x64`) and registers the
port over an injected channel. On-device loading resolves symbols through
`DynamicLibrary.process()` — the pre-migration loader logic, preserved.

```dart
final getIt = GetIt.instance;
registerIosHtmlToMarkdownFfiDependencies(
  getIt,
  channel: IosHtmlToMarkdownFfiChannel.native(),
);
```
