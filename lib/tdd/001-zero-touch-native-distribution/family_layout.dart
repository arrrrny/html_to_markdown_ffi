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

/// A view of the tree a scenario inspects.
///
/// The scenarios read the shipped repository, but a scenario that must
/// report a violation needs a tree that violates it. Handing the scenarios
/// a [RepoLayout] over a temporary directory lets the tests build such a
/// tree and assert that the scenario really notices.
class RepoLayout {
  /// The directory that holds the `packages/` folder.
  final Directory root;

  const RepoLayout(this.root);

  /// The shipped repository.
  factory RepoLayout.repository() => RepoLayout(repositoryRoot());

  /// The directory of a family member package.
  Directory packageDir(String packageName) =>
      Directory('${root.path}/packages/$packageName');

  /// Whether a repository-relative path exists.
  bool pathExists(String relativePath) =>
      File('${root.path}/$relativePath').existsSync() ||
      Directory('${root.path}/$relativePath').existsSync();

  /// The raw text of a repository-relative file, or null when it is missing.
  String? readText(String relativePath) {
    final file = File('${root.path}/$relativePath');
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

  /// The raw text of a family member's pubspec, or null when it is missing.
  String? memberPubspecOrNull(String packageName) =>
      readText('packages/$packageName/pubspec.yaml');

  /// The constraint a family member declares for [dependency] (e.g. `zuraffa`).
  String? declaredConstraintOrNull(String packageName, String dependency) {
    final text = memberPubspecOrNull(packageName);
    if (text == null) return null;
    final pattern = RegExp('^\\s*$dependency:\\s*(\\S+)\\s*\$', multiLine: true);
    return pattern.firstMatch(text)?.group(1);
  }

  /// The version a family member declares.
  String? declaredVersionOrNull(String packageName) {
    final text = memberPubspecOrNull(packageName);
    if (text == null) return null;
    final match = RegExp('^version:\\s*(\\S+)\\s*\$', multiLine: true)
        .firstMatch(text);
    return match?.group(1);
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
          found.add(path.substring('${root.path}/'.length));
        }
      }
    }
    return found;
  }
}

/// The directory of a family member package.
Directory packageDir(String packageName) =>
    RepoLayout.repository().packageDir(packageName);

/// Whether a repository-relative path exists.
bool pathExists(String relativePath) =>
    RepoLayout.repository().pathExists(relativePath);

/// The raw text of a repository-relative file, or null when it is missing.
String? readText(String relativePath) => RepoLayout.repository().readText(relativePath);

/// The raw text of a family member's pubspec.
String memberPubspec(String packageName) =>
    RepoLayout.repository().memberPubspec(packageName);

/// The constraint a family member declares for [dependency] (e.g. `zuraffa`).
String declaredConstraint(String packageName, String dependency) {
  final constraint =
      RepoLayout.repository().declaredConstraintOrNull(packageName, dependency);
  if (constraint == null) {
    throw StateError('$packageName declares no `$dependency` dependency.');
  }
  return constraint;
}

/// The version a family member declares.
String declaredVersion(String packageName) {
  final version = RepoLayout.repository().declaredVersionOrNull(packageName);
  if (version == null) {
    throw StateError('$packageName declares no version.');
  }
  return version;
}

/// Whether a caret constraint (e.g. `^7.2.0`) admits [version].
///
/// Pub's caret semantics: the constraint admits every version from the floor
/// up to — but not including — the next release of the first component that
/// is not zero. `^7.2.0` admits `7.9.1` but not `8.0.0`; `^0.2.0` admits
/// `0.2.9` but not `0.3.0`; `^0.0.3` admits only `0.0.3`.
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
  if (floorParts[0] > 0) {
    // A caret constraint never crosses the major version.
    return versionParts[0] == floorParts[0];
  }
  if (floorParts[1] > 0) {
    // In the `0.x` line the caret never crosses the minor version.
    return versionParts[0] == 0 && versionParts[1] == floorParts[1];
  }
  // In the `0.0.x` line the caret never crosses the patch version.
  return versionParts[0] == 0 &&
      versionParts[1] == 0 &&
      versionParts[2] == floorParts[2];
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
List<String> consumerWiringFiles() => RepoLayout.repository().consumerWiringFiles();

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

/// The Swift package product name Flutter's Swift Package Manager
/// integration looks up.
///
/// Flutter resolves a plugin's product by the plugin name with underscores
/// turned into dashes (the product name becomes the CFBundleIdentifier,
/// which cannot contain underscores) — see
/// `flutter_tools/lib/src/macos/swift_package_manager.dart`.
String swiftProductName(String pluginName) =>
    pluginName.replaceAll('_', '-');

/// The platform plugin must declare `ffiPlugin: true`, so Flutter links the
/// native library without any consumer-side wiring.
List<String> checkFfiPluginDeclaration(String? pubspec, String platform) {
  if (pubspec == null) {
    return <String>['The $platform adapter ships no pubspec.'];
  }
  if (!RegExp('$platform:\\s*\n\\s*ffiPlugin:\\s*true').hasMatch(pubspec)) {
    return <String>['The $platform adapter does not declare `ffiPlugin: true`.'];
  }
  return const <String>[];
}

/// Nothing in the family may ask the consumer to change its own project
/// files.
List<String> checkNoConsumerWiring(List<String> wiringFiles) => <String>[
      for (final wiring in wiringFiles)
        'The family ships consumer project wiring: $wiring',
    ];
