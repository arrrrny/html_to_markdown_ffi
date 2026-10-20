// HAND-IMPLEMENTED SUBJECT — behavior A3 (zfa:tdd: A3:hand).
//
// behavior_id: A3
// source_criterion: AC-3
// description: the Rust native library is linked into the app by the iOS adapter package's own Swift package, exactly as the macOS adapter does.
//
// ignore_for_file: non_constant_identifier_names
library;

import 'dart:io';

import 'family_layout.dart';

/// Scenario runner for behavior A3.
///
/// Returns the violations found; an empty list means the scenario holds.
List<String> subject_a3() {
  final violations = <String>[];

  const iosPackage = 'html_to_markdown_ffi_ios';
  const macosPackage = 'html_to_markdown_ffi_macos';

  // 1. The iOS adapter ships its own Swift package with a binaryTarget over
  //    the xcframework that carries the Rust static archive.
  final manifest = readText(
    'packages/$iosPackage/ios/$iosPackage/Package.swift',
  );
  if (manifest == null) {
    violations.add('The iOS adapter ships no Swift package manifest.');
  } else {
    if (!manifest.contains('.binaryTarget(')) {
      violations.add('The iOS Swift package declares no binaryTarget.');
    }
    if (!manifest.contains('libhtml_to_markdown_ffi')) {
      violations.add(
        'The iOS Swift package does not reference the native library.',
      );
    }
    if (!manifest.contains('Frameworks/libhtml_to_markdown_ffi.xcframework')) {
      violations.add(
        'The iOS Swift package does not point at the shipped xcframework.',
      );
    }
  }

  // 2. The xcframework the binaryTarget points at is actually shipped.
  const xcframework =
      'packages/$iosPackage/ios/$iosPackage/Frameworks/'
      'libhtml_to_markdown_ffi.xcframework';
  if (!Directory('${repositoryRoot().path}/$xcframework').existsSync()) {
    violations.add('The iOS adapter ships no xcframework.');
  } else {
    final archives = Directory('${repositoryRoot().path}/$xcframework')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.a'))
        .toList();
    if (archives.isEmpty) {
      violations.add('The iOS xcframework carries no static archive.');
    }
    for (final archive in archives) {
      if (!hasMagic(archive, arMagic) && !hasMagic(archive, fatMagic)) {
        violations.add(
          'The iOS xcframework archive ${archive.path} is not a static '
          'archive.',
        );
      }
      if (!exportsSymbol(archive, ffiEntryPoint)) {
        violations.add(
          'The iOS xcframework archive ${archive.path} does not export '
          '$ffiEntryPoint.',
        );
      }
    }
  }

  // 3. The plugin declares itself an FFI plugin for iOS.
  final pubspec = memberPubspec(iosPackage);
  if (!RegExp('ios:\\s*\n\\s*ffiPlugin:\\s*true').hasMatch(pubspec)) {
    violations.add('The iOS adapter does not declare `ffiPlugin: true`.');
  }

  // 4. The iOS adapter uses the same distribution shape as the macOS one:
  //    Swift package + binaryTarget + xcframework + `ffiPlugin: true`.
  final macosManifest = readText(
    'packages/$macosPackage/macos/$macosPackage/Package.swift',
  );
  if (macosManifest == null) {
    violations.add('The macOS adapter ships no Swift package manifest.');
  } else if (manifest == null) {
    // The missing iOS manifest is already reported above.
  } else {
    for (final marker in <String>[
      '.binaryTarget(',
      'libhtml_to_markdown_ffi',
      'Frameworks/libhtml_to_markdown_ffi.xcframework',
    ]) {
      if (!manifest.contains(marker)) {
        violations.add(
          'The iOS Swift package differs from the macOS one: $marker',
        );
      }
      if (!macosManifest.contains(marker)) {
        violations.add('The macOS Swift package differs from the iOS one: $marker');
      }
    }
  }

  return violations;
}
