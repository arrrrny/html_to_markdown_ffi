// Link anchor for the bundled Rust library.
//
// The `htm_*` C symbols live in the `libhtml_to_markdown_ffi` binaryTarget.
// A static archive contributes only the object members the linker actually
// needs, and nothing in the app references `htm_convert` by name, so the
// archive would be dropped from the link. Taking the address of the symbol
// here creates the undefined reference that keeps it.
extern void htm_convert(void);

void (*const html_to_markdown_ffi_link_anchor)(void) = htm_convert;
