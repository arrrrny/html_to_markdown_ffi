// The pure-Dart conversion entry point.
//
// This package is the family's Flutter-free entry point: it declares no
// `flutter: plugin:` manifest and asks for no Flutter SDK, so a consumer
// that is not a Flutter app — a CLI, a server, a background worker — can
// depend on it alone and still convert HTML to Markdown.
//
// The conversion runs over the same in-process dart:ffi bridge the federated
// adapters and the app-facing package use, so the result is the same
// conversion; only the wiring differs. The app-facing package's own
// [convert] additionally prefers a registered platform adapter over the
// direct bridge, which a pure-Dart consumer has no way to register.
import 'dart:async';

import '../exceptions.dart';
import '../models/conversion_options.dart';
import '../models/conversion_result.dart';
import '../native_library.dart';
import '../visitor.dart';
import 'src/native_conversion.dart';

/// Converts [html] to Markdown over the in-process native bridge.
///
/// The synchronous call is the preserved public shape: the bridge is
/// synchronous, so the result is available without an await. The typed
/// failures (`InvalidInputException`, `ConversionErrorException`) surface
/// through `checkLastError`.
///
/// [visitor] travels out of band — it is a callback, not JSON.
ConversionResult convert(
  String html, {
  ConversionOptions? options,
  Visitor? visitor,
}) {
  final resultJson = convertWithNativeLibrary(
    html,
    optionsJson: optionsJsonOf(options),
    visitor: visitor,
  );
  return conversionResultFromJson(resultJson);
}

/// Converts [html] to Markdown over the in-process native bridge, surfaced
/// asynchronously.
///
/// The bridge is synchronous, so this is the same conversion as [convert]
/// behind a future — it exists for callers that are already async.
Future<ConversionResult> convertAsync(
  String html, {
  ConversionOptions? options,
  Visitor? visitor,
}) {
  return Future<ConversionResult>.sync(
    () => convert(html, options: options, visitor: visitor),
  );
}

/// Whether the native bridge is loadable on this host right now.
///
/// A host without the native library for its platform reports false rather
/// than throwing, so a consumer can check before it converts.
bool get nativeConverterAvailable {
  try {
    NativeLibrary();
    return true;
  } on StateError {
    return false;
  } on ArgumentError {
    return false;
  }
}

/// Surfaces the preserved typed failure helper for callers that drive the
/// bridge directly.
const ConversionErrorException Function(String message, {int? errorCode})
    conversionError = ConversionErrorException.new;
