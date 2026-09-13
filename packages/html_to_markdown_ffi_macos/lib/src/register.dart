import 'package:zuraffa/zuraffa.dart';
import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';

import 'macos_html_to_markdown_ffi_channel.dart';
import 'macos_html_to_markdown_ffi_exception.dart';
import 'macos_html_to_markdown_ffi_port.dart';

/// Registers the macOS adapter on [GetIt.instance]: the
/// [HtmlToMarkdownFfiPort] over an injected channel. An injected [timeout] is
/// applied to the wired channel. Without a channel every call surfaces
/// the typed `channel_not_wired` failure.
void registerMacosHtmlToMarkdownFfiDependencies(
  GetIt getIt, {
  MacosHtmlToMarkdownFfiChannel? channel,
  Duration? timeout,
}) {
  final wired = (channel == null)
      ? MacosHtmlToMarkdownFfiChannel(
          invoke: (_, __) => throw const MacosHtmlToMarkdownFfiException(
            'channel_not_wired',
            'No macOS channel was injected — pass one to '
            'registerMacosHtmlToMarkdownFfiDependencies.',
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
