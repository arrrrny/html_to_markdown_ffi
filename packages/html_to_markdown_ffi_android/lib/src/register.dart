import 'package:zuraffa/zuraffa.dart';
import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';

import 'android_html_to_markdown_ffi_channel.dart';
import 'android_html_to_markdown_ffi_exception.dart';
import 'android_html_to_markdown_ffi_port.dart';

/// Registers the Android adapter on [GetIt.instance]: the
/// [HtmlToMarkdownFfiPort] over an injected channel. An injected [timeout] is
/// applied to the wired channel. Without a channel every call surfaces
/// the typed `channel_not_wired` failure.
void registerAndroidHtmlToMarkdownFfiDependencies(
  GetIt getIt, {
  AndroidHtmlToMarkdownFfiChannel? channel,
  Duration? timeout,
}) {
  final wired = (channel == null)
      ? AndroidHtmlToMarkdownFfiChannel(
          invoke: (_, __) => throw const AndroidHtmlToMarkdownFfiException(
            'channel_not_wired',
            'No Android channel was injected — pass one to '
            'registerAndroidHtmlToMarkdownFfiDependencies.',
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
