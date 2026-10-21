# Publish Configuration for `html_to_markdown_ffi`

<!-- Managed with the publish-manager skill. Edit if the workflow changes. -->

## Package Manager

- **Type**: `pub.dev`
- **Packages** (in publish order — the shared core first; the adapters, the
  pure-Dart engine and the Flutter plugin declare their in-family
  dependencies hosted):
1. `html_to_markdown_ffi_platform`
2. `html_to_markdown_ffi_android`
3. `html_to_markdown_ffi_ios`
4. `html_to_markdown_ffi_macos`
5. `html_to_markdown_ffi` — the pure-Dart engine
6. `html_to_markdown_ffi_flutter` — the Flutter plugin (last: it depends on
   the engine and on all three adapters)
- **All packages are public**

## Scripts

- **Pre-publish**: `./scripts/prepare_for_publish.sh <version>` — creates `publish-<version>` branch, bumps all package versions + in-family constraints, propagates the root CHANGELOG entry into each package, commits
- **Publish**: `./scripts/publish.sh` — dry-run + publish per package in order, waits for pub.dev propagation (needs flutter/dart on PATH)
- **Post-publish**: `./scripts/push_to_master.sh -f` — merges the publish branch to master, tags, pushes, deletes the branch
- **Restore dev**: not needed — `dependency_overrides` are stripped by pub on publish; nothing to convert back

## Workflow

1. Write the release notes as a `## <version>` entry at the TOP of the root `CHANGELOG.md`
2. `./scripts/prepare_for_publish.sh <version>`
3. `git push origin publish-<version>`
4. `bash scripts/publish.sh` (allow 10-30 min: propagation waits between packages)
5. `bash scripts/push_to_master.sh -f`

## Notes

- `zikzak`-style sibling path overrides never need converting: pub ignores `dependency_overrides` when publishing.
- Sibling packages fail `dart pub publish --dry-run` until their hosted in-family dependencies exist on pub.dev — publish in order and each dry-run goes green in turn.
