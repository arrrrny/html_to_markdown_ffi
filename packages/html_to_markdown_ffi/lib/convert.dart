// Preserved public API (FR-006): the top-level synchronous conversion.
// Since the zuraffa migration (spec 064) the call delegates to the default
// [HtmlToMarkdownFfiService] — adapter port when one is registered, the
// in-package datasource wrapping the preserved dart:ffi bridge otherwise
// (FR-004). Behavior, signature, and exception surface are unchanged.
import 'exceptions.dart';
import 'models/conversion_options.dart';
import 'models/conversion_result.dart';
import 'src/html_to_markdown_ffi_service.dart';
import 'visitor.dart';

/// The service instance backing the top-level [convert] function: the
/// datasource path (in-process native bridge). Federated consumers that
/// register an adapter port get the adapter path transparently — see
/// [HtmlToMarkdownFfiService].
final HtmlToMarkdownFfiService htmlToMarkdownFfi =
    HtmlToMarkdownFfiService.native();

ConversionResult convert(
  String html, {
  ConversionOptions? options,
  Visitor? visitor,
}) {
  return htmlToMarkdownFfi.convert(html, options: options, visitor: visitor);
}

/// Conversion through the stack without an adapter, surfaced asynchronously.
Future<ConversionResult> convertAsync(
  String html, {
  ConversionOptions? options,
  Visitor? visitor,
}) {
  return htmlToMarkdownFfi.convertAsync(html,
      options: options, visitor: visitor);
}

/// Whether the native bridge is loadable on this host right now.
bool get nativeConverterAvailable => htmlToMarkdownFfi.supportedSync;

/// Surfaces the preserved typed failure helper for callers that drive the
/// bridge directly; re-exported here for import-path compatibility.
const ConversionErrorException Function(String message, {int? errorCode})
    conversionError = ConversionErrorException.new;
