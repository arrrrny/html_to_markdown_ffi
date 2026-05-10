/// Supported heading styles.
enum HeadingStyle {
  atx,
  setext;

  String get toJson => name;
  static HeadingStyle fromJson(String value) =>
      HeadingStyle.values.firstWhere((e) => e.name == value);
}

/// Link rendering style.
enum LinkStyle {
  inlined,
  referenced;

  String get toJson => name;
  static LinkStyle fromJson(String value) =>
      LinkStyle.values.firstWhere((e) => e.name == value);
}

/// Code block rendering style.
enum CodeBlockStyle {
  fenced,
  indented;

  String get toJson => name;
  static CodeBlockStyle fromJson(String value) =>
      CodeBlockStyle.values.firstWhere((e) => e.name == value);
}

/// Whitespace handling mode.
enum WhitespaceMode {
  normal,
  collapse,
  preserve;

  String get toJson => name;
  static WhitespaceMode fromJson(String value) =>
      WhitespaceMode.values.firstWhere((e) => e.name == value);
}

/// Output format for the converted Markdown.
enum OutputFormat {
  standard;

  String get toJson => name;
  static OutputFormat fromJson(String value) =>
      OutputFormat.values.firstWhere((e) => e.name == value);
}

/// Line ending style.
enum NewlineStyle {
  lf,
  crlf;

  String get toJson => name;
  static NewlineStyle fromJson(String value) =>
      NewlineStyle.values.firstWhere((e) => e.name == value);
}

/// Code highlighting style.
enum HighlightStyle {
  standard,
  none;

  String get toJson => name;
  static HighlightStyle fromJson(String value) =>
      HighlightStyle.values.firstWhere((e) => e.name == value);
}

/// List indentation type.
enum ListIndentType {
  spaces,
  tabs;

  String get toJson => name;
  static ListIndentType fromJson(String value) =>
      ListIndentType.values.firstWhere((e) => e.name == value);
}

/// Preprocessing preset for input normalization.
enum PreprocessingPreset {
  standard,
  aggressive,
  minimal;

  String get toJson => name;
  static PreprocessingPreset fromJson(String value) =>
      PreprocessingPreset.values.firstWhere((e) => e.name == value);
}

/// Processing warning category.
enum WarningKind {
  parse,
  sanitization,
  config,
  io,
  other;

  String get toJson => name;
  static WarningKind fromJson(String value) =>
      WarningKind.values.firstWhere((e) => e.name == value);
}

/// HTML node type for visitor context.
enum NodeType {
  element,
  text,
  comment,
  document;

  String get toJson => name;
  static NodeType fromJson(String value) =>
      NodeType.values.firstWhere((e) => e.name == value);
}

/// Result of a visitor callback. `continue_` has underscore suffix because
/// `continue` is a reserved keyword in Dart.
enum VisitResult {
  continue_,
  skip,
  preserveHtml,
  custom,
  error;

  /// Returns the C integer encoding for this result.
  int get toC {
    switch (this) {
      case VisitResult.continue_:
        return 0;
      case VisitResult.skip:
        return 1;
      case VisitResult.preserveHtml:
        return 2;
      case VisitResult.custom:
        return 3;
      case VisitResult.error:
        return 4;
    }
  }

  String get toJson => name == 'continue_' ? 'continue' : name;
  static VisitResult fromJson(String value) {
    final normalized = value == 'continue' ? 'continue_' : value;
    return VisitResult.values.firstWhere((e) => e.name == normalized);
  }
}
