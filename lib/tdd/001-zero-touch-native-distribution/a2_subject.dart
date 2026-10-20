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

/// Scenario runner for behavior A2.
///
/// Returns the violations found; an empty list means the scenario holds.
List<String> subject_a2() {
  final violations = <String>[];

  const package = 'html_to_markdown_ffi_android';

  // 1. Every ABI the family claims to support ships the shared object.
  for (final abi in androidAbis) {
    final library = File(
      '${repositoryRoot().path}/packages/$package/android/src/main/jniLibs/'
      '$abi/libhtml_to_markdown_ffi.so',
    );
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

  // 2. The library module packages its own `jniLibs`, so the consumer's
  //    Gradle project never names the native library.
  final gradle = readText('packages/$package/android/build.gradle');
  if (gradle == null) {
    violations.add('The Android adapter ships no Gradle module.');
  } else if (!gradle.contains('jniLibs.srcDirs')) {
    violations.add('The Android Gradle module packages no `jniLibs`.');
  }
  if (!pathExists('packages/$package/android/src/main/AndroidManifest.xml')) {
    violations.add('The Android adapter ships no manifest.');
  }

  // 3. The plugin declares itself an FFI plugin for Android.
  final pubspec = memberPubspec(package);
  if (!RegExp('android:\\s*\n\\s*ffiPlugin:\\s*true').hasMatch(pubspec)) {
    violations.add('The Android adapter does not declare `ffiPlugin: true`.');
  }

  // 4. Nothing in the family asks the consumer to change its own project
  //    files.
  for (final wiring in consumerWiringFiles()) {
    violations.add('The family ships consumer project wiring: $wiring');
  }

  return violations;
}
