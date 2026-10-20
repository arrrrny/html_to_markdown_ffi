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

/// The iOS adapter package the scenario inspects.
const String a3Package = 'html_to_markdown_ffi_ios';

/// The macOS adapter package the iOS one must mirror.
const String a3MacosPackage = 'html_to_markdown_ffi_macos';

/// The markers both Swift packages must carry to distribute the native
/// library the same way.
const List<String> a3ParityMarkers = <String>[
  '.binaryTarget(',
  'libhtml_to_markdown_ffi',
  'Frameworks/libhtml_to_markdown_ffi.xcframework',
  'type: .dynamic',
  '_anchor',
];

/// Scenario runner for behavior A3.
///
/// Returns the violations found; an empty list means the scenario holds.
List<String> subject_a3({RepoLayout? layout}) {
  final repo = layout ?? RepoLayout.repository();

  const spmDir = 'packages/$a3Package/ios/$a3Package';
  const macosSpmDir = 'packages/$a3MacosPackage/macos/$a3MacosPackage';
  const xcframework =
      '$spmDir/Frameworks/libhtml_to_markdown_ffi.xcframework';

  final manifest = repo.readText('$spmDir/Package.swift');

  return <String>[
    ...checkIosSwiftPackage(manifest),
    ...checkIosXcframework(Directory('${repo.root.path}/$xcframework')),
    ...checkFfiPluginDeclaration(repo.memberPubspecOrNull(a3Package), 'ios'),
    ...checkSwiftPackageParity(
      manifest,
      repo.readText('$macosSpmDir/Package.swift'),
      a3ParityMarkers,
    ),
  ];
}

/// The iOS adapter's own Swift package must ship a `binaryTarget` over the
/// xcframework that carries the Rust archive, in the shape Flutter's Swift
/// Package Manager integration can actually use: a product named the way
/// Flutter looks it up, a dynamic product, and a link-anchor target that
/// keeps the archive in the link.
List<String> checkIosSwiftPackage(String? manifest) {
  final violations = <String>[];

  if (manifest == null) {
    violations.add('The iOS adapter ships no Swift package manifest.');
    return violations;
  }

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

  final product = swiftProductName(a3Package);
  if (!manifest.contains('name: "$product"')) {
    violations.add('The iOS Swift package declares no product named "$product".');
  }
  if (!manifest.contains('type: .dynamic')) {
    violations.add('The iOS Swift package product is not dynamic.');
  }
  if (!manifest.contains('${a3Package}_anchor')) {
    violations.add('The iOS Swift package ships no link anchor target.');
  }

  return violations;
}

/// The xcframework the binary target points at must be shipped, and it must
/// carry a real static archive that exports the C entry point.
List<String> checkIosXcframework(Directory xcframework) {
  final violations = <String>[];

  if (!xcframework.existsSync()) {
    violations.add('The iOS adapter ships no xcframework.');
    return violations;
  }

  final archives = xcframework
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

  return violations;
}

/// The iOS adapter must use the same distribution shape as the macOS one:
/// Swift package + binaryTarget + xcframework + dynamic product + link
/// anchor + `ffiPlugin: true`.
List<String> checkSwiftPackageParity(
  String? iosManifest,
  String? macosManifest,
  List<String> markers,
) {
  if (iosManifest == null) {
    // The missing iOS manifest is already reported by the iOS check.
    return const <String>[];
  }
  if (macosManifest == null) {
    return <String>['The macOS adapter ships no Swift package manifest.'];
  }

  final violations = <String>[];
  for (final marker in markers) {
    if (!iosManifest.contains(marker)) {
      violations.add(
        'The iOS Swift package differs from the macOS one: $marker',
      );
    }
    if (!macosManifest.contains(marker)) {
      violations.add(
        'The macOS Swift package differs from the iOS one: $marker',
      );
    }
  }

  return violations;
}
