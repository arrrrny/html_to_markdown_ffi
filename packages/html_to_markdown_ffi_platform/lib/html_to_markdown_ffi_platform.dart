/// Shared envelope core for the `html_to_markdown_ffi` platform adapters:
/// the transport seam ([PlatformHtmlToMarkdownFfiEnvelope], an alias of the
/// shared `zuraffa_ffi_platform` envelope), the pure-Dart port contract the
/// adapters implement, and the native-library / conversion seam adapters use
/// to contribute their bundled binaries to the preserved loading chain.
///
/// This package asks for no Flutter SDK and declares no plugin manifest, so
/// it is the family's entry point for a consumer that is not a Flutter app:
/// [convert] converts HTML to Markdown over the in-process native bridge
/// with nothing else to wire.
library;

export 'convert.dart';
export 'exceptions.dart';
export 'models/conversion_options.dart';
export 'models/conversion_result.dart';
export 'models/enums.dart';
export 'native_library.dart';
export 'src/html_to_markdown_ffi_exception.dart';
export 'src/html_to_markdown_ffi_port.dart';
export 'src/native_conversion.dart'
    show conversionResultFromJson, convertWithNativeLibrary, optionsJsonOf;
export 'src/platform_html_to_markdown_ffi_envelope.dart';
export 'visitor.dart';
export 'package:zuraffa_ffi_platform/zuraffa_ffi_platform.dart'
    show
        ChannelInvoke,
        PlatformErrorMapper,
        PlatformExceptionFactory,
        PlatformFfiEnvelope,
        TypedErrorPredicate;
