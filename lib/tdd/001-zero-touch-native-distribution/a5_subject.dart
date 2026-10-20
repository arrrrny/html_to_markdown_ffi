// HAND-IMPLEMENTED SUBJECT — behavior A5 (zfa:tdd: A5:hand).
//
// behavior_id: A5
// source_criterion: AC-5
// description: all five family packages resolve through one pub workspace on the latest zuraffa release, and every member carries the same release version.
//
// ignore_for_file: non_constant_identifier_names
library;

import 'family_layout.dart';

/// Scenario runner for behavior A5.
///
/// Returns the violations found; an empty list means the scenario holds.
List<String> subject_a5() {
  final violations = <String>[];

  // 1. The repository root is a pub workspace listing every member.
  final root = readText('pubspec.yaml');
  if (root == null) {
    violations.add('The repository has no root pubspec.');
  } else {
    if (!RegExp('^workspace:', multiLine: true).hasMatch(root)) {
      violations.add('The repository root declares no pub workspace.');
    }
    for (final packageName in familyPackages) {
      if (!root.contains('packages/$packageName')) {
        violations.add('The workspace does not list $packageName.');
      }
    }
    if (!RegExp('^publish_to:\\s*none', multiLine: true).hasMatch(root)) {
      violations.add('The workspace root is publishable.');
    }
  }

  // 2. Every member resolves through the workspace.
  for (final packageName in familyPackages) {
    final pubspec = memberPubspec(packageName);
    if (!RegExp('^resolution:\\s*workspace', multiLine: true)
        .hasMatch(pubspec)) {
      violations.add('$packageName does not resolve through the workspace.');
    }
  }

  // 3. Every member agrees on the zuraffa release, and that release admits
  //    the latest published version.
  const latestZuraffa = '7.2.0';
  String? reference;
  for (final packageName in familyPackages) {
    final constraint = declaredConstraint(packageName, 'zuraffa');
    if (!constraintAdmits(constraint, latestZuraffa)) {
      violations.add(
        '$packageName does not admit zuraffa $latestZuraffa '
        '(constraint: $constraint).',
      );
    }
    reference ??= constraint;
    if (constraint != reference) {
      violations.add(
        '$packageName declares a different zuraffa constraint than the rest '
        'of the family ($constraint vs $reference).',
      );
    }
  }

  // 4. Every member carries the same release version.
  String? version;
  for (final packageName in familyPackages) {
    final declared = declaredVersion(packageName);
    version ??= declared;
    if (declared != version) {
      violations.add(
        '$packageName carries version $declared while the family carries '
        '$version.',
      );
    }
  }

  return violations;
}
