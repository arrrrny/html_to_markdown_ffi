/// Compatibility library for the pre-migration import path
/// `package:html_to_markdown_ffi/native_library.dart`.
///
/// The spec 064 zuraffa migration moved the loader seam —
/// [HtmNativeLibraries], [HtmNativeLibraryResolver] and [NativeLibrary] —
/// to `html_to_markdown_ffi_platform` and dropped this URI, so a plain
/// `pub upgrade` inside `^1.2.0` broke consumers at analyze time
/// (arrrrny/zuraffa#2020). The seam is unchanged in the platform package;
/// this library restores the original import path for it.
library;

export 'package:html_to_markdown_ffi_platform/native_library.dart';
