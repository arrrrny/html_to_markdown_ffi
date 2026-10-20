// HAND-IMPLEMENTED SUBJECT — behavior A4 (zfa:tdd: A4:hand).
//
// behavior_id: A4
// source_criterion: AC-4
// description: the conversion goes through the shared `zuraffa_ffi_platform` envelope, and the adapter declares no envelope of its own.
//
// The scenario reaches the envelope through the public entry points of both
// families, so a family that grows its own envelope again — or that stops
// re-exporting the shared one — fails the scenario.
//
// ignore_for_file: non_constant_identifier_names
library;

import 'package:html_to_markdown_ffi_platform/html_to_markdown_ffi_platform.dart'
    as html_platform;
import 'package:zuraffa_ffi_platform/zuraffa_ffi_platform.dart' as shared;

import 'family_layout.dart';

/// The html family's own platform package.
const String a4Package = 'html_to_markdown_ffi_platform';

/// The shared envelope core the family resolves against.
const String a4SharedPackage = 'zuraffa_ffi_platform';

/// The release of the shared envelope core the family must admit.
const String a4SharedVersion = '0.2.0';

/// Scenario runner for behavior A4.
///
/// Returns the violations found; an empty list means the scenario holds.
List<String> subject_a4({RepoLayout? layout}) {
  final repo = layout ?? RepoLayout.repository();

  const envelopeSource =
      'packages/$a4Package/lib/src/platform_html_to_markdown_ffi_envelope.dart';

  return <String>[
    ...checkSharedEnvelope(
      html_platform.PlatformHtmlToMarkdownFfiEnvelope ==
          shared.PlatformFfiEnvelope,
    ),
    ...checkEnvelopeSource(repo.readText(envelopeSource)),
    ...checkSharedConstraint(
      repo.declaredConstraintOrNull(a4Package, a4SharedPackage),
    ),
  ];
}

/// The html family's envelope must BE the shared envelope: the alias and the
/// shared type are the same type, not two look-alikes.
List<String> checkSharedEnvelope(bool isSharedEnvelope) {
  if (isSharedEnvelope) return const <String>[];
  return <String>[
    'The html family envelope is not the shared zuraffa_ffi_platform '
    'envelope.',
  ];
}

/// The family must declare no envelope of its own: the alias is a typedef,
/// not a class declaration.
List<String> checkEnvelopeSource(String? source) {
  final violations = <String>[];

  if (source == null) {
    violations.add('The html family ships no envelope source.');
    return violations;
  }

  if (source.contains('class PlatformHtmlToMarkdownFfiEnvelope')) {
    violations.add('The html family declares an envelope class of its own.');
  }
  if (!source.contains(
    'typedef PlatformHtmlToMarkdownFfiEnvelope = PlatformFfiEnvelope;',
  )) {
    violations.add(
      'The html family envelope is not an alias of the shared envelope.',
    );
  }

  return violations;
}

/// The shared envelope core must be a real dependency, not a vendored copy.
List<String> checkSharedConstraint(String? constraint) {
  if (constraint == null) {
    return <String>[
      'The html platform package declares no `$a4SharedPackage` dependency.',
    ];
  }
  if (!constraintAdmits(constraint, a4SharedVersion)) {
    return <String>[
      'The html platform package does not depend on a shared envelope core '
      'that carries $a4SharedVersion (constraint: $constraint).',
    ];
  }
  return const <String>[];
}
