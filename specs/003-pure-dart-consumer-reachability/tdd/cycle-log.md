# Cycle Log

Append only. Newest last. Every entry's `red` block is the evidence that the test existed and failed before the implementation.

## Cycle: A1 (red)

- behavior: A1
- kind: red
- classification: assertionFailure
- subject-hash: 3c371b4fc3507b74f050858a215d9c8e77cb265ed9471dfdbbdb1c980a4cd970
- criterion: AC-1
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart`
- exit: 1
- at: 2026-10-21T15:16:19.902955Z
- output:
```
Expected: not <Instance of 'UnimplementedError'>
    Actual: UnimplementedError:<UnimplementedError: subject_a1 not implemented>
  
  package:matcher                                                 expect
  test/tdd/003-pure-dart-consumer-reachability/a1_test.dart 37:7  main.<fn>.<fn>
  

(batched red — one runner invocation for 2 behavior(s), spec 069 T002)
```

- schema: 1
- prev-hash: genesis
- hash: f621df6690d522f430db8fa762cbf69e50ac04aa3c24c448a88c138093c2d5c3

## Cycle: A2 (red)

- behavior: A2
- kind: red
- classification: assertionFailure
- subject-hash: 6c9adc0b1532b4d1c49dc55f7db66c3df4807eb95825cc3a716e5c326d43e805
- criterion: AC-2
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart`
- exit: 1
- at: 2026-10-21T15:16:19.952792Z
- output:
```
Expected: not <Instance of 'UnimplementedError'>
    Actual: UnimplementedError:<UnimplementedError: subject_a2 not implemented>
  
  package:matcher                                                 expect
  test/tdd/003-pure-dart-consumer-reachability/a2_test.dart 37:7  main.<fn>.<fn>
  

(batched red — one runner invocation for 2 behavior(s), spec 069 T002)
```

- schema: 1
- prev-hash: genesis
- hash: 7338c803e942ddb1db0de04d791d20bc65f68532f8a4a389aae5bd0e5ea4cd7a

## Cycle: A1 (green)

- behavior: A1
- kind: green
- evidence: issue #1162 re-certification — the subject was hand-implemented after the certified red; this green evidence binds the NEW subject shape with the passing transcript
- subject-hash: 3d2496661926a2638d7d6eac23058ba3174fb111d0f06335c55867113f4a5536
- criterion: AC-1
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart --plain-name "the resolution succeeds — that package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change."`
- exit: 0
- at: 2026-10-21T15:20:04.226704Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:07 +0: A1 ... constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change.     
00:08 +0: A1 ... constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change.     
00:09 +0: A1 ... constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change.     
00:10 +0: A1 ... constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change.     
00:10 +1: A1 ... constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change.     
00:10 +1: All tests passed!
```
- generation:
  (none)
- suite: baseline=0 guard=0 new=(none)

- schema: 1
- prev-hash: f621df6690d522f430db8fa762cbf69e50ac04aa3c24c448a88c138093c2d5c3
- hash: aceb2309ed5e74491a3d32836b355257fae186c04db9f938fc5ea38a18c0fb2a

## Cycle: A2 (green)

- behavior: A2
- kind: green
- evidence: issue #1162 re-certification — the subject was hand-implemented after the certified red; this green evidence binds the NEW subject shape with the passing transcript
- subject-hash: 74b912f676d0fc0b3defbae2f03fed2734bfadd06a6065dc66ba132fa6a0ee9b
- criterion: AC-2
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart --plain-name "it still names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, and still carries the Flutter SDK constraint that a plugin manifest requires — so the zero-touch distribution of `001-zero-touch-native-distribution` survives."`
- exit: 0
- at: 2026-10-21T15:20:25.585292Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:06 +0: A2 ... for their platform, and still carries the Flutter SDK constraint that a plugin manifest requires — so the zero-touch distribution of `001-zero-touch-native-distribution` survives.   
00:07 +0: A2 ... for their platform, and still carries the Flutter SDK constraint that a plugin manifest requires — so the zero-touch distribution of `001-zero-touch-native-distribution` survives.   
00:07 +1: A2 ... for their platform, and still carries the Flutter SDK constraint that a plugin manifest requires — so the zero-touch distribution of `001-zero-touch-native-distribution` survives.   
00:07 +1: All tests passed!
```
- generation:
  (none)
- suite: baseline=0 guard=0 new=(none)

- schema: 1
- prev-hash: 7338c803e942ddb1db0de04d791d20bc65f68532f8a4a389aae5bd0e5ea4cd7a
- hash: 45726ca4abce4267f81347ec9363a418fe26d402d4ba1f1fd6360ac38fb0156f

## Cycle: A1 (green)

- behavior: A1
- kind: green
- evidence: issue #1162 re-certification — the subject was hand-implemented after the certified red; this green evidence binds the NEW subject shape with the passing transcript
- subject-hash: 9687fc8928823ac6180546c0c49b1c80d9c6006a1129924db8c4be2975dbf03f
- criterion: AC-1
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart --plain-name "the resolution succeeds — that package asks for no Flutter SDK, neither as an `environment: flutter:` constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change."`
- exit: 0
- at: 2026-10-21T15:43:40.413016Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:08 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:09 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:10 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:11 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:12 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:13 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:14 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:15 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a1_test.dart                                                                              
00:15 +0: A1 ... constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change.     
00:16 +0: A1 ... constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change.     
00:17 +0: A1 ... constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change.     
00:18 +0: A1 ... constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change.     
00:19 +0: A1 ... constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change.     
00:19 +1: A1 ... constraint nor as a `flutter: sdk: flutter` dependency — and its public entry point offers the conversion, so the consumer needs no second dependency and no project-file change.     
00:19 +1: All tests passed!
```
- generation:
  (none)
- suite: baseline=0 guard=0 new=(none)

- schema: 1
- prev-hash: aceb2309ed5e74491a3d32836b355257fae186c04db9f938fc5ea38a18c0fb2a
- hash: 38bc173ca0d7bf972fd6389f841876856cb84a36c068eef4e96796bb93992c4b

## Cycle: A2 (green)

- behavior: A2
- kind: green
- evidence: issue #1162 re-certification — the subject was hand-implemented after the certified red; this green evidence binds the NEW subject shape with the passing transcript
- subject-hash: 74b912f676d0fc0b3defbae2f03fed2734bfadd06a6065dc66ba132fa6a0ee9b
- criterion: AC-2
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart --plain-name "it still names the Android, iOS, and macOS adapter packages as the `default_package` for their platform, and still carries the Flutter SDK constraint that a plugin manifest requires — so the zero-touch distribution of `001-zero-touch-native-distribution` survives."`
- exit: 0
- at: 2026-10-21T15:44:31.067588Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:08 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:09 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:10 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:11 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:12 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:13 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:14 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:15 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/003-pure-dart-consumer-reachability/a2_test.dart                                                                              
00:15 +0: A2 ... for their platform, and still carries the Flutter SDK constraint that a plugin manifest requires — so the zero-touch distribution of `001-zero-touch-native-distribution` survives.   
00:16 +0: A2 ... for their platform, and still carries the Flutter SDK constraint that a plugin manifest requires — so the zero-touch distribution of `001-zero-touch-native-distribution` survives.   
00:17 +0: A2 ... for their platform, and still carries the Flutter SDK constraint that a plugin manifest requires — so the zero-touch distribution of `001-zero-touch-native-distribution` survives.   
00:18 +0: A2 ... for their platform, and still carries the Flutter SDK constraint that a plugin manifest requires — so the zero-touch distribution of `001-zero-touch-native-distribution` survives.   
00:18 +1: A2 ... for their platform, and still carries the Flutter SDK constraint that a plugin manifest requires — so the zero-touch distribution of `001-zero-touch-native-distribution` survives.   
00:18 +1: All tests passed!
```
- generation:
  (none)
- suite: baseline=0 guard=0 new=(none)

- schema: 1
- prev-hash: 45726ca4abce4267f81347ec9363a418fe26d402d4ba1f1fd6360ac38fb0156f
- hash: 3dd3c7d92f6452c76e9853a1e65a5f960138bb66b273294a5233a3149513697e

