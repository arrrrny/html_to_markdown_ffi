# html_to_markdown_ffi_ios

iOS adapter for the [html_to_markdown_ffi](https://github.com/arrrrny/html_to_markdown_ffi) federated monorepo:
the HtmlToMarkdownFfi port over an injected platform channel, with the shared
envelope machinery from `html_to_markdown_ffi_platform` and a typed failure taxonomy
as pure data.

The channel transport is injected — no Flutter plugin boilerplate, no
native code in this repo. The consuming app (or a native shell) supplies
the `ChannelInvoke` seam:

```dart
import 'package:zuraffa/zuraffa.dart';
import 'package:html_to_markdown_ffi_ios/html_to_markdown_ffi_ios.dart';

void register() {
  registerIosHtmlToMarkdownFfiDependencies(
    GetIt.instance,
    channel: IosHtmlToMarkdownFfiChannel(
      invoke: (method, args) => nativeBridge.call(method, args),
    ),
  );
}
```

Without an injected channel every call surfaces the typed
`channel_not_wired` failure instead of hanging.

## Develop

```bash
dart pub get
dart test
```
