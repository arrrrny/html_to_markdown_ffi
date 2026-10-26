// Compatibility gate for the pre-migration loader seam (arrrrny/zuraffa#2020).
//
// html_to_markdown_ffi 1.2.2–1.2.7 restructured the package without a major
// version: `lib/native_library.dart` and its `HtmNativeLibraries` seam moved
// to `html_to_markdown_ffi_platform`, the old URI disappeared, and neither
// curated barrel re-exported the seam — so a plain `pub upgrade` inside
// `^1.2.0` broke consumers at analyze time. These tests pin the restored
// surface: the original import path resolves again and both barrels carry
// the seam.
import 'dart:io';

import 'package:html_to_markdown_ffi/html_to_markdown.dart' as barrel_md;
import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart' as barrel_ffi;
import 'package:html_to_markdown_ffi/native_library.dart';
import 'package:test/test.dart';

String? _neverResolve() => null;

void main() {
  group('pre-migration native_library.dart import path', () {
    test('resolver seam registers and resolves through the old import', () {
      final stubDir = Directory.systemTemp.createTempSync('issue-2020-');
      addTearDown(() => stubDir.delete(recursive: true));
      final stub = File('${stubDir.path}/libstub.dylib')
        ..writeAsStringSync('stub');

      final remove = HtmNativeLibraries.registerResolver(() => stub.path);
      addTearDown(remove);

      expect(HtmNativeLibraries.resolve(), stub.path);
      remove();
      expect(HtmNativeLibraries.resolve(), isNull);
    });

    test('the resolver typedef rides the same import', () {
      final HtmNativeLibraryResolver resolver = _neverResolve;
      expect(resolver(), isNull);
    });
  });

  group('curated barrels re-export the seam', () {
    test('html_to_markdown.dart carries HtmNativeLibraries', () {
      final remove = barrel_md.HtmNativeLibraries.registerResolver(() => null);
      remove();
      final barrel_md.HtmNativeLibraryResolver viaTypedef = _neverResolve;
      expect(viaTypedef(), isNull);
    });

    test('html_to_markdown_ffi.dart carries HtmNativeLibraries', () {
      final remove = barrel_ffi.HtmNativeLibraries.registerResolver(() => null);
      remove();
      final barrel_ffi.HtmNativeLibraryResolver viaTypedef = _neverResolve;
      expect(viaTypedef(), isNull);
    });
  });
}
