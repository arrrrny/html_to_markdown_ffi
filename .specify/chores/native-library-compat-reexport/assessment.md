# Chore Assessment: Restore the pre-migration `native_library.dart` import path (re-export `HtmNativeLibraries`)

- **Slug**: native-library-compat-reexport
- **Created**: 2026-10-25
- **Source**: https://github.com/arrrrny/zuraffa/issues/2020 (filed on zuraffa because `arrrrny/html-to-markdown` has issues disabled; the fix target is this repo, `arrrrny/html_to_markdown_ffi`)
- **Verdict**: in scope
- **Size**: small

## Report (verbatim or summarized)

Issue arrrrny/zuraffa#2020: `html_to_markdown_ffi` 1.2.2–1.2.7 carried a semver-breaking
rewrite inside a patch series. The loader seam (`native_library.dart`,
`HtmNativeLibraries.registerResolver`) moved to `html_to_markdown_ffi_platform` 1.2.x
with an identical signature, but the old import path
`package:html_to_markdown_ffi/native_library.dart` disappeared and neither curated
show-list (`lib/html_to_markdown.dart`, `lib/html_to_markdown_ffi.dart`) re-exports
`HtmNativeLibraries` — so every consumer importing the old path or calling
`registerResolver` breaks at analyze time on a plain `pub upgrade` inside `^1.2.0`.
Consumer break (zuraffa_browser, lock 1.2.1 → 1.2.7):

```
error • Target of URI doesn't exist: 'package:html_to_markdown_ffi/native_library.dart' • lib/src/markdown/markdown_engine.dart:16:8
error • Undefined name 'HtmNativeLibraries' • lib/src/markdown/markdown_engine.dart:125:7
```

Suggested upstream fix (the issue's own words): re-export `HtmNativeLibraries` (and a
`native_library.dart` compatibility library) from `package:html_to_markdown_ffi` so the
pre-migration import path keeps resolving.

## Summary

Restore the pre-migration public surface additively: a `lib/native_library.dart`
compatibility library re-exporting the platform package's `native_library.dart`, plus the
two seam names added to both curated barrels' `show` clauses. No behavior change, no
version bump, no generated files.

## Constitution Check

Verified against tag `1.2.1`: `packages/html_to_markdown_ffi/lib/native_library.dart`
existed and exported exactly `HtmNativeLibraryResolver`, `HtmNativeLibraries`,
`NativeLibrary`; the current `html_to_markdown_ffi_platform/lib/native_library.dart`
carries the identical public API (diff shows only comments/internals changed). The fix
restores the migrated surface without touching it — public API preserved (FR-006 of spec
064), no new dependencies.

## Affected Paths

- `packages/html_to_markdown_ffi/lib/native_library.dart` — NEW compat library:
  `export 'package:html_to_markdown_ffi_platform/native_library.dart';` under the
  pre-migration URI.
- `packages/html_to_markdown_ffi/lib/html_to_markdown.dart` — add `HtmNativeLibraries`,
  `HtmNativeLibraryResolver` to the platform `show` list.
- `packages/html_to_markdown_ffi/lib/html_to_markdown_ffi.dart` — same two names.
- `packages/html_to_markdown_ffi/test/compat_native_library_export_test.dart` — NEW
  TDD gate pinning all three import paths (old URI + both barrels).

## Proposed Approach

**Preferred**: pure re-export restoration (above). The seam itself never changed, so a
re-export makes the old path resolve with the same declarations — no shim classes, no
deprecation warnings to maintain.

**Alternatives**:
- Publish the next cut as 2.0.0 without a shim (rejected: leaves every `^1.2.0`
  consumer broken on upgrade, which is the exact harm the issue reports).
- Have consumers depend on `html_to_markdown_ffi_platform` directly (that is the
  workaround zuraffa_browser already shipped; rejected as the general fix because it
  forces every consumer to chase internal package layout).

**Verification to run**:
- `dart analyze` (workspace) — clean.
- `dart test -j 2` in `packages/html_to_markdown_ffi` — 90 pre-existing + 4 new, green.
- Workspace suites (platform, flutter umbrella, root) — green.

## Risks & Considerations

- Export-collision risk in the flutter umbrella (which re-exports the engine): covered by
  workspace-wide `dart analyze` + umbrella suite — clean.
- The 1.2.x series remains semver-impure in history; this PR restores compatibility
  forward, it cannot un-break already-broken intermediate locks (consumers pin the
  workaround until the next release).

## Open Questions

- None. The issue's "and/or publish the next breaking cut as 2.0.0" is a maintainer
  release decision, out of scope for this change (no version bumps).
