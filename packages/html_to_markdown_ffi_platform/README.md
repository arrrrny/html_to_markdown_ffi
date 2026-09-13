# html_to_markdown_ffi_platform

Shared channel-envelope core for the html_to_markdown_ffi platform adapters: decode,
typed-error plumbing, and timeout policy over an injected platform
channel. Adapters bring their own typed exception and taxonomy; the core
never invents one.

Part of the [html_to_markdown_ffi](https://github.com/arrrrny/html_to_markdown_ffi) federated monorepo.

## Develop

```bash
dart pub get
dart test
```
