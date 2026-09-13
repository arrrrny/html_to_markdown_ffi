import 'html_to_markdown_ffi_exception.dart';

/// A WebAssembly scalar value crossing the platform boundary.
///
/// The scaffold ships the four numeric types; the migration extends the
/// family (reference types, vectors) without breaking the contract.
sealed class HtmlToMarkdownFfiValue {
  const HtmlToMarkdownFfiValue();

  /// Encodes this value into the primitive representation transported over
  /// the platform channel. i64 travels as a decimal string — channel
  /// payloads cannot carry a BigInt losslessly.
  Object encode() => switch (this) {
        HtmlToMarkdownFfiI32(:final value) => value,
        HtmlToMarkdownFfiI64(:final value) => value.toString(),
        HtmlToMarkdownFfiF32(:final value) => value,
        HtmlToMarkdownFfiF64(:final value) => value,
      };

  /// Decodes a channel payload into a [HtmlToMarkdownFfiValue]: ints decode as
  /// i32, doubles as f64, and decimal strings as i64.
  static HtmlToMarkdownFfiValue decode(Object? raw) {
    if (raw is int) return HtmlToMarkdownFfiI32(raw);
    if (raw is double) return HtmlToMarkdownFfiF64(raw);
    if (raw is String) {
      final parsed = BigInt.tryParse(raw);
      if (parsed != null) return HtmlToMarkdownFfiI64(parsed);
    }
    throw HtmlToMarkdownFfiException(
      'malformed_value',
      'Cannot decode "$raw" into a HtmlToMarkdownFfiValue.',
      recoverable: false,
    );
  }
}

/// A 32-bit integer value.
class HtmlToMarkdownFfiI32 extends HtmlToMarkdownFfiValue {
  final int value;

  const HtmlToMarkdownFfiI32(this.value);
}

/// A 64-bit integer value (transported as a decimal string).
class HtmlToMarkdownFfiI64 extends HtmlToMarkdownFfiValue {
  final BigInt value;

  const HtmlToMarkdownFfiI64(this.value);
}

/// A 32-bit float value.
class HtmlToMarkdownFfiF32 extends HtmlToMarkdownFfiValue {
  final double value;

  const HtmlToMarkdownFfiF32(this.value);
}

/// A 64-bit float value.
class HtmlToMarkdownFfiF64 extends HtmlToMarkdownFfiValue {
  final double value;

  const HtmlToMarkdownFfiF64(this.value);
}
