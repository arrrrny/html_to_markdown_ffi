import 'enums.dart';

class ConversionOptions {
  HeadingStyle headingStyle;
  ListIndentType listIndentType;
  int listIndentWidth;
  String bullets;
  String strongEmSymbol;
  bool escapeAsterisks;
  bool escapeUnderscores;
  bool escapeMisc;
  bool escapeAscii;
  String codeLanguage;
  bool autolinks;
  bool defaultTitle;
  bool brInTables;
  HighlightStyle highlightStyle;
  bool extractMetadata;
  WhitespaceMode whitespaceMode;
  bool stripNewlines;
  bool wrap;
  int wrapWidth;
  bool convertAsInline;
  String subSymbol;
  String supSymbol;
  NewlineStyle newlineStyle;
  CodeBlockStyle codeBlockStyle;
  List<String> keepInlineImagesIn;
  PreprocessingOptions preprocessing;
  String encoding;
  bool debug;
  List<String> stripTags;
  List<String> preserveTags;
  bool skipImages;
  LinkStyle linkStyle;
  OutputFormat outputFormat;
  bool includeDocumentStructure;
  bool extractImages;
  int maxImageSize;
  bool captureSvg;
  bool inferDimensions;
  int? maxDepth;
  List<String> excludeSelectors;

  ConversionOptions({
    this.headingStyle = HeadingStyle.atx,
    this.listIndentType = ListIndentType.spaces,
    this.listIndentWidth = 2,
    this.bullets = '-',
    this.strongEmSymbol = '*',
    this.escapeAsterisks = true,
    this.escapeUnderscores = true,
    this.escapeMisc = false,
    this.escapeAscii = false,
    this.codeLanguage = '',
    this.autolinks = true,
    this.defaultTitle = false,
    this.brInTables = false,
    this.highlightStyle = HighlightStyle.standard,
    this.extractMetadata = false,
    this.whitespaceMode = WhitespaceMode.normal,
    this.stripNewlines = false,
    this.wrap = false,
    this.wrapWidth = 80,
    this.convertAsInline = false,
    this.subSymbol = '~',
    this.supSymbol = '^',
    this.newlineStyle = NewlineStyle.lf,
    this.codeBlockStyle = CodeBlockStyle.fenced,
    this.keepInlineImagesIn = const [],
    this.preprocessing = const PreprocessingOptions(),
    this.encoding = 'utf-8',
    this.debug = false,
    this.stripTags = const [],
    this.preserveTags = const [],
    this.skipImages = false,
    this.linkStyle = LinkStyle.inlined,
    this.outputFormat = OutputFormat.standard,
    this.includeDocumentStructure = false,
    this.extractImages = false,
    this.maxImageSize = 5242880,
    this.captureSvg = false,
    this.inferDimensions = false,
    this.maxDepth,
    this.excludeSelectors = const [],
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'heading_style': headingStyle.toJson,
      'list_indent_type': listIndentType.toJson,
      'list_indent_width': listIndentWidth,
      'bullets': bullets,
      'strong_em_symbol': strongEmSymbol,
      'escape_asterisks': escapeAsterisks,
      'escape_underscores': escapeUnderscores,
      'escape_misc': escapeMisc,
      'escape_ascii': escapeAscii,
      'code_language': codeLanguage,
      'autolinks': autolinks,
      'default_title': defaultTitle,
      'br_in_tables': brInTables,
      'highlight_style': highlightStyle.toJson,
      'extract_metadata': extractMetadata,
      'whitespace_mode': whitespaceMode.toJson,
      'strip_newlines': stripNewlines,
      'wrap': wrap,
      'wrap_width': wrapWidth,
      'convert_as_inline': convertAsInline,
      'sub_symbol': subSymbol,
      'sup_symbol': supSymbol,
      'newline_style': newlineStyle.toJson,
      'code_block_style': codeBlockStyle.toJson,
      'keep_inline_images_in': keepInlineImagesIn,
      'preprocessing': preprocessing.toJson(),
      'encoding': encoding,
      'debug': debug,
      'strip_tags': stripTags,
      'preserve_tags': preserveTags,
      'skip_images': skipImages,
      'link_style': linkStyle.toJson,
      'output_format': outputFormat.toJson,
      'include_document_structure': includeDocumentStructure,
      'extract_images': extractImages,
      'max_image_size': maxImageSize,
      'capture_svg': captureSvg,
      'infer_dimensions': inferDimensions,
      'exclude_selectors': excludeSelectors,
    };

    if (maxDepth != null) json['max_depth'] = maxDepth;

    return json;
  }

  factory ConversionOptions.fromJson(Map<String, dynamic> json) {
    return ConversionOptions(
      headingStyle:
          HeadingStyle.fromJson((json['heading_style'] as String?) ?? 'atx'),
      listIndentType: ListIndentType.fromJson(
          (json['list_indent_type'] as String?) ?? 'spaces'),
      listIndentWidth: json['list_indent_width'] as int? ?? 2,
      bullets: (json['bullets'] as String?) ?? '-',
      strongEmSymbol: (json['strong_em_symbol'] as String?) ?? '*',
      escapeAsterisks: json['escape_asterisks'] as bool? ?? true,
      escapeUnderscores: json['escape_underscores'] as bool? ?? true,
      escapeMisc: json['escape_misc'] as bool? ?? false,
      escapeAscii: json['escape_ascii'] as bool? ?? false,
      codeLanguage: (json['code_language'] as String?) ?? '',
      autolinks: json['autolinks'] as bool? ?? true,
      defaultTitle: json['default_title'] as bool? ?? false,
      brInTables: json['br_in_tables'] as bool? ?? false,
      highlightStyle: HighlightStyle.fromJson(
          (json['highlight_style'] as String?) ?? 'standard'),
      extractMetadata: json['extract_metadata'] as bool? ?? false,
      whitespaceMode: WhitespaceMode.fromJson(
          (json['whitespace_mode'] as String?) ?? 'normal'),
      stripNewlines: json['strip_newlines'] as bool? ?? false,
      wrap: json['wrap'] as bool? ?? false,
      wrapWidth: json['wrap_width'] as int? ?? 80,
      convertAsInline: json['convert_as_inline'] as bool? ?? false,
      subSymbol: (json['sub_symbol'] as String?) ?? '~',
      supSymbol: (json['sup_symbol'] as String?) ?? '^',
      newlineStyle:
          NewlineStyle.fromJson((json['newline_style'] as String?) ?? 'lf'),
      codeBlockStyle: CodeBlockStyle.fromJson(
          (json['code_block_style'] as String?) ?? 'fenced'),
      keepInlineImagesIn:
          (json['keep_inline_images_in'] as List?)?.cast<String>() ?? [],
      preprocessing: json['preprocessing'] != null
          ? PreprocessingOptions.fromJson(
              json['preprocessing'] as Map<String, dynamic>)
          : const PreprocessingOptions(),
      encoding: (json['encoding'] as String?) ?? 'utf-8',
      debug: json['debug'] as bool? ?? false,
      stripTags: (json['strip_tags'] as List?)?.cast<String>() ?? [],
      preserveTags: (json['preserve_tags'] as List?)?.cast<String>() ?? [],
      skipImages: json['skip_images'] as bool? ?? false,
      linkStyle:
          LinkStyle.fromJson((json['link_style'] as String?) ?? 'inlined'),
      outputFormat: OutputFormat.fromJson(
          (json['output_format'] as String?) ?? 'standard'),
      includeDocumentStructure:
          json['include_document_structure'] as bool? ?? false,
      extractImages: json['extract_images'] as bool? ?? false,
      maxImageSize: json['max_image_size'] as int? ?? 5242880,
      captureSvg: json['capture_svg'] as bool? ?? false,
      inferDimensions: json['infer_dimensions'] as bool? ?? false,
      maxDepth: json['max_depth'] as int?,
      excludeSelectors:
          (json['exclude_selectors'] as List?)?.cast<String>() ?? [],
    );
  }
}

/// Preprocessing configuration for HTML cleanup before conversion.
class PreprocessingOptions {
  final bool enabled;
  final String preset;
  final bool removeNavigation;
  final bool removeForms;

  const PreprocessingOptions({
    this.enabled = false,
    this.preset = 'Standard',
    this.removeNavigation = false,
    this.removeForms = false,
  });

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'preset': preset,
        'remove_navigation': removeNavigation,
        'remove_forms': removeForms,
      };

  factory PreprocessingOptions.fromJson(Map<String, dynamic> json) {
    return PreprocessingOptions(
      enabled: json['enabled'] as bool? ?? false,
      preset: (json['preset'] as String?) ?? 'Standard',
      removeNavigation: json['remove_navigation'] as bool? ?? false,
      removeForms: json['remove_forms'] as bool? ?? false,
    );
  }
}
