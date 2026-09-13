import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';
import 'package:html_to_markdown_ffi/native_library.dart' show NativeLibrary;
import 'package:html_to_markdown_ffi_platform/html_to_markdown_ffi_platform.dart';

import 'android_html_to_markdown_ffi_exception.dart';

/// The android channel: the shared [PlatformHtmlToMarkdownFfiEnvelope]
/// machinery with the android taxonomy as a pure data set. The default
/// [MacosHtmlToMarkdownFfiChannel.native] invoke performs the real FFI
/// conversion through the app package's native datasource; any other
/// transport can be injected verbatim.
class AndroidHtmlToMarkdownFfiChannel {
  /// Native codes that map recoverable; everything else (including
  /// unknown codes) is non-recoverable, preserved verbatim.
  static const Set<String> recoverableCodes = {
    'not_supported',
    'timeout',
  };

  final ChannelInvoke invoke;
  final Duration timeout;

  const AndroidHtmlToMarkdownFfiChannel({
    required this.invoke,
    this.timeout = const Duration(seconds: 30),
  });

  /// Self-wiring channel: performs the real dart:ffi conversion through
  /// the app package's [NativeHtmConversionDataSource] (which consults
  /// the resolver seam for this adapter's bundled binaries). Android resolves `libhtml_to_markdown_ffi.so` from the jniLibs loader path (DynamicLibrary.open) — logic preserved from the pre-migration loader.
  static AndroidHtmlToMarkdownFfiChannel native({Duration? timeout}) {
    final dataSource = NativeHtmConversionDataSource();
    return AndroidHtmlToMarkdownFfiChannel(
      invoke: (method, args) async {
        switch (method) {
          case 'isSupported':
            try {
              NativeLibrary();
              return {'supported': true};
            } on StateError {
              return {'supported': false};
            } on ArgumentError {
              return {'supported': false};
            }
          case 'convert':
            final html = args['html'] as String?;
            if (html == null) {
              throw AndroidHtmlToMarkdownFfiException(
                'malformed_response',
                'The convert payload carried no html.',
                recoverable: false,
              );
            }
            final done = dataSource.convertNow(
              HtmConversion(
                id: (args['id'] as String?) ?? 'native',
                html: html,
                optionsJson:
                    (args['optionsJson'] as String?) ?? '{}',
                resultJson: '',
              ),
            );
            return {'resultJson': done.resultJson};
          default:
            throw AndroidHtmlToMarkdownFfiException(
              'unknown_method',
              'The android channel does not implement "$method".',
              recoverable: false,
            );
        }
      },
      timeout: timeout ?? const Duration(seconds: 30),
    );
  }

  Future<Map<String, Object?>?> call(
    String method,
    Map<String, Object?> args,
  ) =>
      PlatformHtmlToMarkdownFfiEnvelope(
        invoke: invoke,
        timeout: timeout,
        onTyped: AndroidHtmlToMarkdownFfiException.new,
        mapNativeError: _mapNativeError,
        isTypedError: (error) => error is AndroidHtmlToMarkdownFfiException,
      ).call(method, args);

  static Exception _mapNativeError(String code, String message) =>
      AndroidHtmlToMarkdownFfiException(
        code,
        message,
        recoverable: recoverableCodes.contains(code),
      );
}
