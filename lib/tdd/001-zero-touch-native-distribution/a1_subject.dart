// HAND-IMPLEMENTED SUBJECT — behavior A1 (zfa:tdd: A1:hand).
//
// behavior_id: A1
// source_criterion: AC-1
// description: the Rust native library is linked into the app by the macOS adapter package's own Swift package (a `binaryTarget` over the shipped xcframework), and the consumer's project files contain no reference to the native library.
//
// ignore_for_file: non_constant_identifier_names
library;

import 'dart:io';

import 'family_layout.dart';

/// Scenario runner for behavior A1.
///
/// Returns the violations found; an empty list means the scenario holds.
List<String> subject_a1() {
  final violations = <String>[];

  const package = 'html_to_markdown_ffi_macos';
  const spmDir = 'packages/$package/macos/$package';

  // 1. The adapter ships its own Swift package with a binaryTarget over the
  //    xcframework that carries the Rust static archive.
  final manifest = readText('$spmDir/Package.swift');
  if (manifest == null) {
    violations.add('The macOS adapter ships no Swift package manifest.');
  } else {
    if (!manifest.contains('.binaryTarget(')) {
      violations.add('The macOS Swift package declares no binaryTarget.');
    }
    if (!manifest.contains('libhtml_to_markdown_ffi')) {
      violations.add(
        'The macOS Swift package does not reference the native library.',
      );
    }
    if (!manifest.contains('Frameworks/libhtml_to_markdown_ffi.xcframework')) {
      violations.add(
        'The macOS Swift package does not point at the shipped xcframework.',
      );
    }
  }

  // 2. The xcframework the binaryTarget points at is actually shipped, with
  //    a real static archive inside it.
  const xcframework = '$spmDir/Frameworks/libhtml_to_markdown_ffi.xcframework';
  if (!Directory('${repositoryRoot().path}/$xcframework').existsSync()) {
    violations.add('The macOS adapter ships no xcframework.');
  } else {
    final archives = Directory('${repositoryRoot().path}/$xcframework')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.a'))
        .toList();
    if (archives.isEmpty) {
      violations.add('The macOS xcframework carries no static archive.');
    }
    for (final archive in archives) {
      if (!hasMagic(archive, arMagic) && !hasMagic(archive, fatMagic)) {
        violations.add(
          'The macOS xcframework archive ${archive.path} is not a static '
          'archive.',
        );
      }
      if (!exportsSymbol(archive, ffiEntryPoint)) {
        violations.add(
          'The macOS xcframework archive ${archive.path} does not export '
          '$ffiEntryPoint.',
        );
      }
    }
    final info = readText('$xcframework/Info.plist');
    if (info == null || !info.contains('macos')) {
      violations.add('The macOS xcframework declares no macOS library.');
    }
  }

  // 3. The plugin declares itself an FFI plugin for macOS, so Flutter links
  //    the native library without any consumer-side wiring.
  final pubspec = memberPubspec(package);
  if (!RegExp('macos:\\s*\n\\s*ffiPlugin:\\s*true').hasMatch(pubspec)) {
    violations.add('The macOS adapter does not declare `ffiPlugin: true`.');
  }

  // 4. Nothing in the family asks the consumer to change its own project
  //    files.
  for (final wiring in consumerWiringFiles()) {
    violations.add('The family ships consumer project wiring: $wiring');
  }

  return violations;
}
