// The family's dependency graph, read from the shipped pubspecs.
//
// The graph is the real manifest: every edge is a `html_to_markdown_ffi*`
// entry in a member's `dependencies:` block, so the scenario fails the
// moment a member's dependency edges drift.
library;

import 'dart:convert';

import 'package:html_to_markdown_ffi_workspace/tdd/001-zero-touch-native-distribution/family_layout.dart';

/// The family members that must come along with the app-facing package.
const List<String> umbrellaMembers = <String>[
  'html_to_markdown_ffi_platform',
  'html_to_markdown_ffi_android',
  'html_to_markdown_ffi_ios',
  'html_to_markdown_ffi_macos',
];

/// The family's dependency edges: member -> the family packages it depends
/// on.
Map<String, Set<String>> readFamilyGraph() {
  final graph = <String, Set<String>>{};
  for (final package in familyPackages) {
    graph[package] = familyDependencies(memberPubspec(package));
  }
  return graph;
}

/// The family packages [pubspec] depends on in its `dependencies:` block.
Set<String> familyDependencies(String pubspec) {
  final dependencies = <String>{};
  var inDependencies = false;
  for (final line in const LineSplitter().convert(pubspec)) {
    if (line.startsWith('dependencies:')) {
      inDependencies = true;
      continue;
    }
    if (!inDependencies) continue;
    if (line.trim().isEmpty) continue;
    if (!line.startsWith(' ')) {
      inDependencies = false;
      continue;
    }
    final match = RegExp(r'^ {2}([A-Za-z0-9_]+):').firstMatch(line);
    if (match == null) continue;
    final name = match.group(1)!;
    if (name.startsWith('html_to_markdown_ffi')) dependencies.add(name);
  }
  return dependencies;
}

/// The dependency cycles in [edges], each cycle naming the members it
/// walks through.
List<List<String>> findDependencyCycles(Map<String, Set<String>> edges) {
  final cycles = <List<String>>[];
  final onStack = <String>{};
  final done = <String>{};
  final stack = <String>[];

  void visit(String node) {
    onStack.add(node);
    stack.add(node);
    for (final next in edges[node] ?? const <String>{}) {
      if (!edges.containsKey(next)) continue;
      if (onStack.contains(next)) {
        final start = stack.indexOf(next);
        cycles.add(<String>[...stack.sublist(start), next]);
      } else if (!done.contains(next)) {
        visit(next);
      }
    }
    stack.removeLast();
    onStack.remove(node);
    done.add(node);
  }

  for (final node in edges.keys) {
    if (!done.contains(node)) visit(node);
  }
  return cycles;
}
