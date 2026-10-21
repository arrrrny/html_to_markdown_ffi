**Template Version**: `zuraffa-1.0`

# Spec: 001-zero-touch-native-distribution

## Acceptance Scenarios

1. **Given** a consumer app that depends on the `html_to_markdown_ffi` family **When** the app is built for macOS **Then** the Rust native library is linked into the app by the macOS adapter package's own Swift package (a `binaryTarget` over the shipped xcframework), and the consumer's project files contain no reference to the native library.
   **Type**: acceptance
2. **Given** a consumer app that depends on the `html_to_markdown_ffi` family **When** the app is built for Android **Then** the Rust native library is packaged into the app from the Android adapter package's own `jniLibs`, and the consumer's project files contain no reference to the native library.
   **Type**: acceptance
3. **Given** a consumer app that depends on the `html_to_markdown_ffi` family **When** the app is built for iOS **Then** the Rust native library is linked into the app by the iOS adapter package's own Swift package, exactly as the macOS adapter does.
   **Type**: acceptance
4. **Given** a platform adapter package **When** its channel converts a native call **Then** the conversion goes through the shared `zuraffa_ffi_platform` envelope, and the adapter declares no envelope of its own.
   **Type**: acceptance
5. **Given** a fresh clone of the repository **When** the developer resolves the dependencies once at the repository root **Then** all six family packages resolve through one pub workspace on the latest zuraffa release, and every member carries the same release version.
   **Type**: acceptance
