# Changelog

## 1.0.0 (2026-05-10)

- Initial release of the Dart/Flutter bindings for html-to-markdown.
- Core `convert()` function with `dart:ffi` bindings to the Rust engine.
- Full `ConversionOptions` support (43 fields, matching Rust core).
- `ConversionResult` with metadata, tables, images, warnings, and document structure.
- `Visitor` abstract class with 38 element-level callbacks.
- Comprehensive test suite: 76 tests across 9 files (smoke, conversion, options, metadata, result, visitor, edge cases, real-world, structure).
- Platform support: macOS, Linux, Windows, Android, iOS.
- 150-280 MB/s throughput via Rust FFI.
