/// Shared envelope core for the `html_to_markdown_ffi` platform adapters:
/// the transport seam ([PlatformHtmlToMarkdownFfiEnvelope]), and the
/// native-library resolver seam ([HtmNativeLibraries]) adapters use to
/// contribute their bundled binaries to the preserved loading chain.
library;

export 'package:html_to_markdown_ffi/native_library.dart'
    show HtmNativeLibraries, HtmNativeLibraryResolver;
export 'src/platform_html_to_markdown_ffi_envelope.dart';
