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

## Zero-touch installation (1.2.4+)

The native library ships **inside the plugin package**, and the app-facing
package is a real federated plugin. A consumer adds **one** dependency and
changes nothing else — no second package, no Podfile entry, no xcconfig, no
`-force_load` flag, no `jniLibs` copy in the app project, no Gradle edit.

```yaml
dependencies:
  html_to_markdown_ffi: ^1.2.4
```

Flutter resolves the three adapters by itself, through the
`default_package` declarations in the app-facing package:

```yaml
flutter:
  plugin:
    platforms:
      android:
        default_package: html_to_markdown_ffi_android
      ios:
        default_package: html_to_markdown_ffi_ios
      macos:
        default_package: html_to_markdown_ffi_macos
```

Before 1.2.4 the app-facing package was a plain Dart package, so a consumer
had to declare the adapters itself — four dependencies instead of one.

The app-facing package also re-exports the three adapters, so the whole
family's API — the conversion contract, the facade, and the Android, iOS
and macOS registration helpers — is reachable from
`package:html_to_markdown_ffi/html_to_markdown_ffi.dart` alone.

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
`ConversionOptions`, `Visitor`, and the typed exception family. Since
1.2.4 the native binaries live in the federated adapters and the app-facing
package pulls them in, so there is nothing left to add per platform (the
loader chain also still honors `HTML_TO_MARKDOWN_FFI_LIB_PATH`, the legacy
`native/` bundle, the `~/.html_to_markdown_ffi` cache, and GitHub release
downloads).

## Two entry points

The family has one dependency and no project-file change on either side —
but which package you declare depends on whether your consumer is a Flutter
app.

| Consumer | Declare | Flutter SDK |
| -------- | ------- | ----------- |
| A Flutter app | `html_to_markdown_ffi: ^1.2.5` | required |
| A CLI, server or worker | `html_to_markdown_ffi_platform: ^1.2.5` | **not** required |

```yaml
# Flutter app — the native library is linked in by the family itself.
dependencies:
  html_to_markdown_ffi: ^1.2.5
```

```yaml
# Pure Dart — no Flutter SDK in sight.
dependencies:
  html_to_markdown_ffi_platform: ^1.2.5
```

```dart
import 'package:html_to_markdown_ffi_platform/html_to_markdown_ffi_platform.dart';

final md = convert('<h1>Title</h1>');
```

The two run the same in-process `dart:ffi` bridge. The app-facing package's
`convert()` additionally prefers a registered platform adapter over the
direct bridge, which a pure-Dart consumer has no way to register.

A package that carries a `flutter: plugin:` manifest requires the Flutter
SDK — pub.dev will not publish it without an `environment: flutter:`
constraint, and *any* value of that constraint makes it unresolvable for a
standalone Dart SDK. That is why the family ships two entry points rather
than one.

## Zuraffa stack

```dart
import 'package:zuraffa/zuraffa.dart';
import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';

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
