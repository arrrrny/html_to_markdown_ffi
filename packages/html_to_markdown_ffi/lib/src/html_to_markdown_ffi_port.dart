// html_to_markdown_ffi port — the platform-neutral contract every adapter
// implements (spec 064; scaffold shape customized to conversion semantics).
// Pure Dart: the transport is injected behind the platform envelope, so
// tests run offline with fake channels. [convert] is the canonical async
// path (envelope-wrapped, transport-agnostic); [convertSync] is the
// in-process fast path adapters with an in-process native library
// implement — foreign transports surface the typed `sync_unsupported`
// failure instead.
import '../models/conversion_options.dart';
import '../models/conversion_result.dart';
import '../visitor.dart';

abstract class HtmlToMarkdownFfiPort {
  const HtmlToMarkdownFfiPort();

  /// Whether the host platform can run the native converter at all.
  Future<bool> isSupported();

  /// Converts [html] to Markdown. [id] identifies the call in adapters
  /// that track invocations.
  Future<ConversionResult> convert({
    required String id,
    required String html,
    ConversionOptions? options,
    Visitor? visitor,
  });

  /// Synchronous in-process conversion (dart:ffi is synchronous). The
  /// preserved public `convert()` routes through here.
  ConversionResult convertSync({
    required String id,
    required String html,
    ConversionOptions? options,
    Visitor? visitor,
  });
}
