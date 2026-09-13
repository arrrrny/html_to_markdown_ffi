// ignore_for_file: type=lint
// Manual Dart FFI bindings for html_to_markdown C library.
// Generated from html_to_markdown.h (alef auto-generated header).

import 'dart:ffi';
import 'package:ffi/ffi.dart';

final class HTMConversionOptions extends Opaque {}
final class HTMConversionResult extends Opaque {}
final class HTMHtmVisitor extends Opaque {}
final class HTMHtmHtmlVisitorBridge extends Opaque {}

/// Context struct passed to visitor callbacks.
final class HTMHtmNodeContext extends Struct {
  @Int32()
  external int nodeType;

  external Pointer<Utf8> tagName;

  @IntPtr()
  external int depth;

  @IntPtr()
  external int indexInParent;

  external Pointer<Utf8> parentTag;

  @Int32()
  external int isInline;
}

/// Simplified VTable for visitor callbacks (JSON context, single out-result).
/// This is the preferred visitor interface for language bindings.
final class HTMHtmHtmlVisitorVTable extends Struct {
  external Pointer<
      NativeFunction<
          Int32 Function(Pointer<Void>, Pointer<Utf8>, Pointer<Pointer<Utf8>>)>>
      visitElementStart;

  external Pointer<
      NativeFunction<
          Int32 Function(
              Pointer<Void>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Pointer<Utf8>>)>>
      visitElementEnd;

  external Pointer<
      NativeFunction<
          Int32 Function(Pointer<Void>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Pointer<Utf8>>)>>
      visitText;

  external Pointer<
      NativeFunction<
          Int32 Function(Pointer<Void>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Pointer<Utf8>>)>>
      visitLink;

  external Pointer<
      NativeFunction<
          Int32 Function(Pointer<Void>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Pointer<Pointer<Utf8>>)>>
      visitImage;
}
