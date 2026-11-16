# html_to_markdown_ffi_macos

macOS adapter for `html_to_markdown_ffi`: registers the port over an
injected channel and ships the Rust native library inside the package.

## Zero-touch distribution

The adapter ships the Rust static archive as
`macos/html_to_markdown_ffi_macos/Frameworks/libhtml_to_markdown_ffi.xcframework`
(a universal `arm64` + `x86_64` archive exporting the `htm_*` C API) and
links it through the plugin's own Swift package
(`macos/html_to_markdown_ffi_macos/Package.swift`, a `binaryTarget` over that
xcframework). The plugin declares `ffiPlugin: true` for macOS, so Flutter
builds and links it for you.

**A consumer adds the dependency and nothing else** — no Podfile entry, no
xcconfig, no `-force_load` flag, no project-file change of any kind:

```yaml
dependencies:
  html_to_markdown_ffi_macos: ^1.2.3
```

The symbols reach Dart through `DynamicLibrary.process()`.

A host that loads the library by path instead — a widget test, a CLI, a
locator chain — cannot use an xcframework at all and reads the per-slice
dylib under `native/macos-<rid>/`. See
[Two delivery surfaces](#two-delivery-surfaces) below.

### How the archive survives the link

Two details of the Swift package are load-bearing, and both were found by
building a real consumer app rather than by reading the manifest:

- **The product is dynamic.** `.library(name: "html-to-markdown-ffi-macos",
  type: .dynamic, ...)`. A static product contributes only the object files
  it compiles itself; the `binaryTarget`'s archive is not merged into it.
  A dynamic product is linked against the archive and embedded in the app
  bundle (`Contents/Frameworks/html-to-markdown-ffi-macos.framework`), so
  the library is loaded at launch and its symbols are in the global
  namespace that `DynamicLibrary.process()` searches.
- **The product name uses dashes.** Flutter's Swift Package Manager
  integration looks a plugin's product up by the plugin name with
  underscores turned into dashes
  (`flutter_tools/lib/src/macos/swift_package_manager.dart` — the product
  name becomes the `CFBundleIdentifier`, which cannot contain
  underscores). The product must therefore be `html-to-markdown-ffi-macos`,
  not `html_to_markdown_ffi_macos`.
- **A C anchor keeps the archive in the link.** A static archive contributes
  only the object members the linker needs, and nothing in the app
  references `htm_convert` by name, so the archive would be dropped
  silently. The `html_to_markdown_ffi_macos_anchor` target takes the address
  of `htm_convert`, which creates the undefined reference that keeps it.

## Two delivery surfaces

macOS has two kinds of consumer, and the adapter ships one artifact for each:

| Consumer | Artifact | How it reaches the symbols |
| -------- | -------- | -------------------------- |
| A built app | `Frameworks/libhtml_to_markdown_ffi.xcframework` (universal `arm64` + `x86_64` static archive), linked by the Swift package's `binaryTarget` | `DynamicLibrary.process()` |
| A host that loads by path — a widget test, a CLI, a locator chain | `native/macos-arm64/` and `native/macos-x64/libhtml_to_markdown_ffi.dylib` | `DynamicLibrary.open(path)` |

The second row is not optional. An xcframework is an Xcode input: a plain
Dart process cannot dlopen one, so a host that resolves the library by path
has no use for it. Consumers probe the `native/<rid>/` paths by name — see
`NativeLibraryLocator` in zuraffa_browser, whose probe order is env var →
app bundle → adapter `native/<rid>/` → `$HOME` cache. Remove the dylibs and
every one of those probes misses on a fresh machine, which is what 1.3.0 did
(issue [#6](https://github.com/arrrrny/html_to_markdown_ffi/issues/6)) and
what 1.3.2 reverses.

Shipping both is **not** the duplicate-engine problem. That problem is a
*manual* embed + codesign build phase that copies a dylib into
`Contents/Frameworks` beside the SPM-embedded framework; nothing in this
package does that. The raw dylib is only ever opened by path, and never
embedded in an app bundle.

### If you upgraded from a pre-SPM integration

- **Delete any manual embed/codesign build phase** from your Xcode project
  (a phase that copies a `libhtml_to_markdown_ffi.dylib` into
  `Contents/Frameworks` and re-signs it). Keeping it alongside the SPM
  integration ships **two copies of the same engine** in the app bundle —
  the SPM-embedded `html-to-markdown-ffi-macos.framework` and the
  hand-embedded dylib — and the extra CodeSign step is a common source of
  build failures (e.g. `errSecInternalComponent` when the login keychain
  disallows interaction).

The platform loader (`html_to_markdown_ffi_platform`) is unchanged by this:
its chain is env var → resolver seam → sibling (Android only) →
`~/.html_to_markdown_ffi/` cache → `target/release` → GitHub release
download. It never probes this package's `native/` paths, so an app that
links the xcframework keeps reaching the symbols through
`DynamicLibrary.process()` and never loads the second copy.

```dart
final getIt = GetIt.instance;
registerMacosHtmlToMarkdownFfiDependencies(
  getIt,
  channel: MacosHtmlToMarkdownFfiChannel.native(),
);
final service = getIt<HtmlToMarkdownFfiService>();
```
