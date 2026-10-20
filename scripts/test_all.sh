#!/bin/bash
# Runs the whole family's test suite.
#
# The repository is a pub workspace: the root package owns the TDD baseline
# (`test/`), and every member package owns its own `test/`. `dart test` only
# ever covers the package it runs in, so the family's suite is the root suite
# plus one run per member.
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." >/dev/null 2>&1; pwd -P)"
status=0

run() {
  local dir="$1"
  echo "==> dart test in ${dir#"$ROOT"/}"
  (cd "$dir" && dart test --concurrency=2) || status=1
}

run "$ROOT"
for pkg in "$ROOT"/packages/*/; do
  [ -f "$pkg/pubspec.yaml" ] || continue
  run "${pkg%/}"
done

exit $status
