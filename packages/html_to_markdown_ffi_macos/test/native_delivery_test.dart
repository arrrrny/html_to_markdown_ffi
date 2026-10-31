// Issue #6: the raw per-slice dylibs under `native/macos-*` are retired —
// the xcframework behind the SPM `Package.swift` binary target is the only
// macOS delivery surface. A leftover raw dylib invites consumers to keep a
// legacy "embed + codesign dylib" build phase, which produces a second copy
// of the engine in the app bundle (and dies at CodeSign when the login
// keychain disallows interaction).
//
// The static archives stay: they are the slices `scripts/build_native.sh`
// lipo-checks and the xcframework is built from.
import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('the macOS adapter ships no raw dylib next to the xcframework', () {
    final packageRoot = Directory.current.path;
    for (final rid in ['macos-arm64', 'macos-x64']) {
      final dylib = File(
        '$packageRoot/native/$rid/libhtml_to_markdown_ffi.dylib',
      );
      expect(
        dylib.existsSync(),
        isFalse,
        reason:
            '$dylib must not ship: the SPM xcframework is the only macOS '
            'delivery surface, and a raw dylib keeps legacy embed/codesign '
            'build phases alive (issue #6).',
      );
    }
  });

  test('the static slices the xcframework is built from remain', () {
    final packageRoot = Directory.current.path;
    for (final rid in ['macos-arm64', 'macos-x64']) {
      final archive = File(
        '$packageRoot/native/$rid/libhtml_to_markdown_ffi.a',
      );
      expect(
        archive.existsSync(),
        isTrue,
        reason: '$archive is an xcframework build '
            'slice, not a delivery artifact — it must stay.',
      );
    }
  });
}
