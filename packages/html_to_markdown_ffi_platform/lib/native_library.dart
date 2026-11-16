import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:http/http.dart' as http;

import 'html_to_markdown_bindings.dart';

const _repo = 'arrrrny/html-to-markdown';
const _defaultVersion = '1.0.0';

/// Returns the absolute path of a native library the resolver provides, or
/// null when it does not apply to the running platform.
typedef HtmNativeLibraryResolver = String? Function();

/// Resolver seam (spec 064): a host can register a resolver that points at a
/// prebuilt binary, so the preserved loading chain below can find it without
/// the app package shipping binaries itself. Purely additive — the
/// pre-migration resolution steps are unchanged and keep precedence as
/// documented in [NativeLibrary].
///
/// The federated adapters do not register here: in the zero-touch
/// architecture each platform reaches its binary through its own mechanism
/// (the macOS and iOS dynamic products are linked into the app, so
/// `DynamicLibrary.process()` finds the symbols; the Android `jniLibs` entry
/// is found by `DynamicLibrary.open`). The seam is an extension point for a
/// host that resolves the library by path instead.
abstract final class HtmNativeLibraries {
  static final List<HtmNativeLibraryResolver> _resolvers = [];

  /// Registers [resolver] at the highest probe priority. Returns a removal
  /// closure.
  static void Function() registerResolver(HtmNativeLibraryResolver resolver) {
    _resolvers.insert(0, resolver);
    return () => _resolvers.remove(resolver);
  }

  /// First existing library path among the registered resolvers.
  static String? resolve() {
    for (final resolver in List.of(_resolvers)) {
      try {
        final path = resolver();
        if (path != null && File(path).existsSync()) return path;
      } on StateError {
        // ignore: avoid_catches_without_on_clauses
        // A resolver probing an unavailable platform must not break the chain.
      }
    }
    return null;
  }
}

class NativeLibrary {
  static NativeLibrary? _instance;
  final DynamicLibrary _lib;

  NativeLibrary._(this._lib);

  /// Ensures the native library is available before [NativeLibrary] is used.
  ///
  /// Returns `true` immediately when the library is already provided — by the
  /// copy that ships inside this package (`native/<rid>/`), the environment
  /// variable, the resolver seam, the sibling adapter, the
  /// `~/.html_to_markdown_ffi/` cache, or the system loader. Otherwise
  /// downloads the matching GitHub release asset into
  /// `~/.html_to_markdown_ffi/`.
  ///
  /// The download is a last resort: it covers a platform that ships no
  /// bundled artifact (Linux, Windows) and a host that has lost the bundled
  /// one. On macOS a consumer never needs it.
  static Future<bool> downloadIfNeeded() async {
    final bundled = _bundledLibraryPath();
    if (bundled != null && File(bundled).existsSync()) return true;
    final libName = _platformLibraryName();
    final target = _platformTarget();
    final home = Platform.environment['HOME'] ?? '/tmp';
    final cachePath = '$home/.html_to_markdown_ffi/$libName';
    if (File(cachePath).existsSync()) return true;
    final envPath = Platform.environment['HTML_TO_MARKDOWN_FFI_LIB_PATH'];
    if (envPath != null && File(envPath).existsSync()) return true;
    final repoRoot = _findRepoRoot();
    if (repoRoot != null &&
        File('${repoRoot.path}/target/release/$libName').existsSync())
      return true;
    try {
      DynamicLibrary.open(libName);
      return true;
    } catch (_) {}

    final version =
        Platform.environment['HTML_TO_MARKDOWN_FFI_VERSION'] ?? _defaultVersion;
    final ext = Platform.isWindows ? 'dll' : libName.split('.').last;
    final url =
        'https://github.com/$_repo/releases/download/v$version/libhtml_to_markdown_ffi-$target.$ext';
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
    _instance ??= NativeLibrary._(_load());
    return _instance!;
  }

  static DynamicLibrary _load() {
    // 1. Environment variable (useful for testing / custom paths).
    final envPath = Platform.environment['HTML_TO_MARKDOWN_FFI_LIB_PATH'];
    if (envPath != null) {
      try {
        return DynamicLibrary.open(envPath);
      } on ArgumentError {
        throw StateError(
          'Failed to load from HTML_TO_MARKDOWN_FFI_LIB_PATH=$envPath',
        );
      }
    }

    // 2. Resolver seam: a host that resolves the library by path.
    final viaResolver = HtmNativeLibraries.resolve();
    if (viaResolver != null) {
      try {
        return DynamicLibrary.open(viaResolver);
      } on ArgumentError {
        /* next resolution step */
      }
    }

    // 2b. Development monorepo probe: sibling federated adapter packages
    // checked out next to this package (dev checkouts only; a published
    // consumer's tree does not have these siblings). macOS is not probed
    // here: the adapter's `native/<rid>` dylibs ship again (1.3.2), but a
    // macOS host that loads by path reaches them through its own locator
    // over the *declared* `html_to_markdown_ffi_macos` dependency — never
    // through a sibling path no published consumer has.
    final viaSibling = _siblingAdapterLibraryPath();
    if (viaSibling != null) {
      try {
        return DynamicLibrary.open(viaSibling);
      } on ArgumentError {
        /* next resolution step */
      }
    }

    final libName = _platformLibraryName();
    final home = Platform.environment['HOME'] ?? '/tmp';
    final cachePath = '$home/.html_to_markdown_ffi/$libName';
    try {
      return DynamicLibrary.open(cachePath);
    } on ArgumentError {
      /* next resolution step */
    }

    // Dev fallback: a Cargo workspace checked out next to this package.
    final repoRoot = _findRepoRoot();
    if (repoRoot != null) {
      try {
        return DynamicLibrary.open('${repoRoot.path}/target/release/$libName');
      } on ArgumentError {
        /* next resolution step */
      }
    }

    // Android: resolves `libhtml_to_markdown_ffi.so` from the app's jniLibs
    // loader path.
    try {
      return DynamicLibrary.open(libName);
    } on ArgumentError {
      /* next resolution step */
    }

    // A host that already carries the engine: an iOS build links the `.a`
    // statically, and an app that embeds the macOS xcframework has it in the
    // global scope. Probed before the bundled copy so such an app never
    // loads a second one.
    //
    // `DynamicLibrary.process()` and `executable()` always succeed — any
    // process opens them, symbols or not — so opening one proves nothing;
    // the only honest test is whether the entry point resolves.
    final process = DynamicLibrary.process();
    if (_exportsEngine(process)) return process;

    // The copy that ships inside this package (`native/<rid>/`). The
    // zero-setup path: no environment variable, no cache, no download, and
    // the reason a plain-Dart macOS host works on a machine that has never
    // run a setup step.
    final bundled = _bundledLibraryPath();
    if (bundled != null && File(bundled).existsSync()) {
      try {
        final library = DynamicLibrary.open(bundled);
        if (_exportsEngine(library)) return library;
      } on ArgumentError {
        /* next resolution step */
      }
    }

    final executable = DynamicLibrary.executable();
    if (_exportsEngine(executable)) return executable;

    throw StateError(
      'Failed to load $libName. Call NativeLibrary.downloadIfNeeded() first, '
      'set HTML_TO_MARKDOWN_FFI_LIB_PATH, or download from:\n'
      '  https://github.com/$_repo/releases/download/v$_defaultVersion/'
      '${_platformTarget()}',
    );
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
        final pubspec = File(
          '${dir.path}${Platform.pathSeparator}pubspec.yaml',
        );
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

  /// Development-only probe: a federated adapter package checked out as a
  /// sibling of this package (monorepo layout) carrying the prebuilt binary
  /// for the running platform. Returns null everywhere else. macOS is
  /// deliberately absent: the adapter's `native/<rid>` dylibs ship again
  /// (1.3.2), but a host that loads by path resolves them from its *declared*
  /// `html_to_markdown_ffi_macos` dependency — a sibling path is one no
  /// published consumer has, so probing it here would only ever fire in this
  /// repository.
  static String? _siblingAdapterLibraryPath() {
    final packageDir = _resolvePackageDir();
    if (packageDir == null) return null;
    final libName = _platformLibraryName();
    final candidates = <String>[
      if (Platform.isAndroid || Platform.isLinux)
        ...['arm64-v8a', 'armeabi-v7a', 'x86_64', 'x86'].map(
          (abi) =>
              'html_to_markdown_ffi_android/android/src/main/jniLibs/$abi/'
              '${Platform.isAndroid ? libName : 'libhtml_to_markdown_ffi.so'}',
        ),
    ];
    for (final rel in candidates) {
      final f = File(
        '$packageDir${Platform.pathSeparator}..'
        '${Platform.pathSeparator}$rel',
      );
      if (f.existsSync()) return f.path;
    }
    return null;
  }

  /// Whether [library] actually exports the engine's entry point.
  ///
  /// `DynamicLibrary.process()` and `DynamicLibrary.executable()` open on any
  /// process whether or not the symbols are there, so "it opened" is not
  /// evidence — only a resolved `htm_convert` is.
  static bool _exportsEngine(DynamicLibrary library) {
    try {
      library.lookup<NativeFunction<Void Function()>>('htm_convert');
      return true;
    } on ArgumentError {
      return false;
    }
  }

  /// The copy of the library that ships inside this package, for the running
  /// platform's runtime id (e.g.
  /// `native/macos-arm64/libhtml_to_markdown_ffi.dylib`), or null when the
  /// platform ships none.
  ///
  /// The package config is consulted first because it is the only lookup that
  /// works for a published consumer: there, the working directory belongs to
  /// the *host* application, so the walk-up probe below would never reach
  /// this package. The walk-up stays as the in-checkout path.
  static String? _bundledLibraryPath() {
    final rid = _platformRid();
    if (rid == null) return null;
    final relative =
        'native${Platform.pathSeparator}$rid'
        '${Platform.pathSeparator}${_platformLibraryName()}';

    // The package config first: it is the only lookup that works for a
    // published consumer, where the working directory belongs to the *host*
    // application rather than to this package.
    final root = _packageRoot();
    if (root != null) return '$root$relative';

    final packageDir = _resolvePackageDir();
    if (packageDir == null) return null;
    return '$packageDir$relative';
  }

  /// This package's root directory, from the current package config.
  ///
  /// `package:` URIs address a package's `lib/` directory, not its root, so
  /// the root is reached by resolving a file this package certainly has and
  /// stepping up twice. Null when there is no package config to ask — an AOT
  /// snapshot has none, and an embedder that resolves packages itself does not
  /// need one.
  static String? _packageRoot() {
    try {
      final resolved = Isolate.resolvePackageUriSync(
        Uri.parse('package:html_to_markdown_ffi_platform/native_library.dart'),
      );
      if (resolved == null || !resolved.isScheme('file')) return null;
      final lib = File(resolved.toFilePath()).parent;
      return lib.parent.path;
    } on Object {
      return null;
    }
  }

  /// The runtime id matching the `native/` subdirectory names (e.g.
  /// `macos-arm64`, `macos-x64`), or null when this platform ships none.
  ///
  /// Android and iOS return null by design: on Android the app ships
  /// `libhtml_to_markdown_ffi.so` in its `jniLibs` and
  /// `DynamicLibrary.open(name)` resolves it there; on iOS the `.a` is linked
  /// into the app and `DynamicLibrary.process()` exports the symbols.
  static String? _platformRid() {
    if (Platform.isMacOS) {
      return Platform.version.contains('arm64') ? 'macos-arm64' : 'macos-x64';
    }
    return null;
  }

  static String _platformTarget() {
    if (Platform.isMacOS) {
      return Platform.version.contains('arm64')
          ? 'aarch64-apple-darwin'
          : 'x86_64-apple-darwin';
    }
    if (Platform.isLinux) return 'x86_64-unknown-linux-gnu';
    if (Platform.isWindows) return 'x86_64-pc-windows-msvc';
    return 'x86_64-apple-darwin';
  }

  static String _platformLibraryName() {
    if (Platform.isMacOS || Platform.isIOS)
      return 'libhtml_to_markdown_ffi.dylib';
    if (Platform.isLinux || Platform.isAndroid)
      return 'libhtml_to_markdown_ffi.so';
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

  late final Pointer<HTMConversionResult> Function(
    Pointer<Utf8> html,
    Pointer<HTMConversionOptions> options,
  )
  htmConvert = _lib
      .lookup<
        NativeFunction<
          Pointer<HTMConversionResult> Function(
            Pointer<Utf8>,
            Pointer<HTMConversionOptions>,
          )
        >
      >('htm_convert')
      .asFunction();
  late final int Function() htmLastErrorCode = _lib
      .lookup<NativeFunction<Int32 Function()>>('htm_last_error_code')
      .asFunction();
  late final Pointer<Utf8> Function() htmLastErrorContext = _lib
      .lookup<NativeFunction<Pointer<Utf8> Function()>>(
        'htm_last_error_context',
      )
      .asFunction();
  late final void Function(Pointer<Utf8> ptr) htmFreeString = _lib
      .lookup<NativeFunction<Void Function(Pointer<Utf8>)>>('htm_free_string')
      .asFunction();
  late final Pointer<HTMConversionOptions> Function(Pointer<Utf8> json)
  htmConversionOptionsFromJson = _lib
      .lookup<
        NativeFunction<Pointer<HTMConversionOptions> Function(Pointer<Utf8>)>
      >('htm_conversion_options_from_json')
      .asFunction();
  late final void Function(Pointer<HTMConversionOptions> ptr)
  htmConversionOptionsFree = _lib
      .lookup<NativeFunction<Void Function(Pointer<HTMConversionOptions>)>>(
        'htm_conversion_options_free',
      )
      .asFunction();
  late final Pointer<Utf8> Function(Pointer<HTMConversionResult> ptr)
  htmConversionResultToJson = _lib
      .lookup<
        NativeFunction<Pointer<Utf8> Function(Pointer<HTMConversionResult>)>
      >('htm_conversion_result_to_json')
      .asFunction();
  late final void Function(Pointer<HTMConversionResult> ptr)
  htmConversionResultFree = _lib
      .lookup<NativeFunction<Void Function(Pointer<HTMConversionResult>)>>(
        'htm_conversion_result_free',
      )
      .asFunction();
  late final Pointer<HTMHtmHtmlVisitorBridge> Function(
    Pointer<HTMHtmHtmlVisitorVTable> vtable,
    Pointer<Void> userData,
  )
  htmHtmHtmlVisitorBridgeNew = _lib
      .lookup<
        NativeFunction<
          Pointer<HTMHtmHtmlVisitorBridge> Function(
            Pointer<HTMHtmHtmlVisitorVTable>,
            Pointer<Void>,
          )
        >
      >('htm_htm_html_visitor_bridge_new')
      .asFunction();
  late final void Function(Pointer<HTMHtmHtmlVisitorBridge> ptr)
  htmHtmHtmlVisitorBridgeFree = _lib
      .lookup<NativeFunction<Void Function(Pointer<HTMHtmHtmlVisitorBridge>)>>(
        'htm_htm_html_visitor_bridge_free',
      )
      .asFunction();
  late final void Function(
    Pointer<HTMConversionOptions> options,
    Pointer<HTMHtmHtmlVisitorBridge> visitor,
  )
  htmOptionsSetVisitor = _lib
      .lookup<
        NativeFunction<
          Void Function(
            Pointer<HTMConversionOptions>,
            Pointer<HTMHtmHtmlVisitorBridge>,
          )
        >
      >('htm_options_set_visitor')
      .asFunction();
}
