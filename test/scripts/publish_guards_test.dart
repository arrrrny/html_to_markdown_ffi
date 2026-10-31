// Tests for the issue-5 publish guards:
//
// 1. `scripts/prepare_for_publish.sh` must refuse to run when the local
//    master is behind `origin/master` (a stale-master publish is how the
//    1.2.8 release lost the `native_library.dart` restore).
// 2. `scripts/publish.sh` must abort with a non-zero exit when a package's
//    version already exists on pub.dev, instead of continuing to the next
//    package and exiting 0 (that masked the 1.2.8 version collision).
//
// Both scripts resolve their workspace root from their own script location
// (`dirname $0/..`), not from the caller's cwd, so each test copies the
// real `scripts/` into a scratch workspace and runs the COPY — the
// observable behavior (exit status and guard message) is asserted, never
// an implementation detail, and the real checkout is never mutated.
library;

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

final repoRoot = Directory.current.path;

String runSync(
  String executable,
  List<String> args, {
  Directory? cwd,
  Map<String, String> env = const {},
}) {
  final result = Process.runSync(
    executable,
    args,
    workingDirectory: cwd?.path,
    environment: env,
    stdoutEncoding: utf8,
    stderrEncoding: utf8,
  );
  return 'exit=${result.exitCode}\nSTDOUT:\n${result.stdout}\nSTDERR:\n${result.stderr}';
}

String runScript(
  String scriptPath,
  List<String> args, {
  required Directory cwd,
  Map<String, String> env = const {},
}) => runSync('bash', [scriptPath, ...args], cwd: cwd, env: env);

const familyPackages = [
  'html_to_markdown_ffi',
  'html_to_markdown_ffi_flutter',
  'html_to_markdown_ffi_platform',
  'html_to_markdown_ffi_android',
  'html_to_markdown_ffi_ios',
  'html_to_markdown_ffi_macos',
];

/// A minimal workspace the scripts accept: the script's own `scripts/` dir,
/// one `packages/<pkg>/pubspec.yaml` per family member, a root CHANGELOG and
/// a git history. The heavy package sources are not needed — the guards run
/// before any pub command under the stubs.
Directory buildScratchWorkspace({
  required String version,
  required String scriptName,
}) {
  final dir = Directory.systemTemp.createTempSync('issue5-guard-ws-');
  addTearDown(() => dir.deleteSync(recursive: true));

  final scripts = Directory('${dir.path}/scripts')..createSync(recursive: true);
  final src = File('$repoRoot/scripts/$scriptName');
  final script = File('${scripts.path}/$scriptName')
    ..writeAsStringSync(src.readAsStringSync());
  runSync('chmod', ['755', script.path], cwd: dir);

  for (final pkg in familyPackages) {
    Directory('${dir.path}/packages/$pkg').createSync(recursive: true);
    File('${dir.path}/packages/$pkg/pubspec.yaml').writeAsStringSync(
      'name: $pkg\nversion: $version\nresolution: workspace\n',
    );
    File(
      '${dir.path}/packages/$pkg/CHANGELOG.md',
    ).writeAsStringSync('## $version\n\n- initial\n');
  }
  File(
    '${dir.path}/CHANGELOG.md',
  ).writeAsStringSync('## $version\n\n- initial\n');

  void run(List<String> cmd, {Directory? cwd}) {
    final out = runSync(cmd.first, cmd.sublist(1), cwd: cwd ?? dir);
    if (!out.startsWith('exit=0')) {
      throw StateError('${cmd.join(" ")} failed: $out');
    }
  }

  run(['git', 'init', '-b', 'master']);
  run(['git', 'config', 'user.email', 'test@example.com']);
  run(['git', 'config', 'user.name', 'test']);
  run(['git', 'add', '-A']);
  run(['git', 'commit', '-m', 'init']);
  return dir;
}

void gitRun(List<String> cmd, {required Directory cwd}) {
  final out = runSync('git', cmd, cwd: cwd);
  if (!out.startsWith('exit=0')) {
    throw StateError('git ${cmd.join(" ")} failed: $out');
  }
}

/// Gives the workspace a `master` that is BEHIND a newly-created
/// `origin/master` (bare self-clone advanced by one commit), so a
/// `git fetch origin` in the workspace leaves origin/master ahead of the
/// local master's merge-base.
Directory giveScratchAnAheadOrigin(Directory dir) {
  final origin = Directory.systemTemp.createTempSync('issue5-guard-origin-');
  addTearDown(() => origin.deleteSync(recursive: true));
  final clone = Directory.systemTemp.createTempSync('issue5-guard-clone-');
  addTearDown(() => clone.deleteSync(recursive: true));

  final bare = runSync('git', [
    'clone',
    '--bare',
    dir.path,
    origin.path,
  ], cwd: dir.parent);
  if (!bare.startsWith('exit=0')) throw StateError('bare clone failed: $bare');
  final out = runSync('git', [
    'clone',
    origin.path,
    clone.path,
  ], cwd: dir.parent);
  if (!out.startsWith('exit=0')) throw StateError('clone failed: $out');

  final staged = File(
    '${clone.path}/packages/html_to_markdown_ffi/pubspec.yaml',
  );
  staged.writeAsStringSync(
    staged.readAsStringSync().replaceFirst('version: 1.0.0', 'version: 9.9.9'),
  );
  gitRun(['add', '-A'], cwd: clone);
  gitRun(['commit', '-m', 'ahead'], cwd: clone);
  gitRun(['push', 'origin', 'HEAD:master'], cwd: clone);

  gitRun(['remote', 'add', 'origin', origin.path], cwd: dir);
  gitRun(['fetch', 'origin'], cwd: dir);
  return origin;
}

/// Gives the workspace an origin whose master matches the local master, so
/// an up-to-date run is not blocked by an absent origin.
void giveScratchAMatchingOrigin(Directory dir) {
  final origin = Directory.systemTemp.createTempSync('issue5-guard-origin-');
  addTearDown(() => origin.deleteSync(recursive: true));
  final bare = runSync('git', [
    'clone',
    '--bare',
    dir.path,
    origin.path,
  ], cwd: dir.parent);
  if (!bare.startsWith('exit=0')) throw StateError('bare clone failed: $bare');
  gitRun(['remote', 'add', 'origin', origin.path], cwd: dir);
  gitRun(['fetch', 'origin'], cwd: dir);
}

void main() {
  group('prepare_for_publish.sh — stale-master guard (issue 5, AC-1)', () {
    test('refuses to run when local master is behind origin/master', () {
      final repo = buildScratchWorkspace(
        version: '1.0.0',
        scriptName: 'prepare_for_publish.sh',
      );
      giveScratchAnAheadOrigin(repo);
      final out = runScript('${repo.path}/scripts/prepare_for_publish.sh', [
        '1.0.0',
      ], cwd: repo);
      expect(out, contains('exit=1'), reason: out);
      expect(out, contains('behind origin/master'), reason: out);
      expect(out, contains('git pull'), reason: out);
    });

    test('runs normally when master is up to date with origin/master', () {
      final repo = buildScratchWorkspace(
        version: '1.0.0',
        scriptName: 'prepare_for_publish.sh',
      );
      giveScratchAMatchingOrigin(repo);
      final out = runScript('${repo.path}/scripts/prepare_for_publish.sh', [
        '1.0.0',
      ], cwd: repo);
      expect(out, isNot(contains('behind origin/master')), reason: out);
      expect(out, contains('exit=0'), reason: out);
    });
  });

  group('publish.sh — duplicate-version abort (issue 5, AC-2)', () {
    test(
      'aborts non-zero when a package version already exists on pub.dev',
      () {
        final repo = buildScratchWorkspace(
          version: '1.0.0',
          scriptName: 'publish.sh',
        );
        giveScratchAMatchingOrigin(repo);

        // Stub `curl` and `dart` on PATH so publish.sh sees EVERY package's
        // version as already published and never touches the network. The
        // first package must abort the whole run — never `continue` to the
        // next one and exit 0.
        final bin = Directory('${repo.path}/stubbin')
          ..createSync(recursive: true);
        final curl = File('${bin.path}/curl')
          ..writeAsStringSync(
            '#!/bin/sh\n'
            'cat <<"HTTPEOF"\n'
            '{"latest":{"version":"1.0.0"}}\n'
            'HTTPEOF\n',
          );
        final dartStub = File('${bin.path}/dart')
          ..writeAsStringSync('#!/bin/sh\nexit 0\n');
        for (final f in [curl, dartStub]) {
          runSync('chmod', ['755', f.path], cwd: bin);
        }
        final out = runScript(
          '${repo.path}/scripts/publish.sh',
          [],
          cwd: repo,
          env: {'PATH': '${bin.path}:/usr/bin:/bin'},
        );
        expect(out, contains('already on pub.dev'), reason: out);
        expect(out, isNot(contains('exit=0')), reason: out);
      },
    );
  });
}
