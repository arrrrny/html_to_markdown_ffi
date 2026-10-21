# html_to_markdown_ffi

Typed HTML to Markdown conversion for the Zuraffa ecosystem: a Rust FFI core
behind a pure-Dart converter port with federated native adapters.

## Use

### Preserved public API (pre-migration compatible)

```dart
import 'package:html_to_markdown_ffi/html_to_markdown.dart';

final md = convert('<h1>Title</h1>');
// md.content == '# Title'
```

### Zuraffa stack

```dart
import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';

final service = HtmlToMarkdownFfiService.native(); // in-process bridge
final result = await service.convertAsync('<h1>Title</h1>');
```

Or register the stack on GetIt and wire a platform adapter's port for the
running platform:

```dart
final getIt = GetIt.instance;
registerHtmlToMarkdownFfiDependencies(getIt, port: myPlatformPort);
final service = getIt<HtmlToMarkdownFfiService>();
```

## Platform adapters

This package is **pure Dart**: it asks for no Flutter SDK, so a consumer that
is not a Flutter app — a CLI, a server, a background worker — can resolve it
with a plain Dart SDK and no project-file change:

```yaml
dependencies:
  html_to_markdown_ffi: ^1.2.7
```

The native library comes along two ways. On a host where it is not bundled,
`NativeLibrary.downloadIfNeeded()` fetches it from the project's GitHub
releases into `~/.html_to_markdown_ffi/`:

```dart
import 'package:html_to_markdown_ffi/html_to_markdown.dart';

await NativeLibrary.downloadIfNeeded();
final md = convert('<h1>Title</h1>');
```

A **Flutter app** depends on
[`html_to_markdown_ffi_flutter`](https://pub.dev/packages/html_to_markdown_ffi_flutter)
instead. That package is the plugin: it names the three adapters as their
platform's `default_package`, so the prebuilt native binary is linked into
the app, and it re-exports this package's API under one name:

```dart
import 'package:html_to_markdown_ffi_flutter/html_to_markdown_ffi_flutter.dart';

registerMacosHtmlToMarkdownFfiDependencies(
  getIt,
  channel: MacosHtmlToMarkdownFfiChannel.native(),
);
```

- [`html_to_markdown_ffi_flutter`](https://pub.dev/packages/html_to_markdown_ffi_flutter) — the Flutter plugin
- [`html_to_markdown_ffi_android`](https://pub.dev/packages/html_to_markdown_ffi_android)
- [`html_to_markdown_ffi_ios`](https://pub.dev/packages/html_to_markdown_ffi_ios)
- [`html_to_markdown_ffi_macos`](https://pub.dev/packages/html_to_markdown_ffi_macos)

The shared envelope machinery lives in
[`html_to_markdown_ffi_platform`](https://pub.dev/packages/html_to_markdown_ffi_platform).
