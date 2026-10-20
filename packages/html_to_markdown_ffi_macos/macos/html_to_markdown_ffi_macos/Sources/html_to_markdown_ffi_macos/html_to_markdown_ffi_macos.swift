import Foundation

/// Linkage anchor for the bundled Rust static archive.
///
/// This target has no native API of its own — the `htm_*` C symbols live in
/// the `libhtml_to_markdown_ffi` binaryTarget and are looked up from Dart via
/// `DynamicLibrary.process()`. The target exists so the archive is linked
/// into the app bundle's binary.
public enum HtmlToMarkdownFFI {
    /// Version of the bundled native library.
    public static let nativeLibraryVersion = "1.2.3"
}
