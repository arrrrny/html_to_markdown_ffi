/// A compiled WebAssembly module, bound to [id] inside the owning
/// engine/adapter until unloaded.
class HtmlToMarkdownFfiModule {
  final String id;
  final int byteLength;

  const HtmlToMarkdownFfiModule({required this.id, required this.byteLength});
}
