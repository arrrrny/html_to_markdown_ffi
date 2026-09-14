// Boundary mapping between the preserved public API types (FR-006 —
// frozen compatibility surface) and the internal zfa-generated
// [HtmConversion] entity (spec 064 research D4). Explicit and unit-tested;
// keeps the public contract decoupled from the internal model.
import 'dart:convert' as dart_convert;

import '../models/conversion_options.dart';
import '../models/conversion_result.dart';
import 'domain/entities/htm_conversion/htm_conversion.dart';

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

/// Wire-format helper: the options json payload for a convert call.
String optionsJsonOf(ConversionOptions? options) =>
    dart_convert.jsonEncode((options ?? ConversionOptions()).toJson());

/// Wire-format helper: rebuilds the preserved public result from the
/// bridge's result json payload.
ConversionResult conversionResultFromJson(String resultJson) =>
    ConversionResult.fromJson(
        dart_convert.jsonDecode(resultJson) as Map<String, dynamic>);

/// Decodes the bridge's result json (stored on the entity by the
/// datasource) back into the preserved public [ConversionResult].
ConversionResult toConversionResult(HtmConversion done) {
  final decoded = dart_convert.jsonDecode(done.resultJson);
  return ConversionResult.fromJson(decoded as Map<String, dynamic>);
}
