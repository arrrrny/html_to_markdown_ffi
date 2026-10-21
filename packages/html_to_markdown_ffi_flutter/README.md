# html_to_markdown_ffi_flutter

The Flutter plugin for `html_to_markdown_ffi`: one dependency gives a Flutter
app the typed HTML to Markdown conversion *and* the native library linked in
by the family itself.

## One dependency, no project-file change

```yaml
dependencies:
  html_to_markdown_ffi_flutter: ^1.2.7
```

That is the whole wiring. The package carries the plugin manifest and names
the three platform adapters as their platform's `default_package`:

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

So Flutter resolves the adapter for the running platform, the adapter ships
the Rust native library inside itself, and the library is linked into your
app. No Podfile entry, no xcconfig, no `-force_load` flag, no project-file
change of any kind.

## The API

The package re-exports the app-facing package's public API under one name,
so a Flutter app writes a single import:

```dart
import 'package:html_to_markdown_ffi_flutter/html_to_markdown_ffi_flutter.dart';

final md = convert('<h1>Title</h1>');
```

That import also carries the three platform adapters — the Android, iOS, and
macOS registration helpers and their channels — so the zuraffa stack is
reachable from the same place:

```dart
import 'package:zuraffa/zuraffa.dart';
import 'package:html_to_markdown_ffi_flutter/html_to_markdown_ffi_flutter.dart';

final getIt = GetIt.instance;
registerHtmlToMarkdownFfiDependencies(getIt);
registerMacosHtmlToMarkdownFfiDependencies(
  getIt,
  channel: MacosHtmlToMarkdownFfiChannel.native(),
);
```

## Why the plugin is a separate package

A package that carries a `flutter: plugin:` manifest asks for the Flutter
SDK — pub.dev refuses to publish it without an `environment: flutter:`
constraint, and *any* value of that constraint makes it unresolvable for a
consumer that has a plain Dart SDK.

So the engine behind this package — `html_to_markdown_ffi` — is pure Dart
and asks for no Flutter SDK. A CLI, a server, or a background worker depends
on it alone; a Flutter app depends on this package. See the
[family README](../../README.md) for the full picture.

## The family

| Package | Role | Flutter SDK |
| --- | --- | --- |
| `html_to_markdown_ffi` | the engine — pure Dart, the app-facing API | not required |
| `html_to_markdown_ffi_flutter` | the Flutter plugin — this package | required |
| `html_to_markdown_ffi_platform` | the shared, Flutter-free core | not required |
| `html_to_markdown_ffi_android` | the Android adapter | required |
| `html_to_markdown_ffi_ios` | the iOS adapter | required |
| `html_to_markdown_ffi_macos` | the macOS adapter | required |
