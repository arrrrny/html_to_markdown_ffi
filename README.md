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
| macOS | arm64, x64 | ✓ |
| Linux | arm64, x64 | ✓ |
| Windows | x64 | ✓ |
| Android | arm64-v8a, armeabi-v7a, x86_64 | ✓ |
| iOS | arm64 | ✓ |
| Web | — | Not supported (use WASM binding) |

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

The native library (`libhtml_to_markdown_ffi`) must be built before running tests:

```bash
# Build the Rust FFI library
cargo build --release -p html-to-markdown-ffi

# Run tests
cd packages/dart
dart pub get
dart test
```

## Related

- [Rust core](https://crates.io/crates/html-to-markdown-rs)
- [kreuzberg](https://github.com/kreuzberg-dev/kreuzberg) — Document intelligence framework
- [All language bindings](https://github.com/kreuzberg-dev/html-to-markdown)
