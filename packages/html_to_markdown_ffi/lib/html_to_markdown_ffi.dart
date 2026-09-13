/// html_to_markdown_ffi — HtmlToMarkdownFfi support for the Zuraffa ecosystem.
///
/// A pure-Dart port (`HtmlToMarkdownFfiPort`), a facade (`HtmlToMarkdownFfiService`),
/// typed failures, and DI registration. Platform adapters implement the
/// port over an injected platform channel — the shared envelope machinery
/// lives in `html_to_markdown_ffi_platform`.
library;

export 'src/html_to_markdown_ffi_exception.dart';
export 'src/html_to_markdown_ffi_module.dart';
export 'src/html_to_markdown_ffi_port.dart';
export 'src/html_to_markdown_ffi_service.dart';
export 'src/html_to_markdown_ffi_value.dart';
