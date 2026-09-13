import 'dart:typed_data';

import 'package:zuraffa/zuraffa.dart';

import 'html_to_markdown_ffi_exception.dart';
import 'html_to_markdown_ffi_module.dart';
import 'html_to_markdown_ffi_port.dart';
import 'html_to_markdown_ffi_value.dart';

/// Facade over the [HtmlToMarkdownFfiPort]: owns the compiled-module registry
/// and turns lifecycle mistakes (double compile, call-before-compile)
/// into typed failures before they reach the platform.
class HtmlToMarkdownFfiService {
  final HtmlToMarkdownFfiPort port;
  final Map<String, HtmlToMarkdownFfiModule> _modules = {};

  HtmlToMarkdownFfiService({required this.port});

  /// The compiled modules currently held by this service.
  Set<String> get compiledModules => Set.unmodifiable(_modules.keys);

  Future<bool> supported() => port.isSupported();

  Future<HtmlToMarkdownFfiModule> compile({
    required String id,
    required Uint8List bytes,
  }) async {
    if (_modules.containsKey(id)) {
      throw HtmlToMarkdownFfiException(
        'already_compiled',
        'Module "$id" is already compiled — unload it first.',
        recoverable: false,
      );
    }
    final module = await port.compile(id: id, bytes: bytes);
    _modules[id] = module;
    return module;
  }

  Future<List<HtmlToMarkdownFfiValue>> call({
    required String id,
    required String export,
    List<HtmlToMarkdownFfiValue> args = const [],
  }) async {
    _requireCompiled(id);
    return port.invoke(id: id, export: export, args: args);
  }

  Future<void> unload({required String id}) async {
    _requireCompiled(id);
    await port.unload(id: id);
    _modules.remove(id);
  }

  void _requireCompiled(String id) {
    if (!_modules.containsKey(id)) {
      throw HtmlToMarkdownFfiException(
        'not_compiled',
        'Module "$id" is not compiled — call compile() first.',
        recoverable: false,
      );
    }
  }
}

/// A port placeholder registered when no platform adapter was wired:
/// every operation surfaces the typed `port_not_wired` failure instead of
/// a null dereference at resolve time.
class _UnwiredHtmlToMarkdownFfiPort implements HtmlToMarkdownFfiPort {
  const _UnwiredHtmlToMarkdownFfiPort();

  Never _unwired() => throw const HtmlToMarkdownFfiException(
        'port_not_wired',
        'No HtmlToMarkdownFfiPort was registered — wire the platform adapter '
        'for the running platform before resolving HtmlToMarkdownFfiService.',
        recoverable: false,
      );

  @override
  Future<bool> isSupported() async => _unwired();

  @override
  Future<HtmlToMarkdownFfiModule> compile({
    required String id,
    required Uint8List bytes,
  }) =>
      _unwired();

  @override
  Future<List<HtmlToMarkdownFfiValue>> invoke({
    required String id,
    required String export,
    List<HtmlToMarkdownFfiValue> args = const [],
  }) =>
      _unwired();

  @override
  Future<void> unload({required String id}) => _unwired();
}

/// Registers the html_to_markdown_ffi stack onto [getIt]: the [HtmlToMarkdownFfiPort] is
/// normally supplied by the platform adapter package for the running
/// platform (e.g. `registerAndroidHtmlToMarkdownFfiDependencies`), so the
/// service falls back to the GetIt-registered port when no explicit one
/// is passed. Without any registered port the service resolves over the
/// unwired placeholder and surfaces typed `port_not_wired` failures.
void registerHtmlToMarkdownFfiDependencies(
  GetIt getIt, {
  HtmlToMarkdownFfiPort? port,
}) {
  getIt.registerLazySingleton<HtmlToMarkdownFfiService>(
    () => HtmlToMarkdownFfiService(
      port:
          port ??
          (getIt.isRegistered<HtmlToMarkdownFfiPort>()
              ? getIt<HtmlToMarkdownFfiPort>()
              : const _UnwiredHtmlToMarkdownFfiPort()),
    ),
  );
}
