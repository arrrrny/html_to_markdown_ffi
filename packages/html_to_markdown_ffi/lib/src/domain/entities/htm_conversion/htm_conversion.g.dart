// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'htm_conversion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HtmConversion _$HtmConversionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HtmConversion', json, ($checkedConvert) {
      final val = HtmConversion(
        html: $checkedConvert('html', (v) => v as String),
        optionsJson: $checkedConvert('optionsJson', (v) => v as String),
        resultJson: $checkedConvert('resultJson', (v) => v as String),
        id: $checkedConvert('id', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$HtmConversionToJson(HtmConversion instance) =>
    <String, dynamic>{
      'html': instance.html,
      'optionsJson': instance.optionsJson,
      'resultJson': instance.resultJson,
      'id': instance.id,
    };
