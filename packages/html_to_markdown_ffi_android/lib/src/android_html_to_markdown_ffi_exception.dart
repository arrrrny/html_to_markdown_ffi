/// The typed native failure on Android.
class AndroidHtmlToMarkdownFfiException implements Exception {
  final String code;
  final String message;
  final bool recoverable;

  const AndroidHtmlToMarkdownFfiException(
    this.code,
    this.message, {
    required this.recoverable,
  });

  @override
  String toString() =>
      'AndroidHtmlToMarkdownFfiException($code, recoverable: $recoverable): $message';
}
