/// The typed failure surfaced by the html_to_markdown_ffi port and service.
class HtmlToMarkdownFfiException implements Exception {
  final String code;
  final String message;
  final bool recoverable;

  const HtmlToMarkdownFfiException(
    this.code,
    this.message, {
    required this.recoverable,
  });

  @override
  String toString() =>
      'HtmlToMarkdownFfiException($code, recoverable: $recoverable): $message';
}
