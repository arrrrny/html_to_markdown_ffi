// Regression guard for issue #13 — a package must declare the builders its own
// `build.yaml` configures.
//
// `packages/html_to_markdown_ffi/build.yaml` configured
// `json_serializable:json_serializable`, but only the workspace root declared
// `json_serializable`. Run from the package directory,
// `dart run build_runner build` therefore answered
//
//   W Ignoring options for unknown builder
//     `json_serializable:json_serializable` in target
//     `html_to_markdown_ffi:html_to_markdown_ffi`.
//
// built nothing for it, and build_runner 2.16+'s "always fix incorrect
// generated files" default DELETED the checked-in
// `lib/src/domain/entities/htm_conversion/htm_conversion.g.dart` — which
// `htm_conversion.dart` still declares as a `part`, so the package stopped
// analyzing and compiling after its own documented codegen step.
//
// The invariant asserted here is resolution, not a hand-kept list: a builder
// key `<package>:<builder>` resolves only when `<package>` is in the resolved
// dependency closure of the package whose `build.yaml` configures it. The
// closure is read from `dart pub deps`, so a builder reached transitively (the
// `zorphy` builder, reached through `zuraffa`) stays legal, while a builder
// that resolves nowhere fails here instead of silently deleting generated
// output at codegen time.
library;

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

/// The workspace root — the nearest ancestor `pubspec.yaml` that declares a
/// `workspace:` section, so the test works whether the suite is started at the
/// root or from a member package.
final repoRoot = _findWorkspaceRoot();

String _findWorkspaceRoot() {
  var dir = Directory.current;
  while (true) {
    final pubspec = File('${dir.path}/pubspec.yaml');
    if (pubspec.existsSync()) {
      final manifest = loadYaml(pubspec.readAsStringSync());
      if (manifest is YamlMap && manifest.containsKey('workspace')) {
        return dir.path;
      }
    }
    final parent = dir.parent;
    if (parent.path == dir.path) {
      fail('no ancestor of ${Directory.current.path} declares a `workspace:`');
    }
    dir = parent;
  }
}

/// Every package `dart pub deps` knows about, keyed by name. The flat list
/// carries each package's resolved `dependencies`, which is what the closure
/// walk below needs.
Map<String, Map<String, dynamic>> _resolvedPackages() {
  final dart = Platform.resolvedExecutable;
  final result = Process.runSync(dart, const [
    'pub',
    'deps',
    '--json',
  ], workingDirectory: repoRoot);
  final stdout = result.stdout.toString();
  if (result.exitCode != 0) {
    // A fresh clone has no resolved `.dart_tool/package_config.json` yet, so
    // `dart pub deps` fails before it can answer — surface the actionable fix
    // rather than the raw non-zero exit.
    fail(
      '`dart pub deps --json` failed (exit ${result.exitCode}) — run '
      '`dart pub get` in $repoRoot first:\n'
      '$stdout\n${result.stderr}',
    );
  }
  final decoded = jsonDecode(stdout) as Map<String, dynamic>;
  final packages = decoded['packages'] as List<dynamic>;
  return {
    for (final entry in packages)
      (entry as Map<String, dynamic>)['name'] as String:
          Map<String, dynamic>.from(entry),
  };
}

/// The resolved dependency closure of [name] — everything reachable from its
/// declared dependencies, transitively.
Set<String> _closureOf(
  String name,
  Map<String, Map<String, dynamic>> packages,
) {
  final entry = packages[name];
  if (entry == null) return <String>{};
  final seen = <String>{};
  final pending = <String>[
    for (final dep in entry['dependencies'] as List<dynamic>) dep as String,
  ];
  while (pending.isNotEmpty) {
    final current = pending.removeLast();
    if (!seen.add(current)) continue;
    final dependency = packages[current];
    if (dependency == null) continue;
    for (final dep in dependency['dependencies'] as List<dynamic>) {
      pending.add(dep as String);
    }
  }
  return seen;
}

/// Every `build.yaml` in the family, keyed by the owning package's declared
/// pubspec `name:` — NOT its directory basename. The caller feeds this key
/// straight into [_closureOf], which looks the package up in the
/// `dart pub deps --json` map keyed by each package's declared `name:`, so the
/// two key spaces must agree. A directory whose basename differs from its
/// `name:` would otherwise resolve an empty closure and report a false
/// "undeclared builder".
Map<String, File> _buildConfigs() {
  final packagesDir = Directory('$repoRoot/packages');
  final configs = <String, File>{};
  for (final entry in packagesDir.listSync()) {
    if (entry is! Directory) continue;
    final build = File('${entry.path}/build.yaml');
    if (!build.existsSync()) continue;
    final pubspec = File('${entry.path}/pubspec.yaml');
    if (!pubspec.existsSync()) continue;
    final manifest = loadYaml(pubspec.readAsStringSync());
    if (manifest is! YamlMap) continue;
    final name = manifest['name'];
    if (name is! String || name.isEmpty) continue;
    configs[name] = build;
  }
  return configs;
}

/// The builder keys a `build.yaml` configures on its default target.
///
/// Scope limit: only the `$default` target's `builders` are inspected. Every
/// `build.yaml` in the family today configures its builders under `$default`,
/// so a builder configured under a *named* target would be silently skipped by
/// this guard — a future named-target config is not covered here.
List<String> _builderKeys(File buildConfig) {
  final config = loadYaml(buildConfig.readAsStringSync());
  if (config is! YamlMap) return const [];
  final targets = config['targets'];
  if (targets is! YamlMap) return const [];
  final defaultTarget = targets['\$default'];
  if (defaultTarget is! YamlMap) return const [];
  final builders = defaultTarget['builders'];
  if (builders is! YamlMap) return const [];
  return [for (final key in builders.keys) key.toString()];
}

void main() {
  test('every builder a package configures in build.yaml is declared by it', () {
    final packages = _resolvedPackages();
    final buildConfigs = _buildConfigs();
    expect(
      buildConfigs,
      isNotEmpty,
      reason: 'no packages/*/build.yaml found under $repoRoot',
    );

    final undeclared = <String>[];
    buildConfigs.forEach((package, buildConfig) {
      final closure = _closureOf(package, packages);
      for (final builder in _builderKeys(buildConfig)) {
        final owner = builder.split(':').first;
        if (!closure.contains(owner)) undeclared.add('$package -> $builder');
      }
    });

    expect(
      undeclared,
      isEmpty,
      reason:
          'these builders are configured by a package that does not '
          'resolve them, so build_runner ignores them and deletes the '
          'generated files they own (issue #13):\n  ${undeclared.join('\n  ')}',
    );
  });
}
