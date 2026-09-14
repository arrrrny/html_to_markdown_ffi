import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';
import 'package:zuraffa/zuraffa.dart';

import 'android_html_to_markdown_ffi_channel.dart';
import 'android_html_to_markdown_ffi_exception.dart';
import 'android_html_to_markdown_ffi_port.dart';

/// Registers the android adapter on [getIt]: the [HtmlToMarkdownFfiPort]
/// over an injected channel. An injected [timeout] is applied to the wired
/// channel. Without a channel every call surfaces the typed
/// `channel_not_wired` failure; pass
/// `AndroidHtmlToMarkdownFfiChannel.native()` for the real in-process
/// conversion. The native library itself is resolved by the app package's
/// preserved loading chain (bundled, resolver seam, sibling probe, cache,
/// download, loader path) — this registration only wires the port.
void registerAndroidHtmlToMarkdownFfiDependencies(
  GetIt getIt, {
  AndroidHtmlToMarkdownFfiChannel? channel,
  Duration? timeout,
}) {
  final wired = (channel == null)
      ? AndroidHtmlToMarkdownFfiChannel(
          invoke: (_, __) => throw const AndroidHtmlToMarkdownFfiException(
            'channel_not_wired',
            'No android channel was injected — pass one to '
            'registerAndroidHtmlToMarkdownFfiDependencies (e.g. '
            'AndroidHtmlToMarkdownFfiChannel.native()).',
            recoverable: false,
          ),
        )
      : (timeout == null)
          ? channel
          : AndroidHtmlToMarkdownFfiChannel(
              invoke: channel.invoke,
              timeout: timeout,
            );
  getIt.registerLazySingleton<HtmlToMarkdownFfiPort>(
    () => AndroidHtmlToMarkdownFfiPort(channel: wired),
  );
}
