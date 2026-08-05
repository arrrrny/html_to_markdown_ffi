# html_to_markdown

[![Dart](https://img.shields.io/badge/Dart-3.10+-0175C2?logo=dart)](https://dart.dev)
[![pub](https://img.shields.io/pub/v/html_to_markdown)](https://pub.dev/packages/html_to_markdown)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

High-performance HTML to Markdown converter for Dart and Flutter, powered by the
[Rust html-to-markdown](https://github.com/kreuzberg-dev/html-to-markdown) engine
via FFI bindings. **150-280 MB/s** throughput — 10-80x faster than pure Dart alternatives.

## Features

- **Blazing fast**: Rust-powered conversion engine via FFI
- **Byte-identical output**: Matches the Rust core exactly for all input
- **Full metadata extraction**: Title, description, author, keywords, OpenGraph, JSON-LD
- **Comprehensive options**: 40+ conversion settings (heading style, code blocks, links, whitespace, etc.)
- **Visitor pattern**: Customize element-level conversion behavior
- **Cross-platform**: Android, iOS, macOS, Linux, Windows

## Installation

```bash
dart pub add html_to_markdown
```

## Quick Start

```dart
import 'package:html_to_markdown/html_to_markdown.dart';

void main() {
  final html = '<h1>Hello World</h1><p>This is a <strong>test</strong>.</p>';

  // Basic conversion
  final result = convert(html);
  print(result.content);
  // # Hello World
  //
  // This is a **test**.
}
```

## Configuration

```dart
final options = ConversionOptions()
  ..headingStyle = HeadingStyle.setext
  ..linkStyle = LinkStyle.referenced
  ..extractMetadata = true
  ..wrap = true
  ..wrapWidth = 80;

final result = convert(html, options: options);
```

## Metadata Extraction

```dart
final options = ConversionOptions()..extractMetadata = true;
final result = convert(htmlWithMeta, options: options);

print(result.metadata?.title);       // Page title
print(result.metadata?.description); // Meta description
print(result.metadata?.author);      // Author
print(result.metadata?.keywords);    // Keywords list
```

## Custom Visitor

```dart
class ScriptStripper extends Visitor {
  @override
  VisitResult visitElementStart(NodeContext ctx) {
    if (ctx.tagName == 'script' || ctx.tagName == 'style') {
      return VisitResult.skip;
    }
    return VisitResult.continue_;
  }
}

final result = convert(html, visitor: ScriptStripper());
```

## Platform Support

| Platform | Arch | Status |
|----------|------|--------|
| macOS | arm64, x64 | ✓ (binary bundled) |
| iOS (device) | arm64 | ✓ (static lib bundled) |
| iOS Simulator | arm64, x64 | ✓ (static lib bundled) |
| Android | arm64-v8a, armeabi-v7a, x86_64 | ✓ (`.so` bundled) |
| Linux | arm64, x64 | ✓ (build from source) |
| Windows | x64 | ✓ (build from source) |
| Web | — | Not supported (use WASM binding) |

## Native libraries

Prebuilt native binaries are **shipped inside the package** under `native/`, so
the library is already there when the package is installed — no download step
or manual toolchain setup is needed on the supported platforms:

```
native/
├── include/html_to_markdown.h          # C header (for custom integration)
├── macos-x64/libhtml_to_markdown_ffi.dylib
├── macos-arm64/libhtml_to_markdown_ffi.dylib
├── ios/
│   ├── ios-arm64.a                     # device
│   ├── ios-sim-arm64.a                 # Apple Silicon simulator
│   └── ios-sim-x64.a                   # Intel simulator
└── android/
    ├── arm64-v8a/libhtml_to_markdown_ffi.so
    ├── armeabi-v7a/libhtml_to_markdown_ffi.so
    └── x86_64/libhtml_to_markdown_ffi.so
```

- **macOS** — the correct dylib for the host architecture is loaded
  automatically from the package directory. Nothing to do.
- **Android** — copy the `.so` file(s) you need into your app's jniLibs; the
  loader resolves `libhtml_to_markdown_ffi.so` from the Android loader path:

  ```bash
  cp native/android/arm64-v8a/libhtml_to_markdown_ffi.so \
     <your-app>/android/app/src/main/jniLibs/arm64-v8a/
  cp native/android/armeabi-v7a/libhtml_to_markdown_ffi.so \
     <your-app>/android/app/src/main/jniLibs/armeabi-v7a/
  cp native/android/x86_64/libhtml_to_markdown_ffi.so \
     <your-app>/android/app/src/main/jniLibs/x86_64/
  ```

- **iOS** — iOS uses a static library linked into the app at build time (not
  dlopen'd). Add the `.a` for your target to the Runner (e.g. `ios/Runner/
  Frameworks` + the Xcode "Link Binary With Libraries" build phase); the loader
  then finds the symbols via `DynamicLibrary.process()`:
  - device: `native/ios/ios-arm64.a`
  - Apple Silicon simulator: `native/ios/ios-sim-arm64.a`
  - Intel simulator: `native/ios/ios-sim-x64.a`

### Native library resolution order

`NativeLibrary` tries, in order:

1. `HTML_TO_MARKDOWN_FFI_LIB_PATH` env var (testing / custom paths)
2. **Bundled binary** — `native/<rid>/libhtml_to_markdown_ffi.*` shipped inside
   the package (macOS arm64/x64)
3. `~/.html_to_markdown_ffi/` cache (populated by `downloadIfNeeded()`)
4. A checked-out Cargo workspace's `target/release/` (development)
5. Platform default name (`DynamicLibrary.open(libName)` — Android jniLibs)
6. `DynamicLibrary.process()` / `executable()` (iOS static link)

`NativeLibrary.downloadIfNeeded()` short-circuits when a bundled binary is
present and is otherwise only needed on platforms without bundled artifacts
(Linux, Windows).

## API Reference

### Functions

- `convert(String html, {ConversionOptions? options, Visitor? visitor}) → ConversionResult`

### Classes

- `ConversionOptions` — 40+ configuration fields
- `ConversionResult` — Output with content, metadata, tables, images, warnings
- `HtmlMetadata` — Extracted page metadata
- `Visitor` — Abstract class with 38 element-level callbacks
- `NodeContext` — Context passed to visitor callbacks

### Enums

`HeadingStyle`, `LinkStyle`, `CodeBlockStyle`, `WhitespaceMode`, `OutputFormat`,
`NewlineStyle`, `HighlightStyle`, `ListIndentType`, `PreprocessingPreset`,
`VisitResult`, `NodeType`, `WarningKind`

### Exceptions

`HtmlToMarkdownException`, `InvalidInputException`, `ConversionErrorException`

## Development

Prebuilt binaries for the supported platforms ship with the package
(`native/`), so tests and examples run out of the box. To rebuild the native
library (`libhtml_to_markdown_ffi`) from source instead, use the Rust repo:

```bash
git clone https://github.com/arrrrny/html-to-markdown.git
cd html-to-markdown/crates/html-to-markdown-ffi
cargo build --release
```

# Run tests
dart pub get
dart test

## Related

- [Rust core](https://crates.io/crates/html-to-markdown-rs)
- [kreuzberg](https://github.com/kreuzberg-dev/kreuzberg) — Document intelligence framework
- [All language bindings](https://github.com/kreuzberg-dev/html-to-markdown)
