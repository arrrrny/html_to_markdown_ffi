import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';
import 'package:zuraffa/zuraffa.dart';

import 'macos_html_to_markdown_ffi_channel.dart';
import 'macos_html_to_markdown_ffi_exception.dart';
import 'macos_html_to_markdown_ffi_port.dart';

/// Registers the macos adapter on [getIt]: the [HtmlToMarkdownFfiPort]
/// over an injected channel. An injected [timeout] is applied to the wired
/// channel. Without a channel every call surfaces the typed
/// `channel_not_wired` failure; pass
/// `MacosHtmlToMarkdownFfiChannel.native()` for the real in-process
/// conversion. The native library itself is resolved by the app package's
/// preserved loading chain (bundled, resolver seam, sibling probe, cache,
/// download, loader path) — this registration only wires the port.
void registerMacosHtmlToMarkdownFfiDependencies(
  GetIt getIt, {
  MacosHtmlToMarkdownFfiChannel? channel,
  Duration? timeout,
}) {
  final wired = (channel == null)
      ? MacosHtmlToMarkdownFfiChannel(
          invoke: (_, __) => throw const MacosHtmlToMarkdownFfiException(
            'channel_not_wired',
            'No macos channel was injected — pass one to '
            'registerMacosHtmlToMarkdownFfiDependencies (e.g. '
            'MacosHtmlToMarkdownFfiChannel.native()).',
            recoverable: false,
          ),
        )
      : (timeout == null)
          ? channel
          : MacosHtmlToMarkdownFfiChannel(
              invoke: channel.invoke,
              timeout: timeout,
            );
  getIt.registerLazySingleton<HtmlToMarkdownFfiPort>(
    () => MacosHtmlToMarkdownFfiPort(channel: wired),
  );
}
