# html_to_markdown_ffi_android

Android adapter for `html_to_markdown_ffi`: registers the port over an
injected channel and ships the Rust native library inside the package.

## Zero-touch distribution

The adapter ships `libhtml_to_markdown_ffi.so` for `armeabi-v7a`,
`arm64-v8a`, and `x86_64` under
`android/src/main/jniLibs/<abi>/`, and its Gradle module packages those
`jniLibs` (`jniLibs.srcDirs = ['src/main/jniLibs']`). The plugin declares
`ffiPlugin: true` for Android, so Flutter wires it for you.

**A consumer adds the dependency and nothing else** — no `jniLibs` copy in
the app project, no Gradle edit, no `externalNativeBuild`, no project-file
change of any kind:

```yaml
dependencies:
  html_to_markdown_ffi_android: ^1.2.3
```

The library is loaded in-process through `dart:ffi`
(`DynamicLibrary.open('libhtml_to_markdown_ffi.so')` resolves it from the
app's jniLibs loader path).

```dart
final getIt = GetIt.instance;
registerAndroidHtmlToMarkdownFfiDependencies(
  getIt,
  channel: AndroidHtmlToMarkdownFfiChannel.native(),
);
```
