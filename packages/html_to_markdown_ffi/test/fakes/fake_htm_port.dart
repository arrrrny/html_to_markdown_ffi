// Test double for the HtmlToMarkdownFfiPort (offline service tests).
import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';

class FakeHtmPort implements HtmlToMarkdownFfiPort {
  FakeHtmPort({this.asyncAnswer, this.syncAnswer, this.error});

  final ConversionResult? asyncAnswer;
  final ConversionResult? syncAnswer;
  final Object? error;
  final List<String> calls = [];
  ConversionOptions? lastOptions;

  @override
  Future<bool> isSupported() async {
    calls.add('isSupported');
    return true;
  }

  @override
  Future<ConversionResult> convert({
    required String id,
    required String html,
    ConversionOptions? options,
    Visitor? visitor,
  }) async {
    calls.add('convert');
    lastOptions = options;
    if (error != null) throw error!;
    return asyncAnswer ?? const ConversionResult(content: '');
  }

  @override
  ConversionResult convertSync({
    required String id,
    required String html,
    ConversionOptions? options,
    Visitor? visitor,
  }) {
    calls.add('convertSync');
    lastOptions = options;
    if (error != null) throw error!;
    return syncAnswer ?? const ConversionResult(content: '');
  }
}
