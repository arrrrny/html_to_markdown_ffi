/// High-performance HTML to Markdown converter for Dart and Flutter.
///
/// Powered by the Rust html-to-markdown library via FFI bindings.
///
/// The value types, the visitor contract, and the exception surface live in
/// `html_to_markdown_ffi_platform` (the layer the federated adapters also
/// depend on); this library keeps the consumer-facing import path and names.
library html_to_markdown;

// Public API
export 'convert.dart';
export 'package:html_to_markdown_ffi_platform/html_to_markdown_ffi_platform.dart'
    show
        checkLastError,
        ConversionErrorException,
        ConversionOptions,
        ConversionResult,
        HtmNativeLibraries,
        HtmNativeLibraryResolver,
        HtmlMetadata,
        HtmlToMarkdownException,
        ImageMetadata,
        InvalidInputException,
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
