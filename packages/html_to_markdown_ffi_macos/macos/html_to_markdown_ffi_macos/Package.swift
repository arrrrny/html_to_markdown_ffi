// swift-tools-version: 5.9
import PackageDescription

// Ships the Rust `libhtml_to_markdown_ffi` static archive to macOS apps via
// Flutter's Swift Package Manager support. Xcode force-loads static-archive
// binaryTargets linked into an app target, so the `htm_*` C symbols exported
// by the Rust crate stay reachable from Dart through DynamicLibrary.process()
// without any manual linker-flag wiring in the host project.
//
// This is the macOS counterpart of the iOS adapter's identical arrangement:
// the consumer adds the package and the library is in the app.
let package = Package(
    name: "html_to_markdown_ffi_macos",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "html_to_markdown_ffi_macos",
            targets: ["html_to_markdown_ffi_macos"]
        )
    ],
    targets: [
        .target(
            name: "html_to_markdown_ffi_macos",
            dependencies: [
                "libhtml_to_markdown_ffi",
            ]
        ),
        .binaryTarget(
            name: "libhtml_to_markdown_ffi",
            path: "Frameworks/libhtml_to_markdown_ffi.xcframework"
        ),
    ]
)
