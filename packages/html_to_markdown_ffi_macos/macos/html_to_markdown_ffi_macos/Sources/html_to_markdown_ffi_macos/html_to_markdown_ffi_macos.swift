import Foundation

/// Linkage anchor for the bundled Rust library.
///
/// This target has no native API of its own — the `htm_*` C symbols live in
/// the `libhtml_to_markdown_ffi` binaryTarget and are looked up from Dart via
/// `DynamicLibrary.process()`. The archive is kept in the link by the
/// companion `html_to_markdown_ffi_macos_anchor` target, which references `htm_convert` by name.
public enum HtmlToMarkdownFFI {
    /// Version of the bundled native library.
    public static let nativeLibraryVersion = "1.2.3"
}
