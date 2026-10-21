/// The Flutter plugin for `html_to_markdown_ffi`.
///
/// The engine is pure Dart. `html_to_markdown_ffi` carries the app-facing
/// API — the conversion, the service facade, the DI registration — and asks
/// for no Flutter SDK, so the same import path works in a Flutter app and in
/// a CLI.
///
/// This package is the Flutter-specific wrapper. It carries the plugin
/// manifest, names the three platform adapters as their platform's
/// `default_package`, and re-exports the app-facing API under one name.
///
/// A Flutter app adds this dependency and nothing else: the native library
/// is linked in by the family itself, and no project-file change is needed.
library;

export 'package:html_to_markdown_ffi/html_to_markdown.dart';
export 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';
export 'package:html_to_markdown_ffi_android/html_to_markdown_ffi_android.dart';
export 'package:html_to_markdown_ffi_ios/html_to_markdown_ffi_ios.dart';
export 'package:html_to_markdown_ffi_macos/html_to_markdown_ffi_macos.dart';
