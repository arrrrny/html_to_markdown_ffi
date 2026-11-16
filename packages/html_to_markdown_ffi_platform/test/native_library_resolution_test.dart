// The platform-loader resolution contract.
//
// This package ships a prebuilt library for macOS (`native/<rid>/`), so a
// plain-Dart consumer resolves with no environment variable, no cache and no
// download. That is the property a fresh machine depends on, and it is what
// these tests lock.
//
// The release-asset assertions cover the other branch: a platform with no
// bundled artifact (Linux, Windows) still falls back to
// `NativeLibrary.downloadIfNeeded()`, so those assets must exist for
// `_defaultVersion`.
//
// Network-adjacent by design (the fallback is the thing under test); every
// assertion is read-only.
import 'dart:ffi';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:html_to_markdown_ffi_platform/native_library.dart';
import 'package:test/test.dart';

const _repo = 'arrrrny/html-to-markdown';
const _defaultVersion = '1.0.0';

String _platformTarget() {
  if (Platform.isMacOS) {
    return Platform.version.contains('arm64')
        ? 'aarch64-apple-darwin'
        : 'x86_64-apple-darwin';
  }
  if (Platform.isLinux) return 'x86_64-unknown-linux-gnu';
  if (Platform.isWindows) return 'x86_64-pc-windows-msvc';
  return 'x86_64-apple-darwin';
}

String _downloadUrlFor({String? version, String? target, String? ext}) {
  final t = target ?? _platformTarget();
  final e =
      ext ??
      (Platform.isWindows
          ? 'dll'
          : Platform.isMacOS
          ? 'dylib'
          : 'so');
  return 'https://github.com/$_repo/releases/download/'
      'v${version ?? _defaultVersion}/libhtml_to_markdown_ffi-$t.$e';
}

void main() {
  group('bundled library', () {
    test('the package ships a loadable library for the running platform', () {
      if (!Platform.isMacOS) {
        markTestSkipped('only macOS ships a bundled artifact');
        return;
      }
      final rid = Platform.version.contains('arm64')
          ? 'macos-arm64'
          : 'macos-x64';
      // `dart test` runs with the package directory as its working directory,
      // so this is the same file the loader resolves through the package
      // config at runtime.
      final dylib = File(
        '${Directory.current.path}/native/$rid/libhtml_to_markdown_ffi.dylib',
      );
      expect(
        dylib.existsSync(),
        isTrue,
        reason:
            '$dylib is the zero-setup path: without it a macOS consumer '
            'falls back to a network download.',
      );

      final library = DynamicLibrary.open(dylib.path);
      expect(
        () => library.lookup<NativeFunction<Void Function()>>('htm_convert'),
        returnsNormally,
        reason:
            '$dylib must export the engine entry point — a file that '
            'merely exists is not a usable library.',
      );
    });

    test('NativeLibrary() resolves with no env var and no resolver', () {
      // The terminal steps of the chain are the process handle and the
      // bundled copy. On macOS the bundled copy is present, so construction
      // must not throw — this is the assertion a clean machine depends on.
      expect(NativeLibrary.new, returnsNormally);
    });
  });

  group('loader hygiene', () {
    test('the loader probes no sibling adapter path of its own', () {
      // The loader seam is pure Dart, so this holds on every host. The
      // macOS adapter's `native/<rid>/` dylibs ship, but this loader must
      // not reach for them through a sibling path: that path exists only in
      // this repository's monorepo layout, and a published consumer reaches
      // the adapter through a declared dependency.
      final source = File('lib/native_library.dart').readAsStringSync();
      expect(
        source.contains('html_to_markdown_ffi_macos/native/'),
        isFalse,
        reason:
            'The macOS sibling probe must stay retired: it would resolve '
            'a monorepo path no published consumer has.',
      );
    });
  });

  group('release-download fallback', () {
    test('the assets downloadIfNeeded() falls back to exist for '
        '_defaultVersion', () async {
      final url = Uri.parse(_downloadUrlFor());
      final head = await http.head(url).timeout(const Duration(seconds: 30));
      // GitHub answers release-asset HEADs with 302 → S3 (200 after the
      // redirect http.Client follows).
      expect(
        head.statusCode,
        200,
        reason:
            '$url must stay reachable: it is the terminal resolution '
            'step for a platform that ships no bundled artifact.',
      );
    }, timeout: const Timeout(Duration(minutes: 2)));

    test(
      'both macOS slice assets of _defaultVersion exist (arm64 + x64)',
      () async {
        for (final target in ['aarch64-apple-darwin', 'x86_64-apple-darwin']) {
          final head = await http
              .head(Uri.parse(_downloadUrlFor(target: target, ext: 'dylib')))
              .timeout(const Duration(seconds: 30));
          expect(
            head.statusCode,
            200,
            reason:
                'macOS $target release asset missing — a host that lost '
                'the bundled copy has no other path.',
          );
        }
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });
}
