// HAND-IMPLEMENTED SUBJECT — behavior A2 (zfa:tdd: A2:hand).
//
// behavior_id: A2
// source_criterion: AC-2
// description: the shared platform package and the three adapters come along with it, and no family member depends back on the app-facing package, so the graph stays acyclic.
//
// The scenario reads the family's shipped pubspecs — the real manifest — so
// the check fails the moment a member's dependency edges drift.
//
// The [graph] seam lets a test drive the scenario with a deliberately broken
// family, so the failure paths are covered too and not only the happy path.
//
// ignore_for_file: non_constant_identifier_names
library;

import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/family_layout.dart';

import 'family_graph.dart';

/// Scenario runner for behavior A2.
///
/// Returns the violations found; an empty list means the scenario holds.
///
/// When [graph] is given it replaces the dependency graph the scenario
/// reads from the shipped pubspecs.
List<String> subject_a2({Map<String, Set<String>>? graph}) {
  final edges = graph ?? readFamilyGraph();
  final violations = <String>[];

  final appEdges = edges['html_to_markdown_ffi'] ?? const <String>{};
  for (final member in umbrellaMembers) {
    if (!appEdges.contains(member)) {
      violations.add(
        'The app-facing package does not depend on $member — a consumer of '
        '`html_to_markdown_ffi` alone would not get it.',
      );
    }
  }

  for (final package in familyPackages) {
    if (package == 'html_to_markdown_ffi') continue;
    final packageEdges = edges[package] ?? const <String>{};
    if (packageEdges.contains('html_to_markdown_ffi')) {
      violations.add(
        '$package depends back on the app-facing package — the graph would '
        'be cyclic.',
      );
    }
  }

  for (final cycle in findDependencyCycles(edges)) {
    violations.add(
      'The family dependency graph is cyclic: ${cycle.join(' -> ')}.',
    );
  }

  return violations;
}
