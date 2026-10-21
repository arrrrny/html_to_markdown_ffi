# Cycle Log

Append only. Newest last. Every entry's `red` block is the evidence that the test existed and failed before the implementation.

## Cycle: A1 (red)

- behavior: A1
- kind: red
- classification: assertionFailure
- evidence: A1 (AC-1) A1 — the resolution succeeds — the package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency, and it depends on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.
- subject-hash: 1e2b62b9fa1049bcf5bd1e8d3b88f1d287abd7531024957be7e69bca0eea67e4
- criterion: AC-1
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart --plain-name "the resolution succeeds — the package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency, and it depends on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change."`
- exit: 1
- at: 2026-10-21T19:22:25.718729Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:08 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:09 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:10 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:11 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:12 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:13 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:14 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:15 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:16 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:17 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:18 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:19 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:20 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:21 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:22 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:23 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:24 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:25 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:26 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:27 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:28 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:29 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:30 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:31 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:32 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:33 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:34 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:35 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:36 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:37 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:38 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:39 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:40 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:41 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:42 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:43 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:44 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:45 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:46 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:47 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:48 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:49 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:50 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:51 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:52 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:53 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:54 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:55 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:56 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:57 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:58 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:59 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:08 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:09 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:10 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:11 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:12 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:13 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:14 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:15 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:16 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:17 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:18 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:18 +0: A1 ... on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.    
01:19 +0: A1 ... on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.    
01:19 +0 -1: A1 (AC-1) A1 — the resolution succeeds — the package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency, and it depends on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change. [E]
  Expected: not <Instance of 'UnimplementedError'>
    Actual: UnimplementedError:<UnimplementedError: subject_a1 not implemented>
  
  package:matcher                                     expect
  test/tdd/004-pure-dart-umbrella/a1_test.dart 112:7  main.<fn>.<fn>
  

To run this test again: /usr/local/share/flutter/bin/cache/dart-sdk/bin/dart test /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart -p vm --plain-name 'A1 (AC-1) A1 — the resolution succeeds — the package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency, and it depends on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.'

01:20 +0 -1: Some tests failed.                                                                                                                                                                        

Consider enabling the flag chain-stack-traces to receive more detailed exceptions.
For example, 'dart test --chain-stack-traces'.
```

- schema: 1
- prev-hash: genesis
- hash: ff833529b69826480cc7bf8481940dfebfe9989d8e652dbcb2ef48c66a240f79

## Cycle: A2 (red)

- behavior: A2
- kind: red
- classification: assertionFailure
- evidence: A2 (AC-2) A2 — that package names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, carries the Flutter SDK constraint that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library.
- subject-hash: 8054fa95f78619978dddfbab98ac57a4dc1cd35cdedd97c78584d9a8cbb893cf
- criterion: AC-2
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart --plain-name "that package names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, carries the Flutter SDK constraint that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library."`
- exit: 1
- at: 2026-10-21T19:23:02.774532Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:08 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:09 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:10 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:11 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:12 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:13 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:14 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:15 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:16 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:17 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:18 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:19 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:20 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:21 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:22 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:22 +0: A2 ... that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library.
00:23 +0 -1: A2 ... a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library.  
00:23 +0 -1: A2 (AC-2) A2 — that package names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, carries the Flutter SDK constraint that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library. [E]
  Expected: not <Instance of 'UnimplementedError'>
    Actual: UnimplementedError:<UnimplementedError: subject_a2 not implemented>
  
  package:matcher                                     expect
  test/tdd/004-pure-dart-umbrella/a2_test.dart 156:7  main.<fn>.<fn>
  

To run this test again: /usr/local/share/flutter/bin/cache/dart-sdk/bin/dart test /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart -p vm --plain-name 'A2 (AC-2) A2 — that package names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, carries the Flutter SDK constraint that a plugin manifest requires, and re-exports the app-facing package'\''s public API — so one dependency still gives the consumer both the conversion and the linked-in native library.'

00:23 +0 -1: Some tests failed.                                                                                                                                                                        

Consider enabling the flag chain-stack-traces to receive more detailed exceptions.
For example, 'dart test --chain-stack-traces'.
```

- schema: 1
- prev-hash: genesis
- hash: cc7e8209597108b75b6b7ad76220278909eed814e7a11ca2ea24ebd3e23d4851

## Cycle: A1 (green)

- behavior: A1
- kind: green
- evidence: issue #1162 re-certification — the subject was hand-implemented after the certified red; this green evidence binds the NEW subject shape with the passing transcript
- subject-hash: 26268694f48fc904c498313a6714fc871a6e60320da6c05d0bdfe91ccfdabd5d
- criterion: AC-1
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart --plain-name "the resolution succeeds — the package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency, and it depends on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change."`
- exit: 0
- at: 2026-10-21T19:25:01.810634Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:08 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:09 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:10 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:11 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:12 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:13 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:14 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:15 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:16 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:17 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:18 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:19 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:20 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:21 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:22 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:23 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:24 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:25 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:26 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:27 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:28 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:29 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:30 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:31 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:32 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:33 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:34 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:35 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:36 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:36 +0: A1 ... on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.    
00:37 +0: A1 ... on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.    
00:38 +0: A1 ... on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.    
00:38 +1: A1 ... on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.    
00:38 +1: All tests passed!
```
- generation:
  (none)
- suite: baseline=0 guard=0 new=(none)

- schema: 1
- prev-hash: ff833529b69826480cc7bf8481940dfebfe9989d8e652dbcb2ef48c66a240f79
- hash: 106b34a0fa6edb9cae498c9cb5b996383c23ac04feb9bdd536c2f7f4e22e0423

## Cycle: A2 (green)

- behavior: A2
- kind: green
- evidence: issue #1162 re-certification — the subject was hand-implemented after the certified red; this green evidence binds the NEW subject shape with the passing transcript
- subject-hash: 1207366a091b89c87e394c33392bea62bb80c9f9d191aff510444e0f863b1654
- criterion: AC-2
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart --plain-name "that package names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, carries the Flutter SDK constraint that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library."`
- exit: 0
- at: 2026-10-21T19:26:25.749961Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:08 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:09 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:10 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:11 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:12 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:13 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:14 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:15 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:16 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:17 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:18 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:19 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:20 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:21 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:22 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:22 +0: A2 ... that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library.
00:23 +0: A2 ... that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library.
00:23 +1: A2 ... that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library.
00:23 +1: All tests passed!
```
- generation:
  (none)
- suite: baseline=0 guard=0 new=(none)

- schema: 1
- prev-hash: cc7e8209597108b75b6b7ad76220278909eed814e7a11ca2ea24ebd3e23d4851
- hash: 8817141e85f11c101d01a07f36f363e3dec2e6b99c98db09c3e74824ee1a64d5

## Cycle: A1 (green)

- behavior: A1
- kind: green
- evidence: issue #1162 re-certification — the subject was hand-implemented after the certified red; this green evidence binds the NEW subject shape with the passing transcript
- subject-hash: 26268694f48fc904c498313a6714fc871a6e60320da6c05d0bdfe91ccfdabd5d
- criterion: AC-1
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart --plain-name "the resolution succeeds — the package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency, and it depends on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change."`
- exit: 0
- at: 2026-10-21T19:41:29.333663Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:08 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:09 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:10 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:11 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:12 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:13 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:14 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:15 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:16 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:17 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:18 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:19 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:20 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:21 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:22 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:23 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:24 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:25 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:26 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:27 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:28 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:29 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:30 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:31 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:32 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:33 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:34 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:35 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:36 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:37 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:38 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:39 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:40 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:41 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:42 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:43 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:44 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:45 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:46 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:47 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:48 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:49 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:50 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:51 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:52 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:53 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:54 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:55 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:56 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:57 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:58 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:59 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:08 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:09 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:10 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:11 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:12 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:13 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:14 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:15 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:16 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:17 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:18 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:19 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:20 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:21 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:22 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:23 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:24 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:25 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:26 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:27 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:28 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:29 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:30 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:31 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:32 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:33 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:34 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:35 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:36 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:37 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:38 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:39 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:40 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:41 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:42 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:43 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:44 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:45 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:46 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:47 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:48 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:49 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:50 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:51 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:52 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:53 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:54 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:55 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:56 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:57 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:58 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
01:59 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:08 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:09 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:10 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:11 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:12 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:13 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:14 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:15 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:16 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:17 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:18 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:19 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:20 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:21 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:22 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:23 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:24 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:25 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:26 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
02:26 +0: A1 ... on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.    
02:27 +0: A1 ... on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.    
02:28 +0: A1 ... on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.    
02:28 +1: A1 ... on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.    
02:28 +1: All tests passed!
```
- generation:
  (none)
- suite: baseline=0 guard=0 new=(none)

- schema: 1
- prev-hash: 106b34a0fa6edb9cae498c9cb5b996383c23ac04feb9bdd536c2f7f4e22e0423
- hash: bde31895fe2cc3bfd91b71df26619f17309079553e121af8e820437d772612c9

## Cycle: A1 (red)

- behavior: A1
- kind: red
- classification: assertionFailure
- evidence: A1 (AC-1) A1 — the resolution succeeds — the package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency, and it depends on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.
- subject-hash: 4fd1f2089e681fae6e75e5b19368a2f871c42fc70a49b156ee475aa986846f6c
- criterion: AC-1
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart --plain-name "the resolution succeeds — the package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency, and it depends on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change."`
- exit: 1
- at: 2026-10-21T21:14:50.745334Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:08 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:09 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:10 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:11 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:12 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:13 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:14 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:15 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:15 +0: A1 ... on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.    
00:16 +0: A1 ... on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.    
00:16 +0 -1: A1 (AC-1) A1 — the resolution succeeds — the package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency, and it depends on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change. [E]
  Expected: not <Instance of 'UnimplementedError'>
    Actual: UnimplementedError:<UnimplementedError: subject_a1 not implemented>
  
  package:matcher                                     expect
  test/tdd/004-pure-dart-umbrella/a1_test.dart 141:7  main.<fn>.<fn>
  

To run this test again: /usr/local/share/flutter/bin/cache/dart-sdk/bin/dart test /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart -p vm --plain-name 'A1 (AC-1) A1 — the resolution succeeds — the package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency, and it depends on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.'

00:16 +0 -1: Some tests failed.                                                                                                                                                                        

Consider enabling the flag chain-stack-traces to receive more detailed exceptions.
For example, 'dart test --chain-stack-traces'.
```

- schema: 1
- prev-hash: bde31895fe2cc3bfd91b71df26619f17309079553e121af8e820437d772612c9
- hash: fda8c9e16ec1cf580220c3522077efcb542d38e8d1966cd5e070069498203165

## Cycle: A2 (red)

- behavior: A2
- kind: red
- classification: assertionFailure
- evidence: A2 (AC-2) A2 — that package names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, carries the Flutter SDK constraint that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library.
- subject-hash: 1ff76bdb2dd85c5fb8d55f0a78820546c1fd8b8cc542c4d955299b8f63bddcc3
- criterion: AC-2
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart --plain-name "that package names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, carries the Flutter SDK constraint that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library."`
- exit: 1
- at: 2026-10-21T21:15:24.356008Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:08 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:09 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:10 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:11 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:12 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:13 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:14 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:15 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:16 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:17 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:18 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:19 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:20 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:20 +0: A2 ... that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library.
00:20 +0 -1: A2 (AC-2) A2 — that package names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, carries the Flutter SDK constraint that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library. [E]
  Expected: not <Instance of 'UnimplementedError'>
    Actual: UnimplementedError:<UnimplementedError: subject_a2 not implemented>
  
  package:matcher                                     expect
  test/tdd/004-pure-dart-umbrella/a2_test.dart 157:7  main.<fn>.<fn>
  

To run this test again: /usr/local/share/flutter/bin/cache/dart-sdk/bin/dart test /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart -p vm --plain-name 'A2 (AC-2) A2 — that package names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, carries the Flutter SDK constraint that a plugin manifest requires, and re-exports the app-facing package'\''s public API — so one dependency still gives the consumer both the conversion and the linked-in native library.'

00:20 +0 -1: Some tests failed.                                                                                                                                                                        

Consider enabling the flag chain-stack-traces to receive more detailed exceptions.
For example, 'dart test --chain-stack-traces'.
```

- schema: 1
- prev-hash: 8817141e85f11c101d01a07f36f363e3dec2e6b99c98db09c3e74824ee1a64d5
- hash: 905b4c4b8724be76341bc7d87fc7fc167ad92eaa4c8786866c6bff62d608b348

## Cycle: A1 (green)

- behavior: A1
- kind: green
- evidence: issue #1162 re-certification — the subject was hand-implemented after the certified red; this green evidence binds the NEW subject shape with the passing transcript
- subject-hash: b3af565a50dad9c537143f742f6045dd4c1be8d2d568c783d95977cb0e2b5c80
- criterion: AC-1
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart --plain-name "the resolution succeeds — the package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency, and it depends on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change."`
- exit: 0
- at: 2026-10-21T21:15:58.479616Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:08 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:09 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:10 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:11 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a1_test.dart                                                                                           
00:11 +0: A1 ... on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.    
00:12 +0: A1 ... on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.    
00:12 +1: A1 ... on no family member that asks for the Flutter SDK — and its public entry point still offers the conversion, so the consumer needs no second dependency and no project-file change.    
00:12 +1: All tests passed!
```
- generation:
  (none)
- suite: baseline=0 guard=0 new=(none)

- schema: 1
- prev-hash: fda8c9e16ec1cf580220c3522077efcb542d38e8d1966cd5e070069498203165
- hash: df6c743397ecbf33869003e940539f7f61ad93af265c35b2d4a7907d4c0ca076

## Cycle: A2 (green)

- behavior: A2
- kind: green
- evidence: issue #1162 re-certification — the subject was hand-implemented after the certified red; this green evidence binds the NEW subject shape with the passing transcript
- subject-hash: f2cae98942a859c714f91c7f51bd61feb63a877af7dff5025da87c84d662785a
- criterion: AC-2
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart --plain-name "that package names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, carries the Flutter SDK constraint that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library."`
- exit: 0
- at: 2026-10-21T21:16:29.889209Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:08 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:09 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:10 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:11 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:12 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:13 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:14 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:15 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:16 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:17 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:18 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:19 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:20 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:21 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/004-pure-dart-umbrella/a2_test.dart                                                                                           
00:21 +0: A2 ... that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library.
00:22 +0: A2 ... that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library.
00:22 +1: A2 ... that a plugin manifest requires, and re-exports the app-facing package's public API — so one dependency still gives the consumer both the conversion and the linked-in native library.
00:22 +1: All tests passed!
```
- generation:
  (none)
- suite: baseline=0 guard=0 new=(none)

- schema: 1
- prev-hash: 905b4c4b8724be76341bc7d87fc7fc167ad92eaa4c8786866c6bff62d608b348
- hash: 4748058bb7a639b9d114bd385d1772219168241ab49d5df7d5f29dd06411ebf6

