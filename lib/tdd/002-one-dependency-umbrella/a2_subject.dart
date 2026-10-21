// HAND-IMPLEMENTED SUBJECT — behavior A2 (zfa:tdd: A2:hand).
//
// behavior_id: A2
// source_criterion: AC-2
// description: the shared platform package and the three adapters come along with it, and no family member depends back on the app-facing package, so the graph stays acyclic.
//
// The scenario reads the family's shipped pubspecs — the real manifest — so
// the check fails the moment a member's dependency edges drift.
//
// The app-facing package is the one a Flutter app declares. The engine
// package behind it is pure Dart, so it brings the shared platform package
// along but not the three adapters — each of those asks for the Flutter
// SDK. The adapters come along through the plugin package instead. What the
// consumer resolves is the closure, so the scenario follows the edges
// transitively.
//
// The [graph] seam lets a test drive the scenario with a deliberately broken
// family, so the failure paths are covered too and not only the happy path.
//
// ignore_for_file: non_constant_identifier_names
library;

import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/family_layout.dart';

import 'family_graph.dart';

/// The package a Flutter app declares.
const String flutterEntryPoint = 'html_to_markdown_ffi_flutter';

/// The family members that must come along with the app-facing package.
const List<String> umbrellaMembers = <String>[
  'html_to_markdown_ffi_platform',
  'html_to_markdown_ffi_android',
  'html_to_markdown_ffi_ios',
  'html_to_markdown_ffi_macos',
];

/// Scenario runner for behavior A2.
///
/// Returns the violations found; an empty list means the scenario holds.
///
/// When [graph] is given it replaces the dependency graph the scenario
/// reads from the shipped pubspecs.
List<String> subject_a2({Map<String, Set<String>>? graph}) {
  final edges = graph ?? readFamilyGraph();
  final violations = <String>[];

  final reached = transitiveDependencies(edges, flutterEntryPoint);
  for (final member in umbrellaMembers) {
    if (!reached.contains(member)) {
      violations.add(
        'The app-facing package does not bring $member along — a consumer of '
        '`$flutterEntryPoint` alone would not get it.',
      );
    }
  }

  for (final package in familyPackages) {
    if (package == flutterEntryPoint) continue;
    final packageEdges = edges[package] ?? const <String>{};
    if (packageEdges.contains(flutterEntryPoint)) {
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
