import 'dart:typed_data';

import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';

import 'macos_html_to_markdown_ffi_channel.dart';
import 'macos_html_to_markdown_ffi_exception.dart';

/// macOS [HtmlToMarkdownFfiPort] over the typed
/// [MacosHtmlToMarkdownFfiChannel].
class MacosHtmlToMarkdownFfiPort implements HtmlToMarkdownFfiPort {
  final MacosHtmlToMarkdownFfiChannel channel;

  const MacosHtmlToMarkdownFfiPort({required this.channel});

  @override
  Future<bool> isSupported() async {
    final result = await channel.call('isSupported', const {});
    return result?['supported'] == true;
  }

  @override
  Future<HtmlToMarkdownFfiModule> compile({
    required String id,
    required Uint8List bytes,
  }) async {
    final result = await channel.call('compile', {
      'id': id,
      'bytes': bytes,
    });
    return HtmlToMarkdownFfiModule(
      id: id,
      byteLength:
          (result?['byteLength'] as num?)?.toInt() ?? bytes.lengthInBytes,
    );
  }

  @override
  Future<List<HtmlToMarkdownFfiValue>> invoke({
    required String id,
    required String export,
    List<HtmlToMarkdownFfiValue> args = const [],
  }) async {
    final result = await channel.call('invoke', {
      'id': id,
      'export': export,
      'args': [for (final arg in args) arg.encode()],
    });
    final values = result?['values'];
    if (values is! List) {
      throw const MacosHtmlToMarkdownFfiException(
        'malformed_response',
        'The invoke result carried no value list.',
        recoverable: false,
      );
    }
    return [for (final raw in values) HtmlToMarkdownFfiValue.decode(raw)];
  }

  @override
  Future<void> unload({required String id}) async {
    await channel.call('unload', {'id': id});
  }
}
