// swift-tools-version: 5.9
import PackageDescription

// Ships the Rust `libhtml_to_markdown_ffi` static archive to macOS apps via
// Flutter's Swift Package Manager support. The archive is linked into a
// dynamic product that Xcode embeds in the app bundle, so the `htm_*` C
// symbols exported by the Rust crate stay reachable from Dart through
// DynamicLibrary.process() without any manual linker-flag wiring in the host
// project.
//
// The product must be dynamic: a static product contributes only the object
// files it compiles itself, and the binary target's archive would be dropped
// from the link because nothing references `htm_convert` by name. The
// `html_to_markdown_ffi_macos_anchor` target supplies that reference, and the
// dynamic product is what gets embedded and loaded at launch.
//
// This is the macOS counterpart of the iOS adapter's identical arrangement:
// the consumer adds the package and the library is in the app.
let package = Package(
    name: "html_to_markdown_ffi_macos",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        // Flutter's Swift Package Manager integration looks the product up
        // by the plugin name with underscores turned into dashes (the
        // product name becomes the CFBundleIdentifier, which cannot contain
        // underscores), so the product must be `html-to-markdown-ffi-macos`.
        .library(
            name: "html-to-markdown-ffi-macos",
            type: .dynamic,
            targets: ["html_to_markdown_ffi_macos"]
        )
    ],
    targets: [
        .target(
            name: "html_to_markdown_ffi_macos_anchor",
            dependencies: [
                "libhtml_to_markdown_ffi",
            ]
        ),
        .target(
            name: "html_to_markdown_ffi_macos",
            dependencies: [
                "html_to_markdown_ffi_macos_anchor",
                "libhtml_to_markdown_ffi",
            ]
        ),
        .binaryTarget(
            name: "libhtml_to_markdown_ffi",
            path: "Frameworks/libhtml_to_markdown_ffi.xcframework"
        ),
    ]
)
