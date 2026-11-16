#!/bin/bash
# Builds the Rust FFI artifacts the federated adapter packages ship.
#
#   macOS   static archive (arm64 + x64, lipo'd universal)
#             -> packages/html_to_markdown_ffi_macos/macos/html_to_markdown_ffi_macos/
#                Frameworks/libhtml_to_markdown_ffi.xcframework/
#           dynamic library, one per slice, in two packages
#             -> packages/html_to_markdown_ffi_macos/native/macos-<rid>/
#             -> packages/html_to_markdown_ffi_platform/native/macos-<rid>/
#   Android shared objects (4 ABIs)
#             -> packages/html_to_markdown_ffi_android/android/src/main/jniLibs/<abi>/
#
# Every destination is the zero-touch layout: the native library travels
# inside the plugin package, so a consumer app never edits its own project
# files to link the library.
#
# macOS carries two artifacts because it has two consumers. An app *links* the
# static archive through the Swift package's `binaryTarget`, and reaches the
# symbols with `DynamicLibrary.process()`. A host that loads by path — a
# Flutter widget test, a CLI, any locator chain — cannot use an xcframework at
# all, so it dlopens the per-slice dylib from `native/macos-<rid>/`. Shipping
# both is not a duplicate engine in the app: nothing embeds the raw dylib, it
# is only ever opened by path, and the loader probes the process handle first
# and only falls back to the bundled copy when that has no symbols.
#
# The dylib lands in two packages on purpose. The macOS adapter is where a
# consumer that names `html_to_markdown_ffi_macos` looks for it; the platform
# package is what a consumer with only `html_to_markdown_ffi` resolves
# through, and it is the one that makes the engine work with no setup at all.
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
PLATFORM_PKG="$REPO_ROOT/packages/html_to_markdown_ffi_platform"
ANDROID_PKG="$REPO_ROOT/packages/html_to_markdown_ffi_android"

if [ ! -d "$RUST_WORKSPACE" ]; then
  echo "error: Rust workspace not found at $RUST_WORKSPACE" >&2
  exit 1
fi

build_mac() {
  local target="$1"
  echo "==> macOS $target (staticlib + cdylib)"
  (cd "$RUST_WORKSPACE" && cargo build --release -p html-to-markdown-ffi --target "$target")
}

# Copies one slice's cdylib into the adapter's `native/<rid>/` and makes it
# loadable wherever it lands:
#   - `install_name_tool -id @rpath/…` replaces the install id cargo baked in,
#     which names the build tree and is meaningless in a pub cache;
#   - the ad-hoc signature is what lets an arm64 slice be dlopen'd at all.
install_dylib() {
  local target="$1" rid="$2" pkg="$3"
  local out="$pkg/native/$rid"
  mkdir -p "$out"
  cp "$RUST_WORKSPACE/target/$target/release/libhtml_to_markdown_ffi.dylib" \
    "$out/libhtml_to_markdown_ffi.dylib"
  install_name_tool -id @rpath/libhtml_to_markdown_ffi.dylib \
    "$out/libhtml_to_markdown_ffi.dylib"
  codesign --force --sign - "$out/libhtml_to_markdown_ffi.dylib"
  echo "==> macOS dylib: $out/libhtml_to_markdown_ffi.dylib"
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
  install_dylib "aarch64-apple-darwin" "macos-arm64" "$MACOS_PKG"
  install_dylib "x86_64-apple-darwin" "macos-x64" "$MACOS_PKG"
  install_dylib "aarch64-apple-darwin" "macos-arm64" "$PLATFORM_PKG"
  install_dylib "x86_64-apple-darwin" "macos-x64" "$PLATFORM_PKG"
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
