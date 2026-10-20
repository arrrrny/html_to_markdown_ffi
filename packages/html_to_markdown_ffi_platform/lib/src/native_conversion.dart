// The in-process dart:ffi conversion the adapters and the app-facing package
// share: options json -> handle -> htm_convert -> result json. It lives in the
// platform package so a federated adapter can run a conversion without
// depending on the app-facing package (which depends on the adapters).
import 'dart:convert' as dart_convert;
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../exceptions.dart';
import '../models/conversion_options.dart';
import '../models/conversion_result.dart';
import '../native_library.dart';
import '../visitor.dart';
import '../visitor_bridge.dart';

/// Runs one synchronous in-process conversion and returns the bridge's result
/// json.
///
/// Throws the preserved public exceptions ([InvalidInputException],
/// [ConversionErrorException]) through [checkLastError]. [visitor] travels out
/// of band (it is a callback, not JSON).
String convertWithNativeLibrary(
  String html, {
  required String optionsJson,
  Visitor? visitor,
  NativeLibrary? library,
}) {
  final lib = library ?? NativeLibrary();
  final arena = Arena();
  VisitorBridge? bridge;
  try {
    final htmlPtr = html.toNativeUtf8(allocator: arena);
    final optionsPtr = _createOptions(lib, optionsJson, arena);

    bridge = visitor == null ? null : VisitorBridge(visitor);
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

    lib.htmConversionResultFree(resultPtr);
    return json;
  } finally {
    bridge?.close();
    arena.releaseAll();
  }
}

dynamic _createOptions(
  NativeLibrary lib,
  String optionsJson,
  Arena arena,
) {
  final jsonPtr = optionsJson.toNativeUtf8(allocator: arena);
  final handle = lib.htmConversionOptionsFromJson(jsonPtr);
  if (handle == nullptr) {
    checkLastError();
    throw const ConversionErrorException('Failed to create conversion options');
  }
  return handle;
}

/// Wire-format helper: the options json payload for a convert call.
String optionsJsonOf(ConversionOptions? options) =>
    dart_convert.jsonEncode((options ?? ConversionOptions()).toJson());

/// Wire-format helper: rebuilds the preserved public result from the
/// bridge's result json payload.
ConversionResult conversionResultFromJson(String resultJson) =>
    ConversionResult.fromJson(
        dart_convert.jsonDecode(resultJson) as Map<String, dynamic>);
