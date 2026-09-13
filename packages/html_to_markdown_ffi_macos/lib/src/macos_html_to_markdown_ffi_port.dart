import 'dart:io';

import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';

import 'macos_html_to_markdown_ffi_channel.dart';
import 'macos_html_to_markdown_ffi_exception.dart';

/// macos [HtmlToMarkdownFfiPort] over the typed
/// [MacosHtmlToMarkdownFfiChannel]. [convertSync] requires the running
/// host to be macos (the native library is in-process there); any other
/// host surfaces the typed `sync_unsupported` failure. The async
/// [convert] path decodes the channel payload through the envelope.
class MacosHtmlToMarkdownFfiPort implements HtmlToMarkdownFfiPort {
  final MacosHtmlToMarkdownFfiChannel channel;

  const MacosHtmlToMarkdownFfiPort({required this.channel});

  @override
  Future<bool> isSupported() async {
    final result = await channel.call('isSupported', const {});
    return result?['supported'] == true;
  }

  @override
  Future<ConversionResult> convert({
    required String id,
    required String html,
    ConversionOptions? options,
    Visitor? visitor,
  }) async {
    if (visitor != null) {
      throw const MacosHtmlToMarkdownFfiException(
        'visitor_unsupported',
        'Visitor callbacks require the synchronous in-process path '
        '(convertSync) — they cannot cross the envelope payload.',
        recoverable: false,
      );
    }
    final result = await channel.call('convert', {
      'id': id,
      'html': html,
      'optionsJson': optionsJsonOf(options),
    });
    final json = result?['resultJson'];
    if (json is! String) {
      throw const MacosHtmlToMarkdownFfiException(
        'malformed_response',
        'The convert result carried no result json.',
        recoverable: false,
      );
    }
    return conversionResultFromJson(json);
  }

  @override
  ConversionResult convertSync({
    required String id,
    required String html,
    ConversionOptions? options,
    Visitor? visitor,
  }) {
    if (!Platform.isMacOS) {
      throw const MacosHtmlToMarkdownFfiException(
        'sync_unsupported',
        'Synchronous in-process conversion requires the native library of '
        'the running platform.',
        recoverable: false,
      );
    }
    final dataSource = NativeHtmConversionDataSource();
    return conversionResultFromJson(
      dataSource
          .convertNow(
            HtmConversion(
              id: id,
              html: html,
              optionsJson: optionsJsonOf(options),
              resultJson: '',
            ),
            visitor: visitor,
          )
          .resultJson,
    );
  }
}
