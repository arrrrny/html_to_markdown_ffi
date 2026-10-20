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

/// The macOS adapter package the scenario inspects.
const String a1Package = 'html_to_markdown_ffi_macos';

/// Scenario runner for behavior A1.
///
/// Returns the violations found; an empty list means the scenario holds.
List<String> subject_a1({RepoLayout? layout}) {
  final repo = layout ?? RepoLayout.repository();

  const spmDir = 'packages/$a1Package/macos/$a1Package';
  const xcframework = '$spmDir/Frameworks/libhtml_to_markdown_ffi.xcframework';

  return <String>[
    ...checkMacosSwiftPackage(repo.readText('$spmDir/Package.swift')),
    ...checkMacosXcframework(Directory('${repo.root.path}/$xcframework')),
    ...checkFfiPluginDeclaration(repo.memberPubspecOrNull(a1Package), 'macos'),
    ...checkNoConsumerWiring(repo.consumerWiringFiles()),
  ];
}

/// The macOS adapter's own Swift package must ship a `binaryTarget` over the
/// xcframework that carries the Rust archive, and must do it in the shape
/// Flutter's Swift Package Manager integration can actually use:
///
///  * the product is named the way Flutter looks it up — the plugin name
///    with underscores turned into dashes, because the product name becomes
///    the CFBundleIdentifier, which cannot contain underscores;
///  * the product is dynamic, because a static product contributes only the
///    object files it compiles itself and the binary target's archive is
///    dropped from the link;
///  * a link-anchor target references `htm_convert` by name, so the linker
///    keeps the archive.
List<String> checkMacosSwiftPackage(String? manifest) {
  final violations = <String>[];

  if (manifest == null) {
    violations.add('The macOS adapter ships no Swift package manifest.');
    return violations;
  }

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

  final product = swiftProductName(a1Package);
  if (!manifest.contains('name: "$product"')) {
    violations.add('The macOS Swift package declares no product named "$product".');
  }
  if (!manifest.contains('type: .dynamic')) {
    violations.add('The macOS Swift package product is not dynamic.');
  }
  if (!manifest.contains('${a1Package}_anchor')) {
    violations.add('The macOS Swift package ships no link anchor target.');
  }

  return violations;
}

/// The xcframework the binary target points at must be shipped, and it must
/// carry a real static archive that exports the C entry point.
List<String> checkMacosXcframework(Directory xcframework) {
  final violations = <String>[];

  if (!xcframework.existsSync()) {
    violations.add('The macOS adapter ships no xcframework.');
    return violations;
  }

  final archives = xcframework
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

  final info = File('${xcframework.path}/Info.plist');
  if (!info.existsSync() || !info.readAsStringSync().contains('macos')) {
    violations.add('The macOS xcframework declares no macOS library.');
  }

  return violations;
}
