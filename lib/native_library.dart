import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:http/http.dart' as http;

import 'html_to_markdown_bindings.dart';

const _repo = 'arrrrny/html-to-markdown';
const _defaultVersion = '1.0.0';

class NativeLibrary {
  static NativeLibrary? _instance;
  final DynamicLibrary _lib;

  NativeLibrary._(this._lib);

  static Future<bool> downloadIfNeeded() async {
    final libName = _platformLibraryName();
    final target = _platformTarget();
    final home = Platform.environment['HOME'] ?? '/tmp';
    final cachePath = '$home/.html_to_markdown_ffi/$libName';
    if (File(cachePath).existsSync()) return true;
    final envPath = Platform.environment['HTML_TO_MARKDOWN_FFI_LIB_PATH'];
    if (envPath != null && File(envPath).existsSync()) return true;
    final repoRoot = _findRepoRoot();
    if (repoRoot != null && File('${repoRoot.path}/target/release/$libName').existsSync()) return true;
    try {
      DynamicLibrary.open(libName);
      return true;
    } catch (_) {}

    final version = Platform.environment['HTML_TO_MARKDOWN_FFI_VERSION'] ?? _defaultVersion;
    final ext = Platform.isWindows ? 'dll' : libName.split('.').last;
    final url = 'https://github.com/$_repo/releases/download/v$version/libhtml_to_markdown_ffi-$target.$ext';
    try {
      final r = await http.get(Uri.parse(url));
      if (r.statusCode == 200) {
        await Directory('$home/.html_to_markdown_ffi').create(recursive: true);
        await File(cachePath).writeAsBytes(r.bodyBytes);
        return true;
      }
    } catch (_) {}
    return false;
  }

  factory NativeLibrary() {
    if (_instance == null) {
      _instance = NativeLibrary._(_load());
    }
    return _instance!;
  }

  static DynamicLibrary _load() {
    final libName = _platformLibraryName();
    final home = Platform.environment['HOME'] ?? '/tmp';
    final cachePath = '$home/.html_to_markdown_ffi/$libName';

    final envPath = Platform.environment['HTML_TO_MARKDOWN_FFI_LIB_PATH'];
    if (envPath != null) {
      try { return DynamicLibrary.open(envPath); } on ArgumentError {
        throw StateError('Failed to load from HTML_TO_MARKDOWN_FFI_LIB_PATH=$envPath');
      }
    }
    try { return DynamicLibrary.open(cachePath); } on ArgumentError {}
    final repoRoot = _findRepoRoot();
    if (repoRoot != null) {
      try { return DynamicLibrary.open('${repoRoot.path}/target/release/$libName'); } on ArgumentError {}
    }
    try { return DynamicLibrary.open(libName); } on ArgumentError {}
    try { return DynamicLibrary.process(); } on ArgumentError {}
    try { return DynamicLibrary.executable(); } on ArgumentError {}

    throw StateError(
      'Failed to load $libName. Call NativeLibrary.downloadIfNeeded() first, '
      'set HTML_TO_MARKDOWN_FFI_LIB_PATH, or download from:\n'
      '  https://github.com/$_repo/releases/download/v$_defaultVersion/'
      '${_platformTarget()}',
    );
  }

  static String _platformTarget() {
    if (Platform.isMacOS) {
      return Platform.version.contains('arm64') ? 'aarch64-apple-darwin' : 'x86_64-apple-darwin';
    }
    if (Platform.isLinux) return 'x86_64-unknown-linux-gnu';
    if (Platform.isWindows) return 'x86_64-pc-windows-msvc';
    return 'x86_64-apple-darwin';
  }

  static String _platformLibraryName() {
    if (Platform.isMacOS || Platform.isIOS) return 'libhtml_to_markdown_ffi.dylib';
    if (Platform.isLinux || Platform.isAndroid) return 'libhtml_to_markdown_ffi.so';
    if (Platform.isWindows) return 'html_to_markdown_ffi.dll';
    return 'libhtml_to_markdown_ffi.dylib';
  }

  static Directory? _findRepoRoot() {
    var dir = Directory.current;
    for (var i = 0; i < 10; i++) {
      if (File('${dir.path}/Cargo.toml').existsSync()) return dir;
      final parent = dir.parent;
      if (parent.path == dir.path) break;
      dir = parent;
    }
    return null;
  }

  late final Pointer<HTMConversionResult> Function(Pointer<Utf8> html, Pointer<HTMConversionOptions> options) htmConvert =
      _lib.lookup<NativeFunction<Pointer<HTMConversionResult> Function(Pointer<Utf8>, Pointer<HTMConversionOptions>)>>('htm_convert').asFunction();
  late final int Function() htmLastErrorCode =
      _lib.lookup<NativeFunction<Int32 Function()>>('htm_last_error_code').asFunction();
  late final Pointer<Utf8> Function() htmLastErrorContext =
      _lib.lookup<NativeFunction<Pointer<Utf8> Function()>>('htm_last_error_context').asFunction();
  late final void Function(Pointer<Utf8> ptr) htmFreeString =
      _lib.lookup<NativeFunction<Void Function(Pointer<Utf8>)>>('htm_free_string').asFunction();
  late final Pointer<HTMConversionOptions> Function(Pointer<Utf8> json) htmConversionOptionsFromJson =
      _lib.lookup<NativeFunction<Pointer<HTMConversionOptions> Function(Pointer<Utf8>)>>('htm_conversion_options_from_json').asFunction();
  late final void Function(Pointer<HTMConversionOptions> ptr) htmConversionOptionsFree =
      _lib.lookup<NativeFunction<Void Function(Pointer<HTMConversionOptions>)>>('htm_conversion_options_free').asFunction();
  late final Pointer<Utf8> Function(Pointer<HTMConversionResult> ptr) htmConversionResultToJson =
      _lib.lookup<NativeFunction<Pointer<Utf8> Function(Pointer<HTMConversionResult>)>>('htm_conversion_result_to_json').asFunction();
  late final void Function(Pointer<HTMConversionResult> ptr) htmConversionResultFree =
      _lib.lookup<NativeFunction<Void Function(Pointer<HTMConversionResult>)>>('htm_conversion_result_free').asFunction();
  late final Pointer<HTMHtmHtmlVisitorBridge> Function(Pointer<HTMHtmHtmlVisitorVTable> vtable, Pointer<Void> userData) htmHtmHtmlVisitorBridgeNew =
      _lib.lookup<NativeFunction<Pointer<HTMHtmHtmlVisitorBridge> Function(Pointer<HTMHtmHtmlVisitorVTable>, Pointer<Void>)>>('htm_htm_html_visitor_bridge_new').asFunction();
  late final void Function(Pointer<HTMHtmHtmlVisitorBridge> ptr) htmHtmHtmlVisitorBridgeFree =
      _lib.lookup<NativeFunction<Void Function(Pointer<HTMHtmHtmlVisitorBridge>)>>('htm_htm_html_visitor_bridge_free').asFunction();
  late final void Function(Pointer<HTMConversionOptions> options, Pointer<HTMHtmHtmlVisitorBridge> visitor) htmOptionsSetVisitor =
      _lib.lookup<NativeFunction<Void Function(Pointer<HTMConversionOptions>, Pointer<HTMHtmHtmlVisitorBridge>)>>('htm_options_set_visitor').asFunction();
}
