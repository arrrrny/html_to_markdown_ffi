# Traceability: 001-zero-touch-native-distribution

Coverage proof for `zfa tdd plan` (bug #846): every FR/AC requirement statement maps to a behavior row or an explicit manual declaration. Verify re-checks the hash — a spec edited after plan is drift (exit 3, re-plan required).

<!-- tdd:traceability
spec-hash: sha256:8eabad4422439c7ee8d37b415f5e175fe48d5cb621842fb2a97d115f21f70cbd
statements: 5
automated: 5
manual: 0
fr-manual: 0
open-gaps: 0
-->

| requirement | line | statement | behavior | status |
| --- | --- | --- | --- | --- |
| AC-1 | 7 | 1. **Given** a consumer app that depends on the `html_to_markdown_ffi` family **When** the app is built for macOS **Then** the Rust native library is linked into the app by the macOS adapter package's own Swift package (a `binaryTarget` over the shipped xcframework), and the consumer's project files contain no reference to the native library. | A1 | automated |
| AC-2 | 9 | 2. **Given** a consumer app that depends on the `html_to_markdown_ffi` family **When** the app is built for Android **Then** the Rust native library is packaged into the app from the Android adapter package's own `jniLibs`, and the consumer's project files contain no reference to the native library. | A2 | automated |
| AC-3 | 11 | 3. **Given** a consumer app that depends on the `html_to_markdown_ffi` family **When** the app is built for iOS **Then** the Rust native library is linked into the app by the iOS adapter package's own Swift package, exactly as the macOS adapter does. | A3 | automated |
| AC-4 | 13 | 4. **Given** a platform adapter package **When** its channel converts a native call **Then** the conversion goes through the shared `zuraffa_ffi_platform` envelope, and the adapter declares no envelope of its own. | A4 | automated |
| AC-5 | 15 | 5. **Given** a fresh clone of the repository **When** the developer resolves the dependencies once at the repository root **Then** all five family packages resolve through one pub workspace on the latest zuraffa release, and every member carries the same release version. | A5 | automated |

