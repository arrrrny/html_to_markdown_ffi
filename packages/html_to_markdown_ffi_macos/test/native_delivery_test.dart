// Issue #6: the raw per-slice binaries under `native/macos-*` are retired —
// the xcframework behind the SPM `Package.swift` binary target is the only
// macOS delivery surface. A leftover raw dylib invites consumers to keep a
// legacy "embed + codesign dylib" build phase, which produces a second copy
// of the engine in the app bundle (and dies at CodeSign when the login
// keychain disallows interaction).
//
// The `.a` build slices live only inside the xcframework
// (`macos/html_to_markdown_ffi_macos/Frameworks/...`); the loose copies
// under `native/` were leftovers from the pre-federated layout and are
// retired with the dylibs so the published package carries no dead binaries.
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

  test('no loose build slice remains under native/ — the xcframework '
      'carries the only archives', () {
    final nativeDir = Directory('${Directory.current.path}/native');
    if (!nativeDir.existsSync()) return;
    final leftovers = nativeDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dylib') || f.path.endsWith('.a'))
        .toList();
    expect(
      leftovers,
      isEmpty,
      reason: 'The static archives are xcframework build inputs, not '
          'delivery artifacts: they belong under '
          'macos/html_to_markdown_ffi_macos/Frameworks/ (built by '
          'scripts/build_native.sh), never loose under native/.',
    );
  });

  test('the xcframework slice the SPM binaryTarget links stays', () {
    final slice = File(
      '${Directory.current.path}/macos/html_to_markdown_ffi_macos/'
      'Frameworks/libhtml_to_markdown_ffi.xcframework/'
      'macos-arm64_x86_64/libhtml_to_markdown_ffi.a',
    );
    expect(
      slice.existsSync(),
      isTrue,
      reason: '$slice is the build input Package.swift\'s binaryTarget '
          'resolves — it must stay.',
    );
  });
}
