/// The typed native failure on iOS.
class IosHtmlToMarkdownFfiException implements Exception {
  final String code;
  final String message;
  final bool recoverable;

  const IosHtmlToMarkdownFfiException(
    this.code,
    this.message, {
    required this.recoverable,
  });

  @override
  String toString() =>
      'IosHtmlToMarkdownFfiException($code, recoverable: $recoverable): $message';
}
