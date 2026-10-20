/// The channel envelope of the `html_to_markdown_ffi` family is the shared
/// `zuraffa_ffi_platform` envelope — one implementation, one source of
/// truth for the whole Zuraffa FFI family.
library;

import 'package:zuraffa_ffi_platform/zuraffa_ffi_platform.dart';

/// The html family's envelope: an alias of the shared
/// [PlatformFfiEnvelope].
///
/// The family used to carry a byte-identical copy of the shared envelope
/// under its own name. Keeping the name as an alias means every adapter,
/// every test and every consumer keeps compiling against
/// `PlatformHtmlToMarkdownFfiEnvelope` while the behavior itself lives in
/// exactly one place — `zuraffa_ffi_platform`.
typedef PlatformHtmlToMarkdownFfiEnvelope = PlatformFfiEnvelope;
