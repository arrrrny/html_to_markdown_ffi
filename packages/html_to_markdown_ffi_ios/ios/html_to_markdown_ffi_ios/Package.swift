// swift-tools-version: 5.9
import PackageDescription

// Ships the Rust `libhtml_to_markdown_ffi` static archive to iOS apps via
// Flutter's Swift Package Manager support. Xcode force-loads static-archive
// binaryTargets linked into an app target, so the `htm_*` C symbols exported
// by the Rust crate stay reachable from Dart through DynamicLibrary.process()
// without any manual -force_load wiring in the host project.
let package = Package(
    name: "html_to_markdown_ffi_ios",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "html_to_markdown_ffi_ios",
            targets: ["html_to_markdown_ffi_ios"]
        )
    ],
    targets: [
        .target(
            name: "html_to_markdown_ffi_ios",
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
