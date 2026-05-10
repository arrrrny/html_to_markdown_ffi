import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

import 'html_to_markdown_bindings.dart';

class NativeLibrary {
  static NativeLibrary? _instance;
  final DynamicLibrary _lib;

  NativeLibrary._(this._lib);

  factory NativeLibrary() {
    return _instance ??= NativeLibrary._(_load());
  }

  static DynamicLibrary _load() {
    final libName = _platformLibraryName();

    // Search paths
    final repoRoot = _findRepoRoot();
    final candidates = <String>[
      if (repoRoot != null) '${repoRoot.path}/target/release/$libName',
      libName,
    ];

    for (final path in candidates) {
      try {
        return DynamicLibrary.open(path);
      } on ArgumentError {
        continue;
      }
    }

    try {
      return DynamicLibrary.process();
    } on ArgumentError {
      try {
        return DynamicLibrary.executable();
      } on ArgumentError {
        throw StateError(
            'Failed to load $libName on ${Platform.operatingSystem}. '
            'Ensure the native library is bundled with your application.');
      }
    }
  }

  static Directory? _findRepoRoot() {
    var dir = Directory.current;
    for (var i = 0; i < 10; i++) {
      if (File('${dir.path}/Cargo.toml').existsSync()) {
        return dir;
      }
      final parent = dir.parent;
      if (parent.path == dir.path) break;
      dir = parent;
    }
    return null;
  }

  static String _platformLibraryName() {
    if (Platform.isMacOS || Platform.isIOS) {
      return 'libhtml_to_markdown_ffi.dylib';
    } else if (Platform.isLinux || Platform.isAndroid) {
      return 'libhtml_to_markdown_ffi.so';
    } else if (Platform.isWindows) {
      return 'html_to_markdown_ffi.dll';
    }
    return 'libhtml_to_markdown_ffi.dylib';
  }

  // Core conversion
  late final Pointer<HTMConversionResult> Function(
          Pointer<Utf8> html, Pointer<HTMConversionOptions> options)
      htmConvert = _lib
          .lookup<NativeFunction<
              Pointer<HTMConversionResult> Function(
                  Pointer<Utf8>, Pointer<HTMConversionOptions>)>>('htm_convert')
          .asFunction();

  // Error handling
  late final int Function() htmLastErrorCode = _lib
      .lookup<NativeFunction<Int32 Function()>>('htm_last_error_code')
      .asFunction();

  late final Pointer<Utf8> Function() htmLastErrorContext = _lib
      .lookup<NativeFunction<Pointer<Utf8> Function()>>(
          'htm_last_error_context')
      .asFunction();

  // Memory management
  late final void Function(Pointer<Utf8> ptr) htmFreeString = _lib
      .lookup<NativeFunction<Void Function(Pointer<Utf8>)>>('htm_free_string')
      .asFunction();

  // Conversion options
  late final Pointer<HTMConversionOptions> Function(Pointer<Utf8> json)
      htmConversionOptionsFromJson = _lib
          .lookup<NativeFunction<
              Pointer<HTMConversionOptions> Function(Pointer<Utf8>)>>(
              'htm_conversion_options_from_json')
          .asFunction();

  late final void Function(Pointer<HTMConversionOptions> ptr)
      htmConversionOptionsFree = _lib
          .lookup<NativeFunction<
              Void Function(Pointer<HTMConversionOptions>)>>(
              'htm_conversion_options_free')
          .asFunction();

  // Conversion result
  late final Pointer<Utf8> Function(Pointer<HTMConversionResult> ptr)
      htmConversionResultToJson = _lib
          .lookup<NativeFunction<
              Pointer<Utf8> Function(Pointer<HTMConversionResult>)>>(
              'htm_conversion_result_to_json')
          .asFunction();

  late final void Function(Pointer<HTMConversionResult> ptr)
      htmConversionResultFree = _lib
          .lookup<NativeFunction<
              Void Function(Pointer<HTMConversionResult>)>>(
              'htm_conversion_result_free')
          .asFunction();

  // Visitor bridge (VTable approach)
  late final Pointer<HTMHtmHtmlVisitorBridge> Function(
          Pointer<HTMHtmHtmlVisitorVTable> vtable,
          Pointer<Void> userData) htmHtmHtmlVisitorBridgeNew = _lib
      .lookup<NativeFunction<
          Pointer<HTMHtmHtmlVisitorBridge> Function(
              Pointer<HTMHtmHtmlVisitorVTable>, Pointer<Void>)>>(
          'htm_htm_html_visitor_bridge_new')
      .asFunction();

  late final void Function(Pointer<HTMHtmHtmlVisitorBridge> ptr)
      htmHtmHtmlVisitorBridgeFree = _lib
          .lookup<NativeFunction<
              Void Function(Pointer<HTMHtmHtmlVisitorBridge>)>>(
              'htm_htm_html_visitor_bridge_free')
          .asFunction();

  late final void Function(
          Pointer<HTMConversionOptions> options,
          Pointer<HTMHtmHtmlVisitorBridge> visitor) htmOptionsSetVisitor = _lib
      .lookup<NativeFunction<
          Void Function(Pointer<HTMConversionOptions>,
              Pointer<HTMHtmHtmlVisitorBridge>)>>('htm_options_set_visitor')
      .asFunction();
}
