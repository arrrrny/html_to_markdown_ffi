// HAND-IMPLEMENTED SUBJECT — behavior A2 (zfa:tdd: A2:hand).
//
// behavior_id: A2
// source_criterion: AC-2
// description: the Rust native library is packaged into the app from the Android adapter package's own `jniLibs`, and the consumer's project files contain no reference to the native library.
//
// ignore_for_file: non_constant_identifier_names
library;

import 'dart:io';

import 'family_layout.dart';

/// The Android adapter package the scenario inspects.
const String a2Package = 'html_to_markdown_ffi_android';

/// Scenario runner for behavior A2.
///
/// Returns the violations found; an empty list means the scenario holds.
List<String> subject_a2({RepoLayout? layout}) {
  final repo = layout ?? RepoLayout.repository();

  const jniLibs = 'packages/$a2Package/android/src/main/jniLibs';

  return <String>[
    ...checkAndroidLibraries(
      Directory('${repo.root.path}/$jniLibs'),
      androidAbis,
    ),
    ...checkAndroidGradle(repo.readText('packages/$a2Package/android/build.gradle')),
    ...checkAndroidManifest(
      repo.pathExists('packages/$a2Package/android/src/main/AndroidManifest.xml'),
    ),
    ...checkFfiPluginDeclaration(repo.memberPubspecOrNull(a2Package), 'android'),
    ...checkNoConsumerWiring(repo.consumerWiringFiles()),
  ];
}

/// Every ABI the family claims to support must ship the shared object, and
/// the shared object must be a real ELF carrying the C entry point.
List<String> checkAndroidLibraries(Directory jniLibs, List<String> abis) {
  final violations = <String>[];

  for (final abi in abis) {
    final library =
        File('${jniLibs.path}/$abi/libhtml_to_markdown_ffi.so');
    if (!library.existsSync()) {
      violations.add('The Android adapter ships no library for $abi.');
      continue;
    }
    if (!hasMagic(library, elfMagic)) {
      violations.add('The $abi library is not an ELF shared object.');
    }
    if (!exportsSymbol(library, ffiEntryPoint)) {
      violations.add('The $abi library does not export $ffiEntryPoint.');
    }
  }

  return violations;
}

/// The library module packages its own `jniLibs`, so the consumer's Gradle
/// project never names the native library.
List<String> checkAndroidGradle(String? gradle) {
  final violations = <String>[];

  if (gradle == null) {
    violations.add('The Android adapter ships no Gradle module.');
    return violations;
  }
  if (!gradle.contains('jniLibs.srcDirs')) {
    violations.add('The Android Gradle module packages no `jniLibs`.');
  }

  return violations;
}

/// The Android adapter must ship a manifest, so Gradle packages it.
List<String> checkAndroidManifest(bool exists) {
  if (exists) return const <String>[];
  return <String>['The Android adapter ships no manifest.'];
}
