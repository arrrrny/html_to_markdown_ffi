#!/bin/bash
# Builds the Rust FFI artifacts the federated adapter packages ship.
#
#   macOS   static archive (arm64 + x64, lipo'd universal)
#             -> packages/html_to_markdown_ffi_macos/macos/html_to_markdown_ffi_macos/
#                Frameworks/libhtml_to_markdown_ffi.xcframework/
#   Android shared objects (4 ABIs)
#             -> packages/html_to_markdown_ffi_android/android/src/main/jniLibs/<abi>/
#
# Both destinations are the zero-touch layout: the native library travels
# inside the plugin package, so a consumer app never edits its own project
# files to link the library.
#
# The Rust sources live in the html-to-markdown workspace (kreuzberg's
# `html-to-markdown-ffi` crate, crate-type = ["cdylib", "staticlib"]).
# Override the workspace path with RUST_WORKSPACE.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." >/dev/null 2>&1; pwd -P)"
RUST_WORKSPACE="${RUST_WORKSPACE:-$HOME/Developer/html-to-markdown}"
ANDROID_API="${ANDROID_API:-21}"
NDK_VERSION="${NDK_VERSION:-28.2.13676358}"
ANDROID_NDK_HOME="${ANDROID_NDK_HOME:-$HOME/Library/Android/sdk/ndk/$NDK_VERSION}"
NDK_BIN="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin"

MACOS_PKG="$REPO_ROOT/packages/html_to_markdown_ffi_macos"
ANDROID_PKG="$REPO_ROOT/packages/html_to_markdown_ffi_android"

if [ ! -d "$RUST_WORKSPACE" ]; then
  echo "error: Rust workspace not found at $RUST_WORKSPACE" >&2
  exit 1
fi

build_mac() {
  local target="$1"
  echo "==> macOS $target (staticlib)"
  (cd "$RUST_WORKSPACE" && cargo build --release -p html-to-markdown-ffi --target "$target")
}

build_android() {
  local target="$1" abi="$2" triple="$3" ndk_prefix="$4" out="$5"
  echo "==> android $abi ($target)"
  local upper_triple cc_triple clang
  upper_triple="$(echo "$triple" | tr 'a-z-' 'A-Z_')"
  cc_triple="${triple//-/_}"
  clang="$NDK_BIN/${ndk_prefix}${ANDROID_API}-clang"
  # `env` carries the cargo linker overrides: an assignment word may not
  # carry an expanded name, so the dynamic target names cannot be written
  # as shell assignments.
  (cd "$RUST_WORKSPACE" && \
    env "CARGO_TARGET_${upper_triple}_LINKER=$clang" \
        "CC_${cc_triple}=$clang" \
        "AR_${cc_triple}=$NDK_BIN/llvm-ar" \
        "CARGO_TARGET_${upper_triple}_AR=$NDK_BIN/llvm-ar" \
        cargo build --release -p html-to-markdown-ffi --target "$target")
  mkdir -p "$out"
  cp "$RUST_WORKSPACE/target/$target/release/libhtml_to_markdown_ffi.so" "$out/"
}

MODE="${1:-all}"

if [ "$MODE" = "all" ] || [ "$MODE" = "macos" ]; then
  build_mac "aarch64-apple-darwin"
  build_mac "x86_64-apple-darwin"
  slice_dir="$MACOS_PKG/macos/html_to_markdown_ffi_macos/Frameworks/libhtml_to_markdown_ffi.xcframework/macos-arm64_x86_64"
  mkdir -p "$slice_dir"
  lipo -create \
    "$RUST_WORKSPACE/target/aarch64-apple-darwin/release/libhtml_to_markdown_ffi.a" \
    "$RUST_WORKSPACE/target/x86_64-apple-darwin/release/libhtml_to_markdown_ffi.a" \
    -output "$slice_dir/libhtml_to_markdown_ffi.a"
  echo "==> macOS xcframework: $slice_dir/libhtml_to_markdown_ffi.a"
fi

if [ "$MODE" = "all" ] || [ "$MODE" = "android" ]; then
  build_android "aarch64-linux-android" "arm64-v8a" "aarch64-linux-android" "aarch64-linux-android" \
    "$ANDROID_PKG/android/src/main/jniLibs/arm64-v8a"
  build_android "armv7-linux-androideabi" "armeabi-v7a" "armv7-linux-androideabi" "armv7a-linux-androideabi" \
    "$ANDROID_PKG/android/src/main/jniLibs/armeabi-v7a"
  build_android "x86_64-linux-android" "x86_64" "x86_64-linux-android" "x86_64-linux-android" \
    "$ANDROID_PKG/android/src/main/jniLibs/x86_64"
fi

echo "==> done"
