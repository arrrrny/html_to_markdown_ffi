// HAND-IMPLEMENTED SUBJECT — behavior A1 (zfa:tdd: A1:hand).
//
// behavior_id: A1
// source_criterion: AC-1
// description: the shared conversion contract and all three platform adapters — the Android, iOS, and macOS registration helpers — are reachable from that one entry point.
//
// The scenario imports the family through its public entry point
// (`package:html_to_markdown_ffi/html_to_markdown_ffi.dart`) and uses every
// part of it, so a symbol that stops being exported breaks the scenario at
// compile time.
//
// The scenario observes the entry point through an [UmbrellaProbe] and turns
// the observation into violations. Both steps are injectable, so a test can
// drive the scenario with a broken entry point and the failure paths are
// covered too — not only the happy path.
//
// ignore_for_file: non_constant_identifier_names
library;

import 'package:html_to_markdown_ffi/html_to_markdown_ffi.dart';
import 'package:zuraffa/zuraffa.dart';

/// A minimal port: the scenario only proves the contract is reachable, not
/// that a conversion succeeds.
class EchoPort implements HtmlToMarkdownFfiPort {
  const EchoPort();

  @override
  Future<bool> isSupported() async => true;

  @override
  Future<ConversionResult> convert({
    required String id,
    required String html,
    ConversionOptions? options,
    Visitor? visitor,
  }) async =>
      ConversionResult(content: html);

  @override
  ConversionResult convertSync({
    required String id,
    required String html,
    ConversionOptions? options,
    Visitor? visitor,
  }) =>
      ConversionResult(content: html);
}

/// The parts the scenario proves reachable through the app-facing entry
/// point.
const List<String> umbrellaParts = <String>[
  'HtmlToMarkdownFfiPort',
  'HtmlToMarkdownFfiService',
  'ConversionResult',
  'registerHtmlToMarkdownFfiDependencies',
  'registerAndroidHtmlToMarkdownFfiDependencies',
  'registerIosHtmlToMarkdownFfiDependencies',
  'registerMacosHtmlToMarkdownFfiDependencies',
  'MacosHtmlToMarkdownFfiChannel',
];

/// Exercises one part of the entry point and reports the failure, if any.
typedef PartRunner = String? Function();

/// What the scenario observed about the app-facing entry point.
class UmbrellaProbe {
  const UmbrellaProbe({this.errors = const <String, String>{}});

  /// The failure raised per part, keyed by the part's name. A part that is
  /// missing from the map behaved as expected.
  final Map<String, String> errors;
}

/// Observes the app-facing entry point.
///
/// Every part is injectable so a test can make the entry point fail and the
/// scenario can report that failure.
UmbrellaProbe probeUmbrella({Map<String, PartRunner>? runners}) {
  final parts = runners ?? defaultUmbrellaRunners();
  final errors = <String, String>{};
  for (final part in umbrellaParts) {
    final runner = parts[part];
    if (runner == null) {
      errors[part] = 'the entry point does not expose it.';
      continue;
    }
    try {
      final failure = runner();
      if (failure != null) errors[part] = failure;
    } on Object catch (error) {
      errors[part] = '$error';
    }
  }
  return UmbrellaProbe(errors: errors);
}

/// The runners that use the real symbols of the app-facing entry point.
Map<String, PartRunner> defaultUmbrellaRunners() {
  return <String, PartRunner>{
    'HtmlToMarkdownFfiPort': () {
      const port = EchoPort();
      final HtmlToMarkdownFfiPort typed = port;
      final result = typed.convertSync(id: 'probe', html: 'probe');
      return result.content == 'probe'
          ? null
          : 'the port does not convert through the contract.';
    },
    'HtmlToMarkdownFfiService': () {
      const port = EchoPort();
      final service = HtmlToMarkdownFfiService(port: port);
      return identical(service.port, port)
          ? null
          : 'the service does not carry the port it was given.';
    },
    'ConversionResult': () {
      const result = ConversionResult(content: 'probe');
      return result.content == 'probe'
          ? null
          : 'the result does not carry its content.';
    },
    'registerHtmlToMarkdownFfiDependencies': () {
      final getIt = GetIt.asNewInstance();
      registerHtmlToMarkdownFfiDependencies(getIt);
      return getIt.isRegistered<HtmlToMarkdownFfiService>()
          ? null
          : 'the service was not registered.';
    },
    'registerAndroidHtmlToMarkdownFfiDependencies': () {
      final getIt = GetIt.asNewInstance();
      registerAndroidHtmlToMarkdownFfiDependencies(getIt);
      return getIt.isRegistered<HtmlToMarkdownFfiPort>()
          ? null
          : 'the port was not registered.';
    },
    'registerIosHtmlToMarkdownFfiDependencies': () {
      final getIt = GetIt.asNewInstance();
      registerIosHtmlToMarkdownFfiDependencies(getIt);
      return getIt.isRegistered<HtmlToMarkdownFfiPort>()
          ? null
          : 'the port was not registered.';
    },
    'registerMacosHtmlToMarkdownFfiDependencies': () {
      final getIt = GetIt.asNewInstance();
      registerMacosHtmlToMarkdownFfiDependencies(getIt);
      return getIt.isRegistered<HtmlToMarkdownFfiPort>()
          ? null
          : 'the port was not registered.';
    },
    'MacosHtmlToMarkdownFfiChannel': () {
      final channel = MacosHtmlToMarkdownFfiChannel(
        invoke: (method, args) async =>
            const <String, Object?>{'supported': true},
      );
      final transport = channel.invoke('isSupported', const <String, Object?>{});
      if (transport is! Future) {
        return 'the channel does not carry the injected transport.';
      }
      if (channel.timeout != const Duration(seconds: 30)) {
        return 'the channel does not carry its default timeout.';
      }
      return null;
    },
  };
}

/// Scenario runner for behavior A1.
///
/// Returns the violations found; an empty list means the scenario holds.
///
/// When [probe] is given it replaces the observation the scenario makes
/// about the app-facing entry point.
List<String> subject_a1({UmbrellaProbe? probe}) {
  final observed = probe ?? probeUmbrella();

  return <String>[
    for (final part in umbrellaParts)
      if (observed.errors.containsKey(part))
        '$part is not reachable from the app-facing entry point: '
            '${observed.errors[part]}',
  ];
}
