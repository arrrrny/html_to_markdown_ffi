import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'package:html_to_markdown_ffi/native_library.dart';

/// Simple FFI debug tool for inspecting the native library symbol table.
void main(List<String> args) {
  final lib = NativeLibrary();

  print('Native library loaded ✓');
  print('Last error code: ${lib.htmLastErrorCode()}');

  // Test conversion
  final arena = Arena();
  final html = '<h1>Hello from Dart FFI</h1><p>This is a test.</p>';
  final htmlPtr = html.toNativeUtf8(allocator: arena);
  final optionsJson = '{"extract_metadata":true}';
  final optJsonPtr = optionsJson.toNativeUtf8(allocator: arena);
  final opts = lib.htmConversionOptionsFromJson(optJsonPtr);
  final result = lib.htmConvert(htmlPtr, opts);

  if (result == nullptr) {
    throw Exception('Conversion failed');
  }

  final jsonPtr = lib.htmConversionResultToJson(result);
  print('Result JSON:');
  print(jsonPtr.toDartString());

  lib.htmFreeString(jsonPtr);
  lib.htmConversionResultFree(result);
  arena.releaseAll();
}
