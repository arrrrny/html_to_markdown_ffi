import 'package:zuraffa/zuraffa.dart';
import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';

import 'ios_html_to_markdown_ffi_channel.dart';
import 'ios_html_to_markdown_ffi_exception.dart';
import 'ios_html_to_markdown_ffi_port.dart';

/// Registers the iOS adapter on [GetIt.instance]: the
/// [HtmlToMarkdownFfiPort] over an injected channel. An injected [timeout] is
/// applied to the wired channel. Without a channel every call surfaces
/// the typed `channel_not_wired` failure.
void registerIosHtmlToMarkdownFfiDependencies(
  GetIt getIt, {
  IosHtmlToMarkdownFfiChannel? channel,
  Duration? timeout,
}) {
  final wired = (channel == null)
      ? IosHtmlToMarkdownFfiChannel(
          invoke: (_, __) => throw const IosHtmlToMarkdownFfiException(
            'channel_not_wired',
            'No iOS channel was injected — pass one to '
            'registerIosHtmlToMarkdownFfiDependencies.',
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
