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

Ship the adapter for each platform you target — it bundles the prebuilt
native binary and registers the port:

- [`html_to_markdown_ffi_android`](https://pub.dev/packages/html_to_markdown_ffi_android)
- [`html_to_markdown_ffi_ios`](https://pub.dev/packages/html_to_markdown_ffi_ios)
- [`html_to_markdown_ffi_macos`](https://pub.dev/packages/html_to_markdown_ffi_macos)

The shared envelope machinery lives in
[`html_to_markdown_ffi_platform`](https://pub.dev/packages/html_to_markdown_ffi_platform).
