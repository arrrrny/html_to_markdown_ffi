// The two macOS delivery surfaces, and why both ship.
//
// An app *links* the static archive through the Swift package's
// `binaryTarget` and reaches the symbols with `DynamicLibrary.process()`.
// A host that loads by path — a Flutter widget test, a CLI, any locator
// chain — cannot use an xcframework at all, so the adapter also ships one
// cdylib per slice under `native/macos-<rid>/`.
//
// These paths are not internal: consumers probe them by name. A host that
// resolves the library by path looks for
// `html_to_markdown_ffi_macos/native/macos-<arch>/libhtml_to_markdown_ffi.dylib`
// (see zuraffa_browser's `NativeLibraryLocator`), so a missing slice is a
// fresh machine that cannot convert, not a cosmetic gap. The 1.3.0
// "retire the raw dylibs" change (issue #6) removed them and broke exactly
// that: the xcframework is app-only, and a `flutter clean` on a new host
// left every probe empty.
//
// Shipping the dylib is not the duplicate-engine problem issue #6 warned
// about. That was a *manual embed + codesign build phase* copying a dylib
// into `Contents/Frameworks` next to the SPM-embedded framework. Nothing
// here embeds anything: the file is only ever dlopen'd by path.
import 'dart:io';

import 'package:test/test.dart';

void main() {
  final packageRoot = Directory.current.path;

  test('the macOS adapter ships one loadable dylib per slice', () {
    for (final rid in ['macos-arm64', 'macos-x64']) {
      final dylib = File(
        '$packageRoot/native/$rid/libhtml_to_markdown_ffi.dylib',
      );
      expect(
        dylib.existsSync(),
        isTrue,
        reason:
            '$dylib is the path a host that loads the library by path '
            'probes; without it a fresh machine has no way to convert '
            '(the xcframework is linkable by Xcode only).',
      );
      expect(
        dylib.lengthSync(),
        greaterThan(1024 * 1024),
        reason:
            '$dylib is too small to be the engine — a truncated or '
            'LFS-stubbed file dlopens as an invalid image.',
      );
    }
  });

  test('the dylibs are ad-hoc signed, so arm64 can dlopen them', () {
    // macOS refuses to load an arm64 image that carries no signature at all.
    // `scripts/build_native.sh` re-signs after copying; a hand-copied
    // artifact from `target/` silently loses this.
    final dylib = File(
      '$packageRoot/native/macos-arm64/libhtml_to_markdown_ffi.dylib',
    );
    final result = Process.runSync('codesign', ['-dv', dylib.path]);
    expect(
      result.stderr.toString(),
      isNot(contains('not signed at all')),
      reason:
          '${dylib.path} must carry a signature — arm64 code without one '
          'fails to load.',
    );
  });

  test('the xcframework slice the SPM binaryTarget links stays', () {
    final slice = File(
      '$packageRoot/macos/html_to_markdown_ffi_macos/'
      'Frameworks/libhtml_to_markdown_ffi.xcframework/'
      'macos-arm64_x86_64/libhtml_to_markdown_ffi.a',
    );
    expect(
      slice.existsSync(),
      isTrue,
      reason:
          '$slice is the build input Package.swift\'s binaryTarget '
          'resolves — it must stay.',
    );
  });

  test('no loose static archive is left under native/', () {
    final nativeDir = Directory('$packageRoot/native');
    if (!nativeDir.existsSync()) return;
    final leftovers = nativeDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.a'))
        .toList();
    expect(
      leftovers,
      isEmpty,
      reason:
          'The static archives are xcframework build inputs, not '
          'delivery artifacts: they belong under '
          'macos/html_to_markdown_ffi_macos/Frameworks/ (built by '
          'scripts/build_native.sh), never loose under native/.',
    );
  });
}
