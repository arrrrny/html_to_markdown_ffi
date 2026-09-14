/// html_to_markdown_ffi — typed HTML to Markdown conversion for the
/// Zuraffa ecosystem (spec 064 migration of the standalone FFI package).
///
/// The zuraffa stack: a pure-Dart port ([HtmlToMarkdownFfiPort]), a facade
/// ([HtmlToMarkdownFfiService]), typed failures, and DI registration.
/// Platform adapters implement the port over an injected transport — the
/// shared envelope machinery lives in `html_to_markdown_ffi_platform`.
/// The preserved pre-migration public API remains import-compatible via
/// `package:html_to_markdown_ffi/html_to_markdown.dart`.
library;

export 'src/data/datasources/htm_conversion/native_htm_conversion_datasource.dart';
export 'src/html_to_markdown_ffi_exception.dart';
export 'src/html_to_markdown_ffi_port.dart';
export 'src/html_to_markdown_ffi_service.dart';
export 'src/htm_conversion_mapping.dart';
export 'src/domain/entities/htm_conversion/htm_conversion.dart';
export 'visitor.dart';
export 'models/conversion_options.dart';
export 'models/conversion_result.dart';
export 'models/enums.dart';
export 'src/domain/repositories/htm_conversion_repository.dart';
export 'src/domain/usecases/htm_conversion/get_htm_conversion_usecase.dart';
