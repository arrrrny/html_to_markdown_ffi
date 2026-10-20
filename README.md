# html_to_markdown_ffi

[![pub](https://img.shields.io/pub/v/html_to_markdown)](https://pub.dev/packages/html_to_markdown)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

High-performance HTML to Markdown conversion for Dart, powered by the
[Rust html-to-markdown](https://github.com/kreuzberg-dev/html-to-markdown)
engine, rebuilt as a zuraffa-native **federated plugin monorepo** (spec 064,
issue [#687](https://github.com/arrrrny/zuraffa/issues/687) under epic #214).

## Family

| Package | Purpose |
|---------|---------|
| [`html_to_markdown_ffi`](https://pub.dev/packages/html_to_markdown) | App-facing: the preserved `convert()` API plus the zuraffa port/service stack |
| [`html_to_markdown_ffi_platform`](https://pub.dev/packages/html_to_markdown_ffi_platform) | Shared envelope core: transport seam, typed error mapping, resolver seam |
| [`html_to_markdown_ffi_android`](https://pub.dev/packages/html_to_markdown_ffi_android) | Android adapter — bundled `armeabi-v7a` / `arm64-v8a` / `x86_64` binaries |
| [`html_to_markdown_ffi_ios`](https://pub.dev/packages/html_to_markdown_ffi_ios) | iOS adapter — Swift package that ships and links the native slices |
| [`html_to_markdown_ffi_macos`](https://pub.dev/packages/html_to_markdown_ffi_macos) | macOS adapter — Swift package that ships and links the native slices |

## Zero-touch installation (1.2.3+)

The native library ships **inside the plugin package**. A consumer adds the
dependency and changes nothing else — no Podfile entry, no xcconfig, no
`-force_load` flag, no `jniLibs` copy in the app project, no Gradle edit.

```yaml
dependencies:
  html_to_markdown_ffi: ^1.2.3
  html_to_markdown_ffi_ios: ^1.2.3    # or _macos / _android
```

How each platform gets the library in place:

- **iOS / macOS** — the adapter ships a Swift package with a `binaryTarget`
  over the bundled `libhtml_to_markdown_ffi.xcframework`. Three details make
  this work, and all three are load-bearing:
  1. the product is named the way Flutter looks it up — the plugin name with
     underscores turned into dashes (`html-to-markdown-ffi-ios`), because the
     product name becomes the CFBundleIdentifier, which cannot contain
     underscores;
  2. the product is `type: .dynamic`, because a static product contributes
     only the object files it compiles itself and the binary target's archive
     is dropped from the link;
  3. a small C target (`html_to_markdown_ffi_ios_anchor`) holds the
     reference `void (*const html_to_markdown_ffi_ios_link_anchor)(void) =
     htm_convert;`, so the linker keeps the archive instead of
     dead-stripping it.

  The `htm_*` symbols then reach Dart through `DynamicLibrary.process()`.
- **Android** — the adapter ships `libhtml_to_markdown_ffi.so` for
  `armeabi-v7a`, `arm64-v8a` and `x86_64` under `android/src/main/jniLibs/<abi>/`,
  and its Gradle module packages those `jniLibs`.

## Quick start (unchanged public API)

```dart
import 'package:html_to_markdown_ffi/html_to_markdown.dart';

final md = convert('<h1>Title</h1><p>Hello <b>world</b></p>');
print(md.content); // # Title\n\nHello **world**
```

`convert()` keeps its pre-migration signature and semantics, including
`ConversionOptions`, `Visitor`, and the typed exception family. The one
deployment change since 1.1.0: the native binaries live in the federated
adapters, so add the adapter for each platform you ship (the loader chain
also still honors `HTML_TO_MARKDOWN_FFI_LIB_PATH`, the legacy `native/`
bundle, the `~/.html_to_markdown_ffi` cache, and GitHub release downloads).

## Zuraffa stack

```dart
import 'package:zuraffa/zuraffa.dart';
import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';
import 'package:html_to_markdown_ffi_macos/html_to_markdown_ffi_macos.dart';

final getIt = GetIt.instance;
registerHtmlToMarkdownFfiDependencies(getIt); // app runtime module
registerMacosHtmlToMarkdownFfiDependencies(
  getIt,
  channel: MacosHtmlToMarkdownFfiChannel.native(), // real in-process FFI
);

final service = getIt<HtmlToMarkdownFfiService>();
final result = await service.convertAsync('<ul><li>one</li></ul>');
```

The stack: `HtmlToMarkdownFfiPort` (platform-neutral contract) →
`HtmlToMarkdownFfiService` (facade with typed failures) →
`GetHtmConversionUseCase` → `HtmConversionRepository` →
`NativeHtmConversionDataSource` (the preserved dart:ffi bridge).

## Development

```bash
# Family board (per package: pub get, analyze, test, publish dry-run)
for pkg in packages/*/; do (cd "$pkg" \
  && dart pub get && dart analyze --no-fatal-warnings \
  && dart test && dart pub publish --dry-run) || echo "FAILED: $pkg"; done
```

See [PUBLISH.md](PUBLISH.md) for the release pipeline.

## License

MIT — see [LICENSE](LICENSE).
