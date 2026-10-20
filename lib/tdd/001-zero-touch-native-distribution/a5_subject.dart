// HAND-IMPLEMENTED SUBJECT — behavior A5 (zfa:tdd: A5:hand).
//
// behavior_id: A5
// source_criterion: AC-5
// description: all five family packages resolve through one pub workspace on the latest zuraffa release, and every member carries the same release version.
//
// ignore_for_file: non_constant_identifier_names
library;

import 'family_layout.dart';

/// The latest published zuraffa release the family must resolve against.
const String a5LatestZuraffa = '7.2.0';

/// Scenario runner for behavior A5.
///
/// Returns the violations found; an empty list means the scenario holds.
List<String> subject_a5({RepoLayout? layout}) {
  final repo = layout ?? RepoLayout.repository();

  return <String>[
    ...checkWorkspaceRoot(repo.readText('pubspec.yaml')),
    ...checkMemberResolution(repo),
    ...checkZuraffaRelease(repo),
    ...checkReleaseVersions(repo),
  ];
}

/// The repository root must be a pub workspace listing every member, and it
/// must not be publishable.
List<String> checkWorkspaceRoot(String? root) {
  final violations = <String>[];

  if (root == null) {
    violations.add('The repository has no root pubspec.');
    return violations;
  }

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

  return violations;
}

/// Every member must resolve through the workspace.
List<String> checkMemberResolution(RepoLayout repo) {
  final violations = <String>[];

  for (final packageName in familyPackages) {
    final pubspec = repo.memberPubspecOrNull(packageName);
    if (pubspec == null) {
      violations.add('$packageName ships no pubspec.');
      continue;
    }
    if (!RegExp('^resolution:\\s*workspace', multiLine: true)
        .hasMatch(pubspec)) {
      violations.add('$packageName does not resolve through the workspace.');
    }
  }

  return violations;
}

/// Every member must agree on the zuraffa release, and that release must
/// admit the latest published version.
List<String> checkZuraffaRelease(RepoLayout repo) {
  final violations = <String>[];

  String? reference;
  for (final packageName in familyPackages) {
    final constraint = repo.declaredConstraintOrNull(packageName, 'zuraffa');
    if (constraint == null) {
      violations.add('$packageName declares no zuraffa dependency.');
      continue;
    }
    if (!constraintAdmits(constraint, a5LatestZuraffa)) {
      violations.add(
        '$packageName does not admit zuraffa $a5LatestZuraffa '
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

  return violations;
}

/// Every member must carry the same release version.
List<String> checkReleaseVersions(RepoLayout repo) {
  final violations = <String>[];

  String? version;
  for (final packageName in familyPackages) {
    final declared = repo.declaredVersionOrNull(packageName);
    if (declared == null) {
      violations.add('$packageName declares no version.');
      continue;
    }
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
