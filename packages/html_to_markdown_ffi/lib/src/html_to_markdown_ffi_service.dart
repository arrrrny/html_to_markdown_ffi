// html_to_markdown_ffi service — the facade over the conversion stack
// (spec 064). Two paths, one contract:
//   1. adapter path — a registered [HtmlToMarkdownFfiPort] (federated
//      adapters wire their platform transport through the envelope);
//   2. datasource path — the in-package zuraffa data layer
//      (GetHtmConversionUseCase -> HtmConversionRepository ->
//      NativeHtmConversionDataSource) wrapping the preserved dart:ffi
//      bridge directly (FR-004). This is the pre-migration behavior for
//      consumers that never register an adapter.
// Lifecycle mistakes surface as typed [HtmlToMarkdownFfiException]s before
// they reach the platform.
import 'package:zuraffa/zuraffa.dart';

import 'domain/entities/htm_conversion/htm_conversion.dart';
import 'htm_conversion_mapping.dart';
import '../models/conversion_options.dart';
import '../models/conversion_result.dart';
import '../visitor.dart';
import '../native_library.dart';
import 'data/datasources/htm_conversion/native_htm_conversion_datasource.dart';
import 'data/repositories/data_htm_conversion_repository.dart';
import 'domain/repositories/htm_conversion_repository.dart';
import 'domain/usecases/htm_conversion/get_htm_conversion_usecase.dart';
import 'html_to_markdown_ffi_exception.dart';
import 'html_to_markdown_ffi_port.dart';

class HtmlToMarkdownFfiService {
  final HtmlToMarkdownFfiPort? port;
  final HtmConversionRepository _repository;
  final NativeHtmConversionDataSource _nativeDataSource;

  HtmlToMarkdownFfiService({
    this.port,
    HtmConversionRepository? repository,
    NativeHtmConversionDataSource? nativeDataSource,
  })  : _repository = repository ??
            DataHtmConversionRepository(
                nativeDataSource ?? NativeHtmConversionDataSource()),
        _nativeDataSource =
            nativeDataSource ?? NativeHtmConversionDataSource();

  /// The datasource-path service: the preserved in-process bridge.
  factory HtmlToMarkdownFfiService.native() => HtmlToMarkdownFfiService();

  Future<bool> supported() =>
      port?.isSupported() ?? Future.value(_nativeAvailable());

  bool get supportedSync => _nativeAvailable();

  bool _nativeAvailable() {
    try {
      NativeLibrary();
      return true;
    } on StateError {
      return false;
    } on ArgumentError {
      return false;
    }
  }

  /// The preserved public synchronous conversion (FR-006).
  ConversionResult convert(
    String html, {
    ConversionOptions? options,
    Visitor? visitor,
  }) {
    final bound = port;
    if (bound != null) {
      return bound.convertSync(
        id: _nextId(),
        html: html,
        options: options,
        visitor: visitor,
      );
    }
    // Sync public API -> the datasource's synchronous in-process bridge.
    final request = buildConversionRequest(
      html,
      id: _nextId(),
      options: options,
    );
    return toConversionResult(_nativeDataSource.convertNow(
      request,
      visitor: visitor,
    ));
  }

  /// The async conversion path (envelope-wrapped when an adapter is wired).
  Future<ConversionResult> convertAsync(
    String html, {
    ConversionOptions? options,
    Visitor? visitor,
  }) {
    final bound = port;
    if (bound != null) {
      return Future.sync(() => bound.convert(
            id: _nextId(),
            html: html,
            options: options,
            visitor: visitor,
          ));
    }
    return Future.sync(
        () => _convertViaStack(html, options: options, visitor: visitor));
  }

  Future<ConversionResult> _convertViaStack(
    String html, {
    ConversionOptions? options,
    Visitor? visitor,
  }) async {
    final useCase = GetHtmConversionUseCase(_repository);
    final request = buildConversionRequest(
      html,
      id: _nextId(),
      options: options,
    );
    final done = await useCase.execute(
      QueryParams<HtmConversion>(params: {
        'request': request,
        if (visitor != null) 'visitor': visitor,
      }),
      null,
    );
    return toConversionResult(done);
  }

  int _counter = 0;
  String _nextId() => 'htm-${++_counter}';
}

/// A port placeholder registered when no platform adapter was wired:
/// every operation surfaces the typed `port_not_wired` failure instead of
/// a null dereference at resolve time.
class UnwiredHtmlToMarkdownFfiPort implements HtmlToMarkdownFfiPort {
  const UnwiredHtmlToMarkdownFfiPort();

  Never _unwired() => throw const HtmlToMarkdownFfiException(
        'port_not_wired',
        'No HtmlToMarkdownFfiPort was registered — wire the platform adapter '
        'for the running platform before resolving HtmlToMarkdownFfiService.',
        recoverable: false,
      );

  @override
  Future<bool> isSupported() async => _unwired();

  @override
  Future<ConversionResult> convert({
    required String id,
    required String html,
    ConversionOptions? options,
    Visitor? visitor,
  }) =>
      _unwired();

  @override
  ConversionResult convertSync({
    required String id,
    required String html,
    ConversionOptions? options,
    Visitor? visitor,
  }) =>
      _unwired();
}

/// Registers the html_to_markdown_ffi stack onto [getIt]: the
/// [HtmlToMarkdownFfiPort] is normally supplied by the platform adapter
/// package for the running platform (e.g.
/// `registerMacosHtmlToMarkdownFfiDependencies`), so the service falls
/// back to the GetIt-registered port when no explicit one is passed.
/// Without any registered port the service resolves over the datasource
/// path (the preserved in-process bridge).
void registerHtmlToMarkdownFfiDependencies(
  GetIt getIt, {
  HtmlToMarkdownFfiPort? port,
}) {
  getIt.registerLazySingleton<HtmlToMarkdownFfiService>(
    () => HtmlToMarkdownFfiService(
      port:
          port ?? (getIt.isRegistered<HtmlToMarkdownFfiPort>() ? getIt<HtmlToMarkdownFfiPort>() : null),
    ),
  );
}
