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

/// Scenario runner for behavior A4.
///
/// Returns the violations found; an empty list means the scenario holds.
List<String> subject_a4() {
  final violations = <String>[];

  // 1. The html family's envelope IS the shared envelope: the alias and the
  //    shared type are the same type, not two look-alikes.
  if (html_platform.PlatformHtmlToMarkdownFfiEnvelope !=
      shared.PlatformFfiEnvelope) {
    violations.add(
      'The html family envelope is not the shared zuraffa_ffi_platform '
      'envelope.',
    );
  }

  // 2. The family declares no envelope of its own: the alias is a typedef,
  //    not a class declaration.
  const envelopeSource =
      'packages/html_to_markdown_ffi_platform/lib/src/'
      'platform_html_to_markdown_ffi_envelope.dart';
  final source = readText(envelopeSource);
  if (source == null) {
    violations.add('The html family ships no envelope source.');
  } else {
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
  }

  // 3. The shared envelope core is a real dependency, not a vendored copy.
  final constraint = declaredConstraint(
    'html_to_markdown_ffi_platform',
    'zuraffa_ffi_platform',
  );
  if (!constraintAdmits(constraint, '0.2.0')) {
    violations.add(
      'The html platform package does not depend on a shared envelope core '
      'that carries 0.2.0 (constraint: $constraint).',
    );
  }

  return violations;
}
