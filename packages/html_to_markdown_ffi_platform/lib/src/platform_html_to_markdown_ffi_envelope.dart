import 'dart:async';

/// The injected transport seam (moved from the adapters): the consuming
/// app (or native shell) supplies the actual channel call.
typedef ChannelInvoke = FutureOr<Object?> Function(
  String method,
  Map<String, Object?> args,
);

/// Builds the calling adapter's own typed exception — the core never
/// invents an exception type of its own.
typedef PlatformExceptionFactory = Exception Function(
  String code,
  String message, {
  required bool recoverable,
});

/// The adapter's taxonomy hook: map a native code to the typed failure, or
/// return null to fall through to the core default.
typedef PlatformErrorMapper = Exception? Function(String code, String message);

/// Recognizes the calling adapter's typed exceptions so a typed failure
/// thrown inside [ChannelInvoke] passes through
/// [PlatformHtmlToMarkdownFfiEnvelope.call] without double wrapping.
typedef TypedErrorPredicate = bool Function(Object error);

/// Sentinel for the envelope's own timeout: thrown by the `onTimeout`
/// callback and converted to the adapter's typed `timeout` failure — never
/// observable outside [call].
class _EnvelopeTimeout implements Exception {
  const _EnvelopeTimeout();
}

/// The shared channel envelope: every adapter platform call goes through
/// [call] — success payloads decode to the returned map, native error
/// payloads and thrown transport failures surface as typed exceptions
/// (built by the calling adapter's own factory), and a call past [timeout]
/// surfaces as a recoverable `timeout`.
class PlatformHtmlToMarkdownFfiEnvelope {
  final ChannelInvoke invoke;
  final Duration timeout;
  final PlatformExceptionFactory onTyped;
  final PlatformErrorMapper? mapNativeError;
  final TypedErrorPredicate? isTypedError;

  const PlatformHtmlToMarkdownFfiEnvelope({
    required this.invoke,
    required this.onTyped,
    this.mapNativeError,
    this.isTypedError,
    this.timeout = const Duration(seconds: 30),
  });

  Future<Map<String, Object?>?> call(
    String method,
    Map<String, Object?> args,
  ) async {
    Object? raw;
    try {
      raw = await Future.sync(() => invoke(method, args)).timeout(
        timeout,
        onTimeout: () => throw const _EnvelopeTimeout(),
      );
    } on _EnvelopeTimeout {
      throw onTyped(
        'timeout',
        'The platform call exceeded the timeout window.',
        recoverable: true,
      );
    } catch (e) {
      if (isTypedError != null && isTypedError!(e)) rethrow;
      throw onTyped(
        'channel_error',
        'The platform call "$method" failed: $e',
        recoverable: false,
      );
    }
    if (raw == null) return null;
    if (raw is! Map) {
      throw onTyped(
        'malformed_response',
        'The platform call "$method" returned a non-map payload: $raw',
        recoverable: false,
      );
    }
    final result = Map<String, Object?>.from(raw);
    final error = result['error'];
    if (error is Map) {
      throw _typedError(Map<String, Object?>.from(error));
    }
    return result;
  }

  /// Evaluates the adapter's taxonomy hook, falling back to the adapter's
  /// own typed factory for unmapped codes.
  Exception _typedError(Map<String, Object?> error) {
    final code = (error['code'] as String?) ?? 'unknown';
    final message = (error['message'] as String?) ?? '';
    final mapped = mapNativeError?.call(code, message);
    if (mapped != null) return mapped;
    return onTyped(code, message, recoverable: false);
  }
}
