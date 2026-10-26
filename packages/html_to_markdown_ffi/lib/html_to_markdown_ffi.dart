/// html_to_markdown_ffi — typed HTML to Markdown conversion for the
/// Zuraffa ecosystem (spec 064 migration of the standalone FFI package).
///
/// The zuraffa stack: a pure-Dart port ([HtmlToMarkdownFfiPort]), a facade
/// ([HtmlToMarkdownFfiService]), typed failures, and DI registration.
/// Platform adapters implement the port over an injected transport — the
/// shared envelope machinery and the native conversion seam live in
/// `html_to_markdown_ffi_platform`.
/// The preserved pre-migration public API remains import-compatible via
/// `package:html_to_markdown_ffi/html_to_markdown.dart`.
///
/// This package asks for no Flutter SDK, so it resolves for a consumer that
/// is not a Flutter app. The three platform adapters are not reachable from
/// here — each of them asks for the Flutter SDK, and a dependency on one
/// would make this package ask for it too. A Flutter app depends on
/// `html_to_markdown_ffi_flutter`, which names the adapters and re-exports
/// this package's API under one name.
library;

export 'src/data/datasources/htm_conversion/native_htm_conversion_datasource.dart';
export 'src/html_to_markdown_ffi_service.dart';
export 'src/htm_conversion_mapping.dart';
export 'src/domain/entities/htm_conversion/htm_conversion.dart';
export 'src/domain/repositories/htm_conversion_repository.dart';
export 'src/domain/usecases/htm_conversion/get_htm_conversion_usecase.dart';
export 'package:html_to_markdown_ffi_platform/html_to_markdown_ffi_platform.dart'
    show
        ConversionOptions,
        ConversionResult,
        HtmNativeLibraries,
        HtmNativeLibraryResolver,
        HtmlMetadata,
        HtmlToMarkdownFfiException,
        HtmlToMarkdownFfiPort,
        ImageMetadata,
        LinkMetadata,
        NativeLibrary,
        NodeContext,
        PreprocessingOptions,
        ProcessingWarning,
        Visitor,
        CodeBlockStyle,
        HeadingStyle,
        HighlightStyle,
        LinkStyle,
        ListIndentType,
        NewlineStyle,
        NodeType,
        OutputFormat,
        PreprocessingPreset,
        VisitResult,
        WarningKind,
        WhitespaceMode;
