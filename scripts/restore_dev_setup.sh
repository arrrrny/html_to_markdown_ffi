#!/bin/bash
set -e
# Puts the local development setup back after a publish run.
#
# The publish branch strips `resolution: workspace` from every member (the
# field is only valid inside the repository) and pub strips
# `dependency_overrides` on its own. This script restores the workspace
# resolution on the checked-out branch and re-resolves the family.

GREEN='\033[0;32m'; BLUE='\033[0;34m'; RED='\033[0;31m'; NC='\033[0m'

ROOT_DIR="$(cd "$(dirname "$0")/.." >/dev/null 2>&1; pwd -P)"
cd "$ROOT_DIR"

for pkg in "html_to_markdown_ffi" "html_to_markdown_ffi_flutter" "html_to_markdown_ffi_platform" "html_to_markdown_ffi_android" "html_to_markdown_ffi_ios" "html_to_markdown_ffi_macos"; do
    pubspec="packages/$pkg/pubspec.yaml"
    grep -q "^resolution: workspace$" "$pubspec" && continue
    printf '\nresolution: workspace\n' >> "$pubspec"
    echo -e "${BLUE}$pkg -> resolution: workspace${NC}"
done

dart pub get >/dev/null
echo -e "${GREEN}Workspace resolution restored.${NC}"
