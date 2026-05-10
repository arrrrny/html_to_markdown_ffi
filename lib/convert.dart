import 'dart:convert' as dart_convert;
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'exceptions.dart';
import 'html_to_markdown_bindings.dart';
import 'models/conversion_options.dart';
import 'models/conversion_result.dart';
import 'native_library.dart';
import 'visitor.dart';
import 'visitor_bridge.dart';

ConversionResult convert(
  String html, {
  ConversionOptions? options,
  Visitor? visitor,
}) {
  final lib = NativeLibrary();
  final arena = Arena();
  final bridge = visitor != null ? VisitorBridge(visitor) : null;

  try {
    final htmlPtr = html.toNativeUtf8(allocator: arena);
    final optionsPtr = _createOptions(lib, options, arena);

    // Attach visitor bridge if provided
    if (bridge != null) {
      bridge.attach(optionsPtr);
    }

    final resultPtr = lib.htmConvert(htmlPtr, optionsPtr);

    if (resultPtr == nullptr) {
      checkLastError();
      throw const ConversionErrorException('Conversion returned null result');
    }

    final jsonPtr = lib.htmConversionResultToJson(resultPtr);
    final json = jsonPtr.toDartString();
    lib.htmFreeString(jsonPtr);

    final map = dart_convert.jsonDecode(json);
    final result = ConversionResult.fromJson(map as Map<String, dynamic>);

    lib.htmConversionResultFree(resultPtr);
    return result;
  } finally {
    bridge?.close();
    arena.releaseAll();
  }
}

Pointer<HTMConversionOptions> _createOptions(
  NativeLibrary lib,
  ConversionOptions? options,
  Arena arena,
) {
  final opts = options ?? ConversionOptions();
  final json = dart_convert.jsonEncode(opts.toJson());
  final jsonPtr = json.toNativeUtf8(allocator: arena);
  final handle = lib.htmConversionOptionsFromJson(jsonPtr);

  if (handle == nullptr) {
    checkLastError();
    throw const ConversionErrorException('Failed to create conversion options');
  }

  return handle;
}
