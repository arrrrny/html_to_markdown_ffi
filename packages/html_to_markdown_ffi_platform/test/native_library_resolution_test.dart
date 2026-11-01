// The post-retirement resolution contract (review finding on PR #7, issue #6
// follow-up): with the raw macOS dylibs gone, a plain-Dart macOS host
// resolves through env var → resolver seam → sibling probe (Android only) →
// `~/.html_to_markdown_ffi/` cache → `target/release` → loader path →
// release download. Nothing else in the suite asserted that the chain still
// terminates, i.e. that the GitHub release assets `NativeLibrary
// .downloadIfNeeded()` falls back to exist for `_defaultVersion`.
//
// Network-adjacent by design (the finding asks exactly for this); every
// assertion is read-only.
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';

const _repo = 'arrrrny/html-to-markdown';
const _defaultVersion = '1.0.0';

String _platformTarget() {
  if (Platform.isMacOS) {
    return Platform.version.contains('arm64') ? 'aarch64-apple-darwin' : 'x86_64-apple-darwin';
  }
  if (Platform.isLinux) return 'x86_64-unknown-linux-gnu';
  if (Platform.isWindows) return 'x86_64-pc-windows-msvc';
  return 'x86_64-apple-darwin';
}

String _downloadUrlFor({String? version, String? target, String? ext}) {
  final t = target ?? _platformTarget();
  final e = ext ?? (Platform.isWindows ? 'dll' : Platform.isMacOS ? 'dylib' : 'so');
  return 'https://github.com/$_repo/releases/download/'
      'v${version ?? _defaultVersion}/libhtml_to_markdown_ffi-$t.$e';
}

void main() {
  group('post-retirement resolution contract', () {
    test('the macOS loader no longer probes the retired native/ paths', () {
      // The loader seam is pure Dart, so this holds on every host: the
      // retired `native/<rid>/` dylib paths must not re-enter the chain
      // through a sibling or bundled probe. Asserted structurally — the
      // package's own README migration section and the macos adapter's
      // delivery test lock the binary side.
      final source = File('lib/native_library.dart').readAsStringSync();
      expect(
        source.contains("html_to_markdown_ffi_macos/native/"),
        isFalse,
        reason: 'The macOS sibling probe must stay retired: '
            'html_to_markdown_ffi_macos/native/<rid> dylibs no longer ship '
            '(issue #6).',
      );
      expect(
        source.contains('_platformRid'),
        isFalse,
        reason: 'The bundled-library probe (and its runtime-id helper) was '
            'removed with the native/ retirement.',
      );
    });

    test('the release assets downloadIfNeeded() falls back to exist for '
        '_defaultVersion', () async {
      final url = Uri.parse(_downloadUrlFor());
      final head = await http.head(url).timeout(const Duration(seconds: 30));
      // GitHub answers release-asset HEADs with 302 → S3 (200 after the
      // redirect http.Client follows).
      expect(head.statusCode, 200,
          reason: '$url must stay reachable: with the raw dylibs retired it '
              'is the terminal resolution step for a plain-Dart macOS host '
              'that has no cache and no Cargo workspace.');
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('both macOS slice assets of _defaultVersion exist (arm64 + x64)',
        () async {
      for (final target in ['aarch64-apple-darwin', 'x86_64-apple-darwin']) {
        final head = await http
            .head(Uri.parse(_downloadUrlFor(target: target, ext: 'dylib')))
            .timeout(const Duration(seconds: 30));
        expect(head.statusCode, 200,
            reason: 'macOS $target release asset missing — a plain-Dart host '
                'on that slice loses its terminal resolution step.');
      }
    }, timeout: const Timeout(Duration(minutes: 2)));
  });
}
