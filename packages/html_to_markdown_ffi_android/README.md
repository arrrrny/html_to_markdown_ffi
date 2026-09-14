# html_to_markdown_ffi_android

Android adapter for `html_to_markdown_ffi`: bundles the prebuilt
`libhtml_to_markdown_ffi.so` for `armeabi-v7a`, `arm64-v8a`, and `x86_64`,
and registers the port over an injected channel. On-device loading resolves
the `.so` through the jniLibs loader path / process symbols — the
pre-migration loader logic, preserved.

```dart
final getIt = GetIt.instance;
registerAndroidHtmlToMarkdownFfiDependencies(
  getIt,
  channel: AndroidHtmlToMarkdownFfiChannel.native(),
);
```
