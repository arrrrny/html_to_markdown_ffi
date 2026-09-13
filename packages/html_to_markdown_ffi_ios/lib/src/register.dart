import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';
import 'package:zuraffa/zuraffa.dart';

import 'ios_html_to_markdown_ffi_channel.dart';
import 'ios_html_to_markdown_ffi_exception.dart';
import 'ios_html_to_markdown_ffi_port.dart';

/// Registers the ios adapter on [getIt]: the [HtmlToMarkdownFfiPort]
/// over an injected channel. An injected [timeout] is applied to the wired
/// channel. Without a channel every call surfaces the typed
/// `channel_not_wired` failure; pass
/// `IosHtmlToMarkdownFfiChannel.native()` for the real in-process
/// conversion. The native library itself is resolved by the app package's
/// preserved loading chain (bundled, resolver seam, sibling probe, cache,
/// download, loader path) — this registration only wires the port.
void registerIosHtmlToMarkdownFfiDependencies(
  GetIt getIt, {
  IosHtmlToMarkdownFfiChannel? channel,
  Duration? timeout,
}) {
  final wired = (channel == null)
      ? IosHtmlToMarkdownFfiChannel(
          invoke: (_, __) => throw const IosHtmlToMarkdownFfiException(
            'channel_not_wired',
            'No ios channel was injected — pass one to '
            'registerIosHtmlToMarkdownFfiDependencies (e.g. '
            'IosHtmlToMarkdownFfiChannel.native()).',
            recoverable: false,
          ),
        )
      : (timeout == null)
          ? channel
          : IosHtmlToMarkdownFfiChannel(
              invoke: channel.invoke,
              timeout: timeout,
            );
  getIt.registerLazySingleton<HtmlToMarkdownFfiPort>(
    () => IosHtmlToMarkdownFfiPort(channel: wired),
  );
}
