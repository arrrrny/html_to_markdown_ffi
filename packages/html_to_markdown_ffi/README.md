# html_to_markdown_ffi

Typed HTML to Markdown conversion for the Zuraffa ecosystem: a Rust FFI core behind a pure-Dart converter port with federated native adapters.

Part of the [html_to_markdown_ffi](https://github.com/arrrrny/html_to_markdown_ffi) federated monorepo, built on the
[Zuraffa](https://pub.dev/packages/zuraffa) framework.

## Use

```dart
final service = HtmlToMarkdownFfiService(port: myPlatformPort);
final module = await service.compile(id: 'demo', bytes: moduleBytes);
final results = await service.call(
    id: 'demo', export: 'run', args: [HtmlToMarkdownFfiI32(1)]);
await service.unload(id: 'demo');
```

Wire the platform adapter for the running platform first — e.g.
`registerAndroidHtmlToMarkdownFfiDependencies(getIt, channel: ...)` from
the adapter package — then resolve `HtmlToMarkdownFfiService`, or call
`registerHtmlToMarkdownFfiDependencies(getIt, port: ...)` directly. Without a
wired port every call surfaces the typed `port_not_wired` failure.

## Develop

```bash
dart pub get
dart test
```
