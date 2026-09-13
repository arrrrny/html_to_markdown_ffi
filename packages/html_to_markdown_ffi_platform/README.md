# html_to_markdown_ffi_platform

Shared envelope core for the `html_to_markdown_ffi` federated family:
the transport seam ([PlatformHtmlToMarkdownFfiEnvelope] — payload decode,
typed error mapping, timeout) and the native-library resolver seam
([HtmNativeLibraries]) adapters use to contribute their bundled binaries
to the preserved loading chain.

Adapters depend on this package plus the app-facing
[`html_to_markdown_ffi`](https://pub.dev/packages/html_to_markdown).
