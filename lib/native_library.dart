import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

import 'html_to_markdown_bindings.dart';

const _repo = 'arrrrny/html-to-markdown';
const _defaultVersion = '1.0.0';

class NativeLibrary {
  static NativeLibrary? _instance;
  final DynamicLibrary _lib;

  NativeLibrary._(this._lib);

  factory NativeLibrary() {
    return _instance ??= NativeLibrary._(_load());
  }

  /// Download the native library from GitHub release (call before first use).
  /// Returns true if the library is available after download.
  static Future<bool> downloadIfNeeded() async {
    final libName = _platformLibraryName();
    final target = _platformTarget();
    final ext = Platform.isWindows ? 'dll' : libName.split('.').last;
    final home = Platform.environment['HOME'] ?? '/tmp';
    final cachePath = '$home/.html_to_markdown_ffi/$libName';

    if (File(cachePath).existsSync()) return true;

    final envPath = Platform.environment['HTML_TO_MARKDOWN_FFI_LIB_PATH'];
    if (envPath != null && File(envPath).existsSync()) return true;

    final version = Platform.environment['HTML_TO_MARKDOWN_FFI_VERSION'] ?? _defaultVersion;
    final url = 'https://github.com/$_repo/releases/download/v$version/libhtml_to_markdown_ffi-$target.$ext';

    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(url));
      client.close();
      if (response.statusCode == 200) {
        final dir = Directory('$home/.html_to_markdown_ffi');
        await dir.create(recursive: true);
        await File(cachePath).writeAsBytes(response.bodyBytes);
        return true;
      }
    } catch (_) {}
    return false;
  }

  static DynamicLibrary _load() {
    final libName = _platformLibraryName();
    final target = _platformTarget();
    final ext = Platform.isWindows ? 'dll' : libName.split('.').last;

    final envPath = Platform.environment['HTML_TO_MARKDOWN_FFI_LIB_PATH'];
    if (envPath != null) {
      try { return DynamicLibrary.open(envPath); }
      on ArgumentError { throw StateError('Failed to load $envPath'); }
    }

    final home = Platform.environment['HOME'] ?? '/tmp';
    final cachePath = '$home/.html_to_markdown_ffi/$libName';
    try { return DynamicLibrary.open(cachePath); }
    on ArgumentError {}

    final repoRoot = _findRepoRoot();
    if (repoRoot != null) {
      final devPath = '${repoRoot.path}/target/release/$libName';
      try { return DynamicLibrary.open(devPath); }
      on ArgumentError {}
    }

    try { return DynamicLibrary.open(libName); }
    on ArgumentError {}

    throw StateError(
      'Failed to load $libName. Call NativeLibrary.downloadIfNeeded() first, '
      'set HTML_TO_MARKDOWN_FFI_LIB_PATH, or download from:\n'
      '  https://github.com/$_repo/releases/download/v$_defaultVersion/'
      'libhtml_to_markdown_ffi-$target.$ext',
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