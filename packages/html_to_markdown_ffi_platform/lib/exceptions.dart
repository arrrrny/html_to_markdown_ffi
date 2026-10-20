import 'package:ffi/ffi.dart';

import 'native_library.dart';

class HtmlToMarkdownException implements Exception {
  final String message;
  final int? errorCode;

  const HtmlToMarkdownException(this.message, {this.errorCode});

  @override
  String toString() =>
      'HtmlToMarkdownException(${errorCode ?? '?'}): $message';
}

class InvalidInputException extends HtmlToMarkdownException {
  const InvalidInputException(super.message, {super.errorCode});
}

class ConversionErrorException extends HtmlToMarkdownException {
  const ConversionErrorException(super.message, {super.errorCode});
}

void checkLastError() {
  final lib = NativeLibrary();
  final code = lib.htmLastErrorCode();
  if (code != 0) {
    final contextPtr = lib.htmLastErrorContext();
    final message = contextPtr.toDartString();
    switch (code) {
      case 1:
        throw InvalidInputException(message, errorCode: code);
      case 2:
        throw ConversionErrorException(message, errorCode: code);
      default:
        throw HtmlToMarkdownException(message, errorCode: code);
    }
  }
}
