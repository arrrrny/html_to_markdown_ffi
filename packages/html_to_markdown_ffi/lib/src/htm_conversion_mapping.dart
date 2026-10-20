// Boundary mapping between the preserved public API types (FR-006 —
// frozen compatibility surface) and the internal zfa-generated
// [HtmConversion] entity (spec 064 research D4). Explicit and unit-tested;
// keeps the public contract decoupled from the internal model.
import 'dart:convert' as dart_convert;

import 'package:html_to_markdown_ffi_platform/html_to_markdown_ffi_platform.dart'
    show ConversionOptions, ConversionResult;

import 'domain/entities/htm_conversion/htm_conversion.dart';

/// The wire-format helpers are shared with the federated adapters, so they
/// live in the platform package; this library keeps the import path.
export 'package:html_to_markdown_ffi_platform/html_to_markdown_ffi_platform.dart'
    show conversionResultFromJson, optionsJsonOf;

/// Builds the internal request entity for one conversion call.
HtmConversion buildConversionRequest(
  String html, {
  required String id,
  ConversionOptions? options,
}) {
  final opts = options ?? ConversionOptions();
  return HtmConversion(
    id: id,
    html: html,
    optionsJson: dart_convert.jsonEncode(opts.toJson()),
    resultJson: '',
  );
}

/// Decodes the bridge's result json (stored on the entity by the
/// datasource) back into the preserved public [ConversionResult].
ConversionResult toConversionResult(HtmConversion done) {
  final decoded = dart_convert.jsonDecode(done.resultJson);
  return ConversionResult.fromJson(decoded as Map<String, dynamic>);
}
