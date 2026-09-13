/// The typed native failure on macOS.
class MacosHtmlToMarkdownFfiException implements Exception {
  final String code;
  final String message;
  final bool recoverable;

  const MacosHtmlToMarkdownFfiException(
    this.code,
    this.message, {
    required this.recoverable,
  });

  @override
  String toString() =>
      'MacosHtmlToMarkdownFfiException($code, recoverable: $recoverable): $message';
}
