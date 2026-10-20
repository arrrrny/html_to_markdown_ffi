class ConversionResult {
  final String? content;
  final dynamic document;
  final HtmlMetadata? metadata;
  final List<Map<String, dynamic>> tables;
  final List<String> images;
  final List<ProcessingWarning> warnings;

  const ConversionResult({
    this.content,
    this.document,
    this.metadata,
    this.tables = const [],
    this.images = const [],
    this.warnings = const [],
  });

  factory ConversionResult.fromJson(Map<String, dynamic> json) {
    return ConversionResult(
      content: json['content'] as String?,
      document: json['document'],
      metadata: json['metadata'] != null
          ? HtmlMetadata.fromJson(json['metadata'] as Map<String, dynamic>)
          : null,
      tables: (json['tables'] as List?)
              ?.map((t) => Map<String, dynamic>.from(t as Map))
              .toList() ??
          [],
      images: (json['images'] as List?)?.map((e) => e as String).toList() ?? [],
      warnings: (json['warnings'] as List?)
              ?.map((w) =>
                  ProcessingWarning.fromJson(w as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Extracted HTML metadata from document head and body.
///
/// The Rust core outputs metadata with a nested `document` key containing
/// the page-level metadata (title, description, etc.).
class HtmlMetadata {
  final String? title;
  final String? description;
  final String? author;
  final String? date;
  final String? language;
  final List<String> keywords;
  final String? canonicalUrl;
  final String? baseHref;
  final List<LinkMetadata> links;
  final List<ImageMetadata> images;
  final List<Map<String, dynamic>> structuredData;

  const HtmlMetadata({
    this.title,
    this.description,
    this.author,
    this.date,
    this.language,
    this.keywords = const [],
    this.canonicalUrl,
    this.baseHref,
    this.links = const [],
    this.images = const [],
    this.structuredData = const [],
  });

  factory HtmlMetadata.fromJson(Map<String, dynamic> json) {
    // The Rust serializes metadata as {"document": {...}, "links": [...], ...}
    final document = json['document'] as Map<String, dynamic>? ?? {};

    // keywords can be a list of strings or a string
    List<String> parseKeywords(dynamic kw) {
      if (kw is List) return kw.map((e) => e.toString()).toList();
      if (kw is String) return kw.split(',').map((e) => e.trim()).toList();
      return [];
    }

    return HtmlMetadata(
      title: document['title'] as String?,
      description: document['description'] as String?,
      author: document['author'] as String?,
      language: document['language'] as String?,
      keywords: parseKeywords(document['keywords']),
      canonicalUrl: document['canonical_url'] as String?,
      baseHref: document['base_href'] as String?,
      links: (json['links'] as List?)
              ?.map((l) => LinkMetadata.fromJson(l as Map<String, dynamic>))
              .toList() ??
          [],
      images: (json['images'] as List?)
              ?.map((i) => ImageMetadata.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
      structuredData: (json['structured_data'] as List?)
              ?.map((s) => Map<String, dynamic>.from(s as Map))
              .toList() ??
          [],
    );
  }
}

class LinkMetadata {
  final String? href;
  final String? text;
  final String? title;
  final String? rel;

  const LinkMetadata({this.href, this.text, this.title, this.rel});

  factory LinkMetadata.fromJson(Map<String, dynamic> json) {
    return LinkMetadata(
      href: json['href'] as String?,
      text: json['text'] as String?,
      title: json['title'] as String?,
      rel: _optionalString(json['rel']),
    );
  }
}

class ImageMetadata {
  final String? src;
  final String? alt;
  final String? title;

  const ImageMetadata({this.src, this.alt, this.title});

  factory ImageMetadata.fromJson(Map<String, dynamic> json) {
    return ImageMetadata(
      src: json['src'] as String?,
      alt: json['alt'] as String?,
      title: json['title'] as String?,
    );
  }
}

class ProcessingWarning {
  final String kind;
  final String message;

  const ProcessingWarning({required this.kind, required this.message});

  factory ProcessingWarning.fromJson(Map<String, dynamic> json) {
    return ProcessingWarning(
      kind: (json['kind'] as String?) ?? 'other',
      message: (json['message'] as String?) ?? '',
    );
  }
}

String? _optionalString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is List) return value.isEmpty ? null : value.first.toString();
  return value.toString();
}
