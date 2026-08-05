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

  /// Ensures the native library is available before [NativeLibrary] is used.
  ///
  /// Returns `true` immediately when a bundled binary ships with the package
  /// (see `native/`), or when any of the other resolution paths (env var,
  /// cache, system loader) already provide the library. Otherwise downloads
  /// the matching GitHub release asset into `~/.html_to_markdown_ffi/`.
  static Future<bool> downloadIfNeeded() async {
    if (_bundledLibraryPath() != null) return true;
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
    // 1. Environment variable (useful for testing / custom paths).
    final envPath = Platform.environment['HTML_TO_MARKDOWN_FFI_LIB_PATH'];
    if (envPath != null) {
      try { return DynamicLibrary.open(envPath); } on ArgumentError {
        throw StateError('Failed to load from HTML_TO_MARKDOWN_FFI_LIB_PATH=$envPath');
      }
    }

    // 2. Bundled native library shipped inside this package
    //    (`native/<rid>/libhtml_to_markdown_ffi.*`). Resolves the package's
    //    own directory so the binary "just works" without manual setup on the
    //    platforms we ship prebuilt artifacts for (macOS arm64 + x64).
    final bundled = _bundledLibraryPath();
    if (bundled != null && File(bundled).existsSync()) {
      try { return DynamicLibrary.open(bundled); } on ArgumentError {}
    }

    final libName = _platformLibraryName();
    final home = Platform.environment['HOME'] ?? '/tmp';
    final cachePath = '$home/.html_to_markdown_ffi/$libName';
    try { return DynamicLibrary.open(cachePath); } on ArgumentError {}

    // Dev fallback: a Cargo workspace checked out next to this package.
    final repoRoot = _findRepoRoot();
    if (repoRoot != null) {
      try { return DynamicLibrary.open('${repoRoot.path}/target/release/$libName'); } on ArgumentError {}
    }

    // Android: resolves `libhtml_to_markdown_ffi.so` from the app's jniLibs
    // loader path. iOS: resolves symbols statically linked into the app.
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

  /// Resolves the path of the bundled native library for this platform's
  /// "runtime identifier" (e.g. `native/macos-x64/libhtml_to_markdown_ffi.dylib`).
  /// Returns null when the package can't be located or the platform has no
  /// bundled artifact.
  static String? _bundledLibraryPath() {
    final rid = _platformRid();
    if (rid == null) return null;
    final packageDir = _resolvePackageDir();
    if (packageDir == null) return null;
    final libName = _platformLibraryName();
    return '$packageDir${Platform.pathSeparator}'
        'native${Platform.pathSeparator}$rid'
        '${Platform.pathSeparator}$libName';
  }

  /// Finds this package's root directory. Tries, in order:
  ///  1. the current working directory (works in `dart test` / `flutter test`,
  ///     where CWD is the package dir), and
  ///  2. walking up from the running script (works in `dart run`).
  /// Stops at the first `pubspec.yaml` declaring `name: html_to_markdown_ffi`.
  static String? _resolvePackageDir() {
    final candidates = <String>{
      Directory.current.path,
      File(Platform.script.toFilePath()).parent.path,
    };
    for (final start in candidates) {
      var dir = Directory(start);
      for (var i = 0; i < 12; i++) {
        final pubspec = File('${dir.path}${Platform.pathSeparator}pubspec.yaml');
        if (pubspec.existsSync() &&
            pubspec.readAsStringSync().contains('name: html_to_markdown_ffi')) {
          return dir.path;
        }
        final parent = dir.parent;
        if (parent.path == dir.path) break;
        dir = parent;
      }
    }
    return null;
  }

  /// Platform runtime identifier matching the `native/` subdirectory names
  /// (e.g. `macos-arm64`, `macos-x64`). Null when unsupported.
  ///
  /// Android/iOS intentionally return null here: on those platforms the lib
  /// is NOT dlopen'd from a bundled path.
  ///   - Android: the app ships `libhtml_to_markdown_ffi.so` in
  ///     `android/app/src/main/jniLibs/<abi>/`; `DynamicLibrary.open(name)`
  ///     resolves it from the jniLibs loader path.
  ///   - iOS: the `.a` is statically linked into the app; `DynamicLibrary
  ///     .process()` finds the symbols.
  static String? _platformRid() {
    if (Platform.isMacOS) {
      return Platform.version.contains('arm64') ? 'macos-arm64' : 'macos-x64';
    }
    return null;
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
