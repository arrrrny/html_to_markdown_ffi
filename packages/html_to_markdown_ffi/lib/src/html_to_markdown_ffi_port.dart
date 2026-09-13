import 'dart:typed_data';

import 'html_to_markdown_ffi_module.dart';
import 'html_to_markdown_ffi_value.dart';

/// The platform-neutral port every adapter implements. Pure Dart — the
/// transport is injected behind the platform envelope, so tests run
/// offline with fake channels.
abstract class HtmlToMarkdownFfiPort {
  const HtmlToMarkdownFfiPort();

  /// Whether the host platform can run WebAssembly at all.
  Future<bool> isSupported();

  /// Compiles [bytes] and binds the result to [id].
  Future<HtmlToMarkdownFfiModule> compile({
    required String id,
    required Uint8List bytes,
  });

  /// Invokes [export] on the compiled module [id].
  Future<List<HtmlToMarkdownFfiValue>> invoke({
    required String id,
    required String export,
    List<HtmlToMarkdownFfiValue> args = const [],
  });

  /// Releases the compiled module [id].
  Future<void> unload({required String id});
}
