## 1.3.2 - 2026-11-16

### macOS: the per-slice dylibs are back

- `html_to_markdown_ffi_macos` ships
  `native/macos-arm64/libhtml_to_markdown_ffi.dylib` and
  `native/macos-x64/libhtml_to_markdown_ffi.dylib` again. 1.3.0 retired them
  (issue [#6](https://github.com/arrrrny/html_to_markdown_ffi/issues/6)) on
  the grounds that the xcframework is the only macOS delivery surface —
  true for an app, false for everything else. An xcframework is an Xcode
  input: a plain Dart process cannot dlopen one, so a host that resolves the
  library by path (a widget test, a CLI, a locator chain) had no artifact
  left to find. Consumers probe these exact paths by name — zuraffa_browser's
  `NativeLibraryLocator` puts
  `html_to_markdown_ffi_macos/native/macos-<arch>/libhtml_to_markdown_ffi.dylib`
  third in its chain — so on a fresh machine every probe missed and the
  engine threw `MarkdownEngineUnavailableException` instead of ever reaching
  the download fallback.
- This is **not** the duplicate-engine problem #6 warned about. That was a
  *manual* embed + codesign build phase copying a dylib into
  `Contents/Frameworks` beside the SPM-embedded framework. Nothing here
  embeds anything: the dylib is only ever opened by path, and the platform
  loader's chain is unchanged, so an app that links the xcframework keeps
  reaching the symbols through `DynamicLibrary.process()`.
- `scripts/build_native.sh` emits both slices and normalises each one —
  `install_name_tool -id @rpath/…` to replace the build-tree install id
  cargo bakes in, then an ad-hoc signature, without which arm64 will not
  dlopen. Rebuild with `./scripts/build_native.sh macos`.
- The macOS adapter's delivery test now locks the dylibs in rather than
  asserting their absence.
- **The same binaries ship in `html_to_markdown_ffi_platform/native/macos-<rid>/`**,
  which is what a consumer with only `html_to_markdown_ffi` resolves through.
  The loader probes that copy as step 8 of its chain and
  `downloadIfNeeded()` short-circuits on it, so a plain-Dart macOS host needs
  no environment variable, no `~/.html_to_markdown_ffi/` cache and no GitHub
  download. The probe is correct only because it checks for a real symbol:
  `DynamicLibrary.process()` and `executable()` open on any process whether
  or not the symbols exist, so the bundled copy would otherwise be
  unreachable — and an app that embeds the macOS xcframework keeps using the
  linked copy instead of loading a second one.
- `resolution: workspace` is now declared by all six member packages. Without
  it pub refuses to resolve the workspace, so `dart test` at the repository
  root aborted before running a single test — and with it, `scripts/
  test_all.sh` runs its first stage again.

## 1.3.1 - 2026-11-16

### Dependencies

- The family rides the unified zuraffa line at `^7.5.0` — `zuraffa`, `zuraffa_ffi`
  and `zuraffa_ffi_platform` move to `^7.5.0` across every package, aligning the
  declared constraints to the versions already resolved by the 1.3.0 lockfile.
  No code changes; the full suite passes unchanged against 7.5.0.

## 1.2.9

- Merge publish-1.2.8 into master (changelog: fold native_library restore + family line into the 1.2.9 recovery note)

## 1.2.8 - 2026-10-29

### Dependencies

- The whole fleet rides the unified zuraffa family line: `zuraffa` moves from `^7.2.0` to `^7.3.0` in every package, and `html_to_markdown_ffi_platform` takes `zuraffa_ffi_platform: ^7.3.0` (previously `^0.2.1` — the platform-interface package joined the family's unified version line). No code changes.

# Changelog

## 1.2.7 - 2026-10-21

- **The app-facing package is pure Dart again** (spec
  `004-pure-dart-umbrella`).

  1.2.4 turned `html_to_markdown_ffi` into a Flutter plugin, and a package
  that carries a `flutter: plugin:` manifest asks for the Flutter SDK:
  pub.dev refuses to publish it without an `environment: flutter:`
  constraint, and *any* value of that constraint makes it unresolvable for
  a consumer that has a plain Dart SDK.

      Because resolve_test_umbrella depends on html_to_markdown_ffi >=1.2.4
      which requires the Flutter SDK, version solving failed.

  The family now splits the way `dart_curl` and `dart_curl_flutter` do — the
  engine is pure Dart, the plugin is the Flutter-specific wrapper:

  | Consumer | Declare | Flutter SDK |
  | -------- | ------- | ----------- |
  | A Flutter app | `html_to_markdown_ffi_flutter: ^1.2.7` | required |
  | A CLI, server or worker | `html_to_markdown_ffi: ^1.2.7` | **not** required |

  - `html_to_markdown_ffi` is the engine. Pure Dart, no plugin manifest, and
    the app-facing API is unchanged: `convert()`, `ConversionOptions`,
    `HeadingStyle`, `LinkStyle`, `CodeBlockStyle`, the service facade and
    the DI registration all keep their names and their import path
    `package:html_to_markdown_ffi/html_to_markdown.dart`.
  - `html_to_markdown_ffi_flutter` is the new Flutter plugin. It carries the
    plugin manifest, names the Android, iOS, and macOS adapters as their
    platform's `default_package`, and re-exports the engine's API — and the
    three adapters' registration helpers — under one name.

  One dependency either way, and no project-file change on either side.

  A pure-Dart consumer that already declares `html_to_markdown_ffi: ^1.2.1`
  resolves 1.2.7 and is unblocked: the constraint admits it.

  **Breaking for a Flutter app.** A Flutter app that declared
  `html_to_markdown_ffi` to get the native library linked in now declares
  `html_to_markdown_ffi_flutter` instead. It is still one dependency, still
  no project-file change, and the adapter resolution is unchanged.
