# html_to_markdown_ffi_platform

The Flutter-free core of the `html_to_markdown_ffi` family, and the family's
entry point for a consumer that is not a Flutter app.

This package asks for **no Flutter SDK** and declares **no plugin manifest**,
so a CLI, a server or a background worker can depend on it alone and convert
HTML to Markdown:

```yaml
dependencies:
  html_to_markdown_ffi_platform: ^1.2.5
```

```dart
import 'package:html_to_markdown_ffi_platform/html_to_markdown_ffi_platform.dart';

final result = convert('<h1>Hello</h1><p>from <b>FFI</b></p>');
print(result.content); // # Hello\n\nfrom **FFI**
```

The conversion runs over the same in-process `dart:ffi` bridge the federated
adapters and the app-facing package use, so it is the same conversion — not a
second implementation.

## What lives here

- the transport seam (`PlatformHtmlToMarkdownFfiEnvelope` — payload decode,
  typed error mapping, timeout) and the native-library resolver seam
  (`HtmNativeLibraries`) the adapters use to contribute their bundled
  binaries to the preserved loading chain;
- the pure-Dart port contract the adapters implement
  (`HtmlToMarkdownFfiPort`);
- the shared value types — `ConversionOptions`, `ConversionResult`, the
  `HeadingStyle` / `LinkStyle` / `CodeBlockStyle` enums, the typed exception
  family and the `Visitor` contract;
- the top-level `convert()`, `convertAsync()` and `nativeConverterAvailable`.

## Two entry points

| Consumer | Declare | Flutter SDK |
| -------- | ------- | ----------- |
| A Flutter app | [`html_to_markdown_ffi`](https://pub.dev/packages/html_to_markdown_ffi) | required |
| A CLI, server or worker | `html_to_markdown_ffi_platform` | **not** required |

A package that carries a `flutter: plugin:` manifest requires the Flutter
SDK — pub.dev will not publish it without an `environment: flutter:`
constraint, and *any* value of that constraint makes it unresolvable for a
standalone Dart SDK. That is why the family ships two entry points rather
than one.

The app-facing package's `convert()` additionally prefers a registered
platform adapter over the direct bridge, which a pure-Dart consumer has no
way to register.

## The native library

The loader chain, in order:

1. `HTML_TO_MARKDOWN_FFI_LIB_PATH`
2. a resolver registered through `HtmNativeLibraries`
3. a sibling adapter in a monorepo checkout (Android/Linux only)
4. the `~/.html_to_markdown_ffi` cache
5. a Cargo `target/release` beside this package
6. the platform loader path (Android `jniLibs`)
7. the process handle — accepted only if `htm_convert` actually resolves,
   because `DynamicLibrary.process()` opens on any process whether or not the
   symbols are there
8. **the copy that ships inside this package** (`native/macos-<rid>/`) — the
   zero-setup path
9. `NativeLibrary.downloadIfNeeded()`, which fetches the matching GitHub
   release asset into `~/.html_to_markdown_ffi/`

Step 8 is what makes a macOS consumer self-sufficient: no environment
variable, no cache, no download. It is probed *before* the process handle is
accepted, so an app that links the macOS xcframework still uses the linked
copy and never loads a second one. Step 9 is the last resort, for a platform
that ships no bundled artifact (Linux, Windows) or a host that has lost it.
