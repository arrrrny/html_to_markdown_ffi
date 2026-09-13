import 'package:html_to_markdown_ffi_platform/html_to_markdown_ffi_platform.dart';

import 'ios_html_to_markdown_ffi_exception.dart';

/// The iOS channel: the shared
/// [PlatformHtmlToMarkdownFfiEnvelope] machinery with the iOS
/// taxonomy as a pure data set.
class IosHtmlToMarkdownFfiChannel {
  /// Native codes that map recoverable; everything else (including
  /// unknown codes) is non-recoverable, preserved verbatim.
  static const Set<String> recoverableCodes = {
    'user_cancelled',
    'api_unavailable',
    'not_supported',
    'timeout',
  };

  final ChannelInvoke invoke;
  final Duration timeout;

  const IosHtmlToMarkdownFfiChannel({
    required this.invoke,
    this.timeout = const Duration(seconds: 30),
  });

  Future<Map<String, Object?>?> call(
    String method,
    Map<String, Object?> args,
  ) =>
      PlatformHtmlToMarkdownFfiEnvelope(
        invoke: invoke,
        timeout: timeout,
        onTyped: IosHtmlToMarkdownFfiException.new,
        mapNativeError: _mapNativeError,
        isTypedError: (error) => error is IosHtmlToMarkdownFfiException,
      ).call(method, args);

  static Exception _mapNativeError(String code, String message) =>
      IosHtmlToMarkdownFfiException(
        code,
        message,
        recoverable: recoverableCodes.contains(code),
      );
}
