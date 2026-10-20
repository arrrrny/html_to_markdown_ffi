#ifndef HTML_TO_MARKDOWN_FFI_MACOS_ANCHOR_H
#define HTML_TO_MARKDOWN_FFI_MACOS_ANCHOR_H

#ifdef __cplusplus
extern "C" {
#endif

/// Keeps the bundled Rust archive in the link.
extern void (*const html_to_markdown_ffi_link_anchor)(void);

#ifdef __cplusplus
}
#endif

#endif
