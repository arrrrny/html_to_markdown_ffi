// Fixture helpers for the `001-zero-touch-native-distribution` scenarios.
//
// The scenarios read the shipped repository tree, so a scenario that must
// report a violation needs a tree that violates it. These helpers build such
// a tree in a temporary directory, so the tests can assert that a scenario
// really notices a broken family.

import 'dart:io';

/// A temporary stand-in for the repository tree.
class Fixture {
  /// The directory that plays the role of the repository root.
  final Directory root;

  Fixture._(this.root);

  /// Creates a fixture in a fresh temporary directory.
  factory Fixture.create() {
    final dir = Directory.systemTemp.createTempSync('htm_zero_touch_fixture');
    return Fixture._(dir);
  }

  /// Removes the temporary directory.
  void dispose() {
    if (root.existsSync()) root.deleteSync(recursive: true);
  }

  /// The file at a repository-relative path.
  File file(String relativePath) => File('${root.path}/$relativePath');

  /// The directory at a repository-relative path.
  Directory directory(String relativePath) =>
      Directory('${root.path}/$relativePath');

  /// Writes [content] to a repository-relative path.
  void write(String relativePath, String content) {
    final target = file(relativePath);
    target.parent.createSync(recursive: true);
    target.writeAsStringSync(content);
  }

  /// Writes [bytes] to a repository-relative path.
  void writeBytes(String relativePath, List<int> bytes) {
    final target = file(relativePath);
    target.parent.createSync(recursive: true);
    target.writeAsBytesSync(bytes);
  }

  /// Deletes a repository-relative path.
  void delete(String relativePath) {
    final target = file(relativePath);
    if (target.existsSync()) target.deleteSync(recursive: true);
  }
}

/// The Swift package manifest a healthy macOS adapter ships.
const String goodMacosManifest = '''
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "html_to_markdown_ffi_macos",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "html-to-markdown-ffi-macos",
            type: .dynamic,
            targets: ["html_to_markdown_ffi_macos"]
        )
    ],
    targets: [
        .target(
            name: "html_to_markdown_ffi_macos_anchor",
            dependencies: [
                "libhtml_to_markdown_ffi",
            ]
        ),
        .target(
            name: "html_to_markdown_ffi_macos",
            dependencies: [
                "html_to_markdown_ffi_macos_anchor",
                "libhtml_to_markdown_ffi",
            ]
        ),
        .binaryTarget(
            name: "libhtml_to_markdown_ffi",
            path: "Frameworks/libhtml_to_markdown_ffi.xcframework"
        ),
    ]
)
''';

/// The Swift package manifest a healthy iOS adapter ships.
const String goodIosManifest = '''
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "html_to_markdown_ffi_ios",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "html-to-markdown-ffi-ios",
            type: .dynamic,
            targets: ["html_to_markdown_ffi_ios"]
        )
    ],
    targets: [
        .target(
            name: "html_to_markdown_ffi_ios_anchor",
            dependencies: [
                "libhtml_to_markdown_ffi",
            ]
        ),
        .target(
            name: "html_to_markdown_ffi_ios",
            dependencies: [
                "html_to_markdown_ffi_ios_anchor",
                "libhtml_to_markdown_ffi",
            ]
        ),
        .binaryTarget(
            name: "libhtml_to_markdown_ffi",
            path: "Frameworks/libhtml_to_markdown_ffi.xcframework"
        ),
    ]
)
''';

/// The envelope source a healthy platform package ships.
const String goodEnvelopeSource = '''
// The channel envelope is shared with the rest of the Zuraffa FFI family
// instead of being re-implemented per family.
import 'package:zuraffa_ffi_platform/zuraffa_ffi_platform.dart';

typedef PlatformHtmlToMarkdownFfiEnvelope = PlatformFfiEnvelope;
''';

/// A minimal static archive that passes the "is a static archive" and
/// "exports htm_convert" checks.
List<int> fakeArchiveBytes({bool exportsEntryPoint = true}) => <int>[
      ...'!<arch>\n'.codeUnits,
      if (exportsEntryPoint) ...'htm_convert htm_convert_with_visitor'.codeUnits,
      ...'other_content'.codeUnits,
    ];

/// A minimal ELF shared object that passes the "is an ELF" and "exports
/// htm_convert" checks.
List<int> fakeElfBytes({bool exportsEntryPoint = true}) => <int>[
      0x7f, 0x45, 0x4c, 0x46, 0x02, 0x01, 0x01, 0x00,
      if (exportsEntryPoint) ...'htm_convert htm_convert_with_visitor'.codeUnits,
      ...'other_content'.codeUnits,
    ];

/// The pubspec a healthy family member ships.
///
/// [ffiPlatform] is the platform whose `ffiPlugin: true` declaration the
/// member carries, or null for a member that declares no platform.
String goodMemberPubspec(
  String name, {
  String version = '1.2.3',
  String zuraffaConstraint = '^7.2.0',
  String? ffiPlatform,
  bool resolvesThroughWorkspace = true,
  bool declaresSharedEnvelope = false,
}) {
  final buffer = StringBuffer()
    ..writeln('name: $name')
    ..writeln('version: $version')
    ..writeln('environment:')
    ..writeln('  sdk: ^3.11.0')
    ..writeln();
  if (resolvesThroughWorkspace) {
    buffer.writeln('resolution: workspace');
    buffer.writeln();
  }
  buffer
    ..writeln('dependencies:')
    ..writeln('  zuraffa: $zuraffaConstraint');
  if (declaresSharedEnvelope) {
    buffer.writeln('  zuraffa_ffi_platform: ^0.2.1');
  }
  if (ffiPlatform != null) {
    buffer
      ..writeln()
      ..writeln('flutter:')
      ..writeln('  plugin:')
      ..writeln('    platforms:')
      ..writeln('      $ffiPlatform:')
      ..writeln('        ffiPlugin: true');
  }
  return buffer.toString();
}

/// The workspace root pubspec a healthy repository ships.
String goodRootPubspec({
  String version = '1.2.3',
  bool publishable = false,
  bool declaresWorkspace = true,
}) {
  final buffer = StringBuffer()
    ..writeln('name: html_to_markdown_ffi_workspace')
    ..writeln('publish_to: ${publishable ? 'any' : 'none'}')
    ..writeln('version: $version')
    ..writeln()
    ..writeln('environment:')
    ..writeln('  sdk: ^3.11.0')
    ..writeln();
  if (declaresWorkspace) {
    buffer.writeln('workspace:');
    for (final packageName in const <String>[
      'html_to_markdown_ffi',
      'html_to_markdown_ffi_platform',
      'html_to_markdown_ffi_android',
      'html_to_markdown_ffi_ios',
      'html_to_markdown_ffi_macos',
    ]) {
      buffer.writeln('  - packages/$packageName');
    }
    buffer.writeln();
  }
  return buffer.toString();
}

/// Builds a healthy family tree in [fixture].
///
/// The result satisfies every check of behaviors A1 to A5, so a test can
/// break exactly one thing and know that the violation it then sees comes
/// from that one thing.
void buildHealthyFamily(Fixture fixture) {
  fixture.write('pubspec.yaml', goodRootPubspec());

  fixture.write(
    'packages/html_to_markdown_ffi/pubspec.yaml',
    goodMemberPubspec('html_to_markdown_ffi'),
  );
  fixture.write(
    'packages/html_to_markdown_ffi_platform/pubspec.yaml',
    goodMemberPubspec(
      'html_to_markdown_ffi_platform',
      declaresSharedEnvelope: true,
    ),
  );
  fixture.write(
    'packages/html_to_markdown_ffi_platform/lib/src/'
    'platform_html_to_markdown_ffi_envelope.dart',
    goodEnvelopeSource,
  );
  fixture.write(
    'packages/html_to_markdown_ffi_android/pubspec.yaml',
    goodMemberPubspec('html_to_markdown_ffi_android', ffiPlatform: 'android'),
  );
  fixture.write(
    'packages/html_to_markdown_ffi_android/android/build.gradle',
    'android {\n'
    '    sourceSets {\n'
    '        jniLibs.srcDirs = ["src/main/jniLibs"]\n'
    '    }\n'
    '}\n',
  );
  fixture.write(
    'packages/html_to_markdown_ffi_android/android/src/main/AndroidManifest.xml',
    '<manifest package="com.example.html_to_markdown_ffi_android" />\n',
  );
  for (final abi in const <String>['arm64-v8a', 'armeabi-v7a', 'x86_64']) {
    fixture.writeBytes(
      'packages/html_to_markdown_ffi_android/android/src/main/jniLibs/'
      '$abi/libhtml_to_markdown_ffi.so',
      fakeElfBytes(),
    );
  }

  fixture.write(
    'packages/html_to_markdown_ffi_ios/pubspec.yaml',
    goodMemberPubspec('html_to_markdown_ffi_ios', ffiPlatform: 'ios'),
  );
  const iosSpm = 'packages/html_to_markdown_ffi_ios/ios/html_to_markdown_ffi_ios';
  fixture.write('$iosSpm/Package.swift', goodIosManifest);
  fixture.writeBytes(
    '$iosSpm/Frameworks/libhtml_to_markdown_ffi.xcframework/'
    'ios-arm64/libhtml_to_markdown_ffi.a',
    fakeArchiveBytes(),
  );
  fixture.write(
    '$iosSpm/Frameworks/libhtml_to_markdown_ffi.xcframework/Info.plist',
    '<plist><dict><key>AvailableLibraries</key><array>'
    '<dict><key>LibraryIdentifier</key><string>ios-arm64</string></dict>'
    '</array></dict></plist>\n',
  );

  fixture.write(
    'packages/html_to_markdown_ffi_macos/pubspec.yaml',
    goodMemberPubspec('html_to_markdown_ffi_macos', ffiPlatform: 'macos'),
  );
  const macosSpm =
      'packages/html_to_markdown_ffi_macos/macos/html_to_markdown_ffi_macos';
  fixture.write('$macosSpm/Package.swift', goodMacosManifest);
  fixture.writeBytes(
    '$macosSpm/Frameworks/libhtml_to_markdown_ffi.xcframework/'
    'macos-arm64/libhtml_to_markdown_ffi.a',
    fakeArchiveBytes(),
  );
  fixture.write(
    '$macosSpm/Frameworks/libhtml_to_markdown_ffi.xcframework/Info.plist',
    '<plist><dict><key>AvailableLibraries</key><array>'
    '<dict><key>LibraryIdentifier</key><string>macos-arm64</string></dict>'
    '</array></dict></plist>\n',
  );
}

/// [source] with the first occurrence of [fragment] removed.
String without(String source, String fragment) {
  final index = source.indexOf(fragment);
  if (index < 0) {
    throw StateError('Fragment not found: $fragment');
  }
  return source.replaceFirst(fragment, '');
}
