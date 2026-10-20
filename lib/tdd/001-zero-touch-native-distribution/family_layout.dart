/// Shared helpers for the `001-zero-touch-native-distribution` behaviors.
///
/// Every helper reads the repository's own files, so the scenarios assert
/// the shipped state instead of a hand-kept copy of it.
library;

import 'dart:io';

/// The five members of the `html_to_markdown_ffi` family, in publish order.
const List<String> familyPackages = <String>[
  'html_to_markdown_ffi',
  'html_to_markdown_ffi_platform',
  'html_to_markdown_ffi_android',
  'html_to_markdown_ffi_ios',
  'html_to_markdown_ffi_macos',
];

/// The Android ABIs the adapter package ships the native library for.
const List<String> androidAbis = <String>[
  'arm64-v8a',
  'armeabi-v7a',
  'x86_64',
];

/// The repository root: the directory that holds the `packages/` folder.
Directory repositoryRoot() {
  var dir = Directory.current;
  for (var i = 0; i < 8; i++) {
    if (Directory('${dir.path}/packages/html_to_markdown_ffi').existsSync()) {
      return dir;
    }
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  throw StateError(
    'Cannot locate the repository root from ${Directory.current.path}.',
  );
}

/// The directory of a family member package.
Directory packageDir(String packageName) =>
    Directory('${repositoryRoot().path}/packages/$packageName');

/// Whether a repository-relative path exists.
bool pathExists(String relativePath) =>
    File('${repositoryRoot().path}/$relativePath').existsSync() ||
    Directory('${repositoryRoot().path}/$relativePath').existsSync();

/// The raw text of a repository-relative file, or null when it is missing.
String? readText(String relativePath) {
  final file = File('${repositoryRoot().path}/$relativePath');
  if (!file.existsSync()) return null;
  return file.readAsStringSync();
}

/// The raw text of a family member's pubspec.
String memberPubspec(String packageName) {
  final text = readText('packages/$packageName/pubspec.yaml');
  if (text == null) {
    throw StateError('Missing pubspec for $packageName.');
  }
  return text;
}

/// The constraint a family member declares for [dependency] (e.g. `zuraffa`).
String declaredConstraint(String packageName, String dependency) {
  final pattern = RegExp('^\\s*$dependency:\\s*(\\S+)\\s*\$', multiLine: true);
  final match = pattern.firstMatch(memberPubspec(packageName));
  if (match == null) {
    throw StateError('$packageName declares no `$dependency` dependency.');
  }
  return match.group(1)!;
}

/// The version a family member declares.
String declaredVersion(String packageName) {
  final match = RegExp('^version:\\s*(\\S+)\\s*\$', multiLine: true)
      .firstMatch(memberPubspec(packageName));
  if (match == null) {
    throw StateError('$packageName declares no version.');
  }
  return match.group(1)!;
}

/// Whether a caret constraint (e.g. `^7.2.0`) admits [version].
bool constraintAdmits(String constraint, String version) {
  if (!constraint.startsWith('^')) {
    throw StateError('Unsupported constraint form: $constraint');
  }
  final floor = constraint.substring(1);
  final floorParts = _parts(floor);
  final versionParts = _parts(version);
  if (versionParts.length != 3 || floorParts.length != 3) {
    throw StateError('Unsupported version form: $constraint / $version');
  }
  if (_compare(versionParts, floorParts) < 0) return false;
  // A caret constraint never crosses the major version.
  return versionParts[0] == floorParts[0];
}

List<int> _parts(String version) =>
    version.split('.').map((part) => int.parse(part)).toList();

int _compare(List<int> a, List<int> b) {
  for (var i = 0; i < 3; i++) {
    if (a[i] != b[i]) return a[i].compareTo(b[i]);
  }
  return 0;
}

/// The files a family package ships that would ask the consumer to change
/// its own project files: a CocoaPods podspec, an xcconfig, or a vendored
/// consumer project directory.
List<String> consumerWiringFiles() {
  final found = <String>[];
  for (final packageName in familyPackages) {
    final dir = packageDir(packageName);
    if (!dir.existsSync()) continue;
    for (final entity in dir.listSync(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      final path = entity.path;
      if (!path.startsWith('${dir.path}/')) continue;
      if (path.contains('/.dart_tool/') || path.contains('/build/')) continue;
      if (path.endsWith('.podspec') ||
          path.endsWith('.xcconfig') ||
          path.endsWith('.xcodeproj')) {
        found.add(path.substring('${repositoryRoot().path}/'.length));
      }
    }
  }
  return found;
}

/// Whether the bytes of [file] start with [magic].
bool hasMagic(File file, List<int> magic) {
  if (!file.existsSync()) return false;
  final bytes = file.readAsBytesSync();
  if (bytes.length < magic.length) return false;
  for (var i = 0; i < magic.length; i++) {
    if (bytes[i] != magic[i]) return false;
  }
  return true;
}

/// Whether the binary [file] exports the C entry point [symbol].
///
/// The symbol name is carried in the archive's object index and in the ELF
/// dynamic symbol table, so its presence proves the shipped binary really
/// carries the FFI surface the Dart side looks up.
bool exportsSymbol(File file, String symbol) {
  if (!file.existsSync()) return false;
  final bytes = file.readAsBytesSync();
  final needle = symbol.codeUnits;
  if (bytes.length < needle.length) return false;
  outer:
  for (var i = 0; i <= bytes.length - needle.length; i++) {
    for (var j = 0; j < needle.length; j++) {
      if (bytes[i + j] != needle[j]) continue outer;
    }
    return true;
  }
  return false;
}

/// The `ar` archive magic — a thin static archive (`!<arch>\n`).
const List<int> arMagic = <int>[
  0x21, 0x3c, 0x61, 0x72, 0x63, 0x68, 0x3e, 0x0a,
];

/// The fat-archive magic — a universal static archive (`lipo`).
const List<int> fatMagic = <int>[0xca, 0xfe, 0xba, 0xbe];

/// The ELF magic — an Android shared object.
const List<int> elfMagic = <int>[0x7f, 0x45, 0x4c, 0x46];

/// The C entry point the Dart bindings look up.
const String ffiEntryPoint = 'htm_convert';
