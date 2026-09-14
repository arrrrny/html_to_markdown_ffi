// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'htm_conversion.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class HtmConversion {
  HtmConversion({
    required String this.html,
    required String this.optionsJson,
    required String this.resultJson,
    required String this.id,
  });

  factory HtmConversion.fromJson(Map<String, dynamic> json) =>
      _$HtmConversionFromJson(json);

  final String html;

  final String optionsJson;

  final String resultJson;

  final String id;

  HtmConversion copyWith({
    String? html,
    String? optionsJson,
    String? resultJson,
    String? id,
  }) {
    return HtmConversion(
      html: html ?? this.html,
      optionsJson: optionsJson ?? this.optionsJson,
      resultJson: resultJson ?? this.resultJson,
      id: id ?? this.id,
    );
  }

  /// Returns a copy of this entity with [field] set to [value].
  ///
  /// Delegates to [copyWith]: the receiver is never mutated and a
  /// null [value] keeps the current field value.
  HtmConversion copyWithField<T>(Field<HtmConversion, T> field, T value) {
    switch (field.name) {
      case 'html':
        return copyWith(html: value as String);
      case 'optionsJson':
        return copyWith(optionsJson: value as String);
      case 'resultJson':
        return copyWith(resultJson: value as String);
      case 'id':
        return copyWith(id: value as String);
      default:
        throw ArgumentError.value(
          field.name,
          'field',
          'HtmConversion has no settable field with this name',
        );
    }
  }

  HtmConversion copyWithHtmConversion({
    String? html,
    String? optionsJson,
    String? resultJson,
    String? id,
  }) {
    return copyWith(
      html: html,
      optionsJson: optionsJson,
      resultJson: resultJson,
      id: id,
    );
  }

  HtmConversion patchWithHtmConversion([HtmConversionPatch? patchInput]) {
    final _patcher = patchInput ?? HtmConversionPatch();
    final _patchMap = _patcher.patchMap;
    return HtmConversion(
      html: _patchMap.containsKey(HtmConversion$.html)
          ? ((_patchMap[HtmConversion$.html] is Function)
                    ? _patchMap[HtmConversion$.html](this.html)
                    : (_patchMap[HtmConversion$.html] is Patch)
                    ? _patchMap[HtmConversion$.html].applyTo(this.html)
                    : _patchMap[HtmConversion$.html])
                as String
          : this.html,
      optionsJson: _patchMap.containsKey(HtmConversion$.optionsJson)
          ? ((_patchMap[HtmConversion$.optionsJson] is Function)
                    ? _patchMap[HtmConversion$.optionsJson](this.optionsJson)
                    : (_patchMap[HtmConversion$.optionsJson] is Patch)
                    ? _patchMap[HtmConversion$.optionsJson].applyTo(
                        this.optionsJson,
                      )
                    : _patchMap[HtmConversion$.optionsJson])
                as String
          : this.optionsJson,
      resultJson: _patchMap.containsKey(HtmConversion$.resultJson)
          ? ((_patchMap[HtmConversion$.resultJson] is Function)
                    ? _patchMap[HtmConversion$.resultJson](this.resultJson)
                    : (_patchMap[HtmConversion$.resultJson] is Patch)
                    ? _patchMap[HtmConversion$.resultJson].applyTo(
                        this.resultJson,
                      )
                    : _patchMap[HtmConversion$.resultJson])
                as String
          : this.resultJson,
      id: _patchMap.containsKey(HtmConversion$.id)
          ? ((_patchMap[HtmConversion$.id] is Function)
                    ? _patchMap[HtmConversion$.id](this.id)
                    : (_patchMap[HtmConversion$.id] is Patch)
                    ? _patchMap[HtmConversion$.id].applyTo(this.id)
                    : _patchMap[HtmConversion$.id])
                as String
          : this.id,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HtmConversion &&
        html == other.html &&
        optionsJson == other.optionsJson &&
        resultJson == other.resultJson &&
        id == other.id;
  }

  @override
  int get hashCode {
    return Object.hash(this.html, this.optionsJson, this.resultJson, this.id);
  }

  @override
  String toString() {
    return 'HtmConversion(' +
        'html: ${html}' +
        ', ' +
        'optionsJson: ${optionsJson}' +
        ', ' +
        'resultJson: ${resultJson}' +
        ', ' +
        'id: ${id})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$HtmConversionToJson(this);
    _sanitizeJson(data);
    return data;
  }

  dynamic _sanitizeJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      json.remove('__typename');
      return json..forEach((key, value) {
        json[key] = _sanitizeJson(value);
      });
    } else if (json is List) {
      return json.map((e) => _sanitizeJson(e)).toList();
    }
    return json;
  }
}

extension HtmConversionPropertyHelpers on HtmConversion {
  bool get hasHtml {
    return this.html.isNotEmpty;
  }

  bool get noHtml {
    return this.html.isEmpty;
  }

  bool get hasOptionsJson {
    return this.optionsJson.isNotEmpty;
  }

  bool get noOptionsJson {
    return this.optionsJson.isEmpty;
  }

  bool get hasResultJson {
    return this.resultJson.isNotEmpty;
  }

  bool get noResultJson {
    return this.resultJson.isEmpty;
  }

  bool get hasId {
    return this.id.isNotEmpty;
  }

  bool get noId {
    return this.id.isEmpty;
  }
}

extension HtmConversionSerialization on HtmConversion {
  Map<String, dynamic> toJson() {
    return _$HtmConversionToJson(this);
  }
}

enum HtmConversion$ { html, optionsJson, resultJson, id }

class HtmConversionPatch extends PatchBase<HtmConversion, HtmConversion$> {
  HtmConversion applyTo(HtmConversion entity) {
    return entity.patchWithHtmConversion(this);
  }

  HtmConversionPatch withHtml(String? value) {
    patchMap[HtmConversion$.html] = value;
    return this;
  }

  HtmConversionPatch withOptionsJson(String? value) {
    patchMap[HtmConversion$.optionsJson] = value;
    return this;
  }

  HtmConversionPatch withResultJson(String? value) {
    patchMap[HtmConversion$.resultJson] = value;
    return this;
  }

  HtmConversionPatch withId(String? value) {
    patchMap[HtmConversion$.id] = value;
    return this;
  }
}

/// Field descriptors for [HtmConversion] query construction
abstract final class HtmConversionFields {
  static const html = Field<HtmConversion, String>('html', _$html);

  static const optionsJson = Field<HtmConversion, String>(
    'optionsJson',
    _$optionsJson,
  );

  static const resultJson = Field<HtmConversion, String>(
    'resultJson',
    _$resultJson,
  );

  static const id = Field<HtmConversion, String>('id', _$id);

  static String _$html(HtmConversion e) {
    return e.html;
  }

  static String _$optionsJson(HtmConversion e) {
    return e.optionsJson;
  }

  static String _$resultJson(HtmConversion e) {
    return e.resultJson;
  }

  static String _$id(HtmConversion e) {
    return e.id;
  }
}

extension HtmConversionCompareE on HtmConversion {
  Map<String, dynamic> compareToHtmConversion(HtmConversion other) {
    final Map<String, dynamic> diff = {};

    if (html != other.html) {
      diff['html'] = () => other.html;
    }

    if (optionsJson != other.optionsJson) {
      diff['optionsJson'] = () => other.optionsJson;
    }

    if (resultJson != other.resultJson) {
      diff['resultJson'] = () => other.resultJson;
    }

    if (id != other.id) {
      diff['id'] = () => other.id;
    }
    return diff;
  }
}
