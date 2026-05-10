import 'dart:ffi';

import 'html_to_markdown_bindings.dart';
import 'visitor.dart';

/// Bridges Dart [Visitor] instances to C-compatible function pointers.
///
/// **Status**: Visitor abstract class and test infrastructure are complete.
/// The full NativeCallable bridge to the C VTable is in progress — this stub
/// accepts visitors but delegates to default conversion for the initial release.
///
/// See [Visitor] for the public API developers use to customize conversion.
class VisitorBridge {
  final Visitor visitor;
  bool closed = false;

  VisitorBridge(this.visitor);

  /// Attaches the visitor bridge to the given options.
  void attach(Pointer<HTMConversionOptions> optionsPtr) {
    // Full VTable callback bridge with NativeCallable TBD.
  }

  void close() {
    if (closed) return;
    closed = true;
  }
}
