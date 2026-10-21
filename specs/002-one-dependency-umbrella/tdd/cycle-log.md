# Cycle Log

Append only. Newest last. Every entry's `red` block is the evidence that the test existed and failed before the implementation.

## Cycle: A1 (red)

- behavior: A1
- kind: red
- classification: assertionFailure
- subject-hash: c4b72155accb9665f64ce53a25cd05a0aeb3a570da2a86ed0b0c7e46fdf26317
- criterion: AC-1
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart --plain-name "the shared conversion contract and all three platform adapters — the Android, iOS, and macOS registration helpers — are reachable from that one entry point."`
- exit: 1
- at: 2026-10-21T07:39:23.916562Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:00 +0: A1 (AC-1) A1 — the shared conversion contract and all three platform adapters — the Android, iOS, and macOS registration helpers — are reachable from that one entry point.                  
00:00 +0 -1: A1 (AC-1) A1 — the shared conversion contract and all three platform adapters — the Android, iOS, and macOS registration helpers — are reachable from that one entry point. [E]           
  Expected: not <Instance of 'UnimplementedError'>
    Actual: UnimplementedError:<UnimplementedError: subject_a1 not implemented>
  
  package:matcher                                         expect
  test/tdd/002-one-dependency-umbrella/a1_test.dart 30:7  main.<fn>.<fn>
  

To run this test again: /usr/local/share/flutter/bin/cache/dart-sdk/bin/dart test /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart -p vm --plain-name 'A1 (AC-1) A1 — the shared conversion contract and all three platform adapters — the Android, iOS, and macOS registration helpers — are reachable from that one entry point.'

00:00 +0 -1: Some tests failed.                                                                                                                                                                        

Consider enabling the flag chain-stack-traces to receive more detailed exceptions.
For example, 'dart test --chain-stack-traces'.
```

- schema: 1
- prev-hash: genesis
- hash: 7efc50dad4c998a032ce5220ee3c99541a60b01063f8fcfede95e545c64e84a1

## Cycle: A2 (red)

- behavior: A2
- kind: red
- classification: assertionFailure
- subject-hash: 7c543e0244a2d07a030c679e1969cbb9ce4381be9fd4ed4bd9092bdc3b9b88a3
- criterion: AC-2
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart --plain-name "the shared platform package and the three adapters come along with it, and no family member depends back on the app-facing package, so the graph stays acyclic."`
- exit: 1
- at: 2026-10-21T07:39:25.520198Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:00 +0: A2 (AC-2) A2 — the shared platform package and the three adapters come along with it, and no family member depends back on the app-facing package, so the graph stays acyclic.               
00:00 +0 -1: A2 (AC-2) A2 — the shared platform package and the three adapters come along with it, and no family member depends back on the app-facing package, so the graph stays acyclic. [E]        
  Expected: not <Instance of 'UnimplementedError'>
    Actual: UnimplementedError:<UnimplementedError: subject_a2 not implemented>
  
  package:matcher                                         expect
  test/tdd/002-one-dependency-umbrella/a2_test.dart 30:7  main.<fn>.<fn>
  

To run this test again: /usr/local/share/flutter/bin/cache/dart-sdk/bin/dart test /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart -p vm --plain-name 'A2 (AC-2) A2 — the shared platform package and the three adapters come along with it, and no family member depends back on the app-facing package, so the graph stays acyclic.'

00:00 +0 -1: Some tests failed.                                                                                                                                                                        

Consider enabling the flag chain-stack-traces to receive more detailed exceptions.
For example, 'dart test --chain-stack-traces'.
```

- schema: 1
- prev-hash: genesis
- hash: fd362099096c8624e93181e4c8f2932cd91ced8f3437745f6ccaf02d55a9d0b3

## Cycle: A1 (green)

- behavior: A1
- kind: green
- evidence: issue #1162 re-certification — the subject was hand-implemented after the certified red; this green evidence binds the NEW subject shape with the passing transcript
- subject-hash: 4125eda6a671f7fdff01ac55431c9d9d7d0660f079d88789797e6d25ff93b43e
- criterion: AC-1
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart --plain-name "the shared conversion contract and all three platform adapters — the Android, iOS, and macOS registration helpers — are reachable from that one entry point."`
- exit: 0
- at: 2026-10-21T07:39:42.617450Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:07 +0: A1 (AC-1) A1 — the shared conversion contract and all three platform adapters — the Android, iOS, and macOS registration helpers — are reachable from that one entry point.                  
00:07 +1: A1 (AC-1) A1 — the shared conversion contract and all three platform adapters — the Android, iOS, and macOS registration helpers — are reachable from that one entry point.                  
00:07 +1: All tests passed!
```
- generation:
  (none)
- suite: baseline=0 guard=0 new=(none)

- schema: 1
- prev-hash: 7efc50dad4c998a032ce5220ee3c99541a60b01063f8fcfede95e545c64e84a1
- hash: a727401b0320d529e85e9cd4d8b2a9ba355c0d94641f2b8387e34a01b9d43114

## Cycle: A2 (green)

- behavior: A2
- kind: green
- evidence: issue #1162 re-certification — the subject was hand-implemented after the certified red; this green evidence binds the NEW subject shape with the passing transcript
- subject-hash: 46ea95fae5979b9703aa57a6bb9f845aed374eda214e2e0e41d9458277c42901
- criterion: AC-2
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart --plain-name "the shared platform package and the three adapters come along with it, and no family member depends back on the app-facing package, so the graph stays acyclic."`
- exit: 0
- at: 2026-10-21T07:39:45.365917Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:01 +0: A2 (AC-2) A2 — the shared platform package and the three adapters come along with it, and no family member depends back on the app-facing package, so the graph stays acyclic.               
00:01 +1: A2 (AC-2) A2 — the shared platform package and the three adapters come along with it, and no family member depends back on the app-facing package, so the graph stays acyclic.               
00:01 +1: All tests passed!
```
- generation:
  (none)
- suite: baseline=0 guard=0 new=(none)

- schema: 1
- prev-hash: fd362099096c8624e93181e4c8f2932cd91ced8f3437745f6ccaf02d55a9d0b3
- hash: d62c32699ddc2c34976bf5442692a125355806a9c72c374f9899a8dde4b9df3a

## Cycle: A1 (green)

- behavior: A1
- kind: green
- evidence: issue #1162 re-certification — the subject was hand-implemented after the certified red; this green evidence binds the NEW subject shape with the passing transcript
- subject-hash: 227f13cbaf8b3a7c04fb11cecd15e477ca1296ad83207758cf599ecf81b907d3
- criterion: AC-1
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart --plain-name "the shared conversion contract and all three platform adapters — the Android, iOS, and macOS registration helpers — are reachable from that one entry point."`
- exit: 0
- at: 2026-10-21T19:27:49.481715Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:08 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:09 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:10 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:11 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:12 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:13 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:14 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:15 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:16 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:17 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:18 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:19 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:20 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:21 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:22 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:23 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:24 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:25 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a1_test.dart                                                                                      
00:25 +0: A1 (AC-1) A1 — the shared conversion contract and all three platform adapters — the Android, iOS, and macOS registration helpers — are reachable from that one entry point.                  
00:26 +0: A1 (AC-1) A1 — the shared conversion contract and all three platform adapters — the Android, iOS, and macOS registration helpers — are reachable from that one entry point.                  
00:26 +1: A1 (AC-1) A1 — the shared conversion contract and all three platform adapters — the Android, iOS, and macOS registration helpers — are reachable from that one entry point.                  
00:27 +1: All tests passed!
```
- generation:
  (none)
- suite: baseline=0 guard=0 new=(none)

- schema: 1
- prev-hash: a727401b0320d529e85e9cd4d8b2a9ba355c0d94641f2b8387e34a01b9d43114
- hash: 82f31fa6a81e5ff312d8200f91d8605ea6c22ce88786ca53bc0d873bf7d2ad29

## Cycle: A2 (green)

- behavior: A2
- kind: green
- evidence: issue #1162 re-certification — the subject was hand-implemented after the certified red; this green evidence binds the NEW subject shape with the passing transcript
- subject-hash: deace876f396f5129a1269e1ff487f71dfa45d9a0b96597eb057fc98dcda7cb1
- criterion: AC-2
- test: /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart
- command: `dart test --concurrency=2 /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart --plain-name "the shared platform package and the three adapters come along with it, and no family member depends back on the app-facing package, so the graph stays acyclic."`
- exit: 0
- at: 2026-10-21T19:28:33.675951Z
- output:
```
00:00 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:01 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:02 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:03 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:04 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:05 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:06 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:07 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:08 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:09 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:10 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:11 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:12 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:13 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:14 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:15 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:16 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:17 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:18 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:19 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:20 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:21 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:22 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:23 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:24 +0: loading /Users/arrrrny/Developer/html_to_markdown_ffi/test/tdd/002-one-dependency-umbrella/a2_test.dart                                                                                      
00:24 +0: A2 (AC-2) A2 — the shared platform package and the three adapters come along with it, and no family member depends back on the app-facing package, so the graph stays acyclic.               
00:25 +0: A2 (AC-2) A2 — the shared platform package and the three adapters come along with it, and no family member depends back on the app-facing package, so the graph stays acyclic.               
00:25 +1: A2 (AC-2) A2 — the shared platform package and the three adapters come along with it, and no family member depends back on the app-facing package, so the graph stays acyclic.               
00:25 +1: All tests passed!
```
- generation:
  (none)
- suite: baseline=0 guard=0 new=(none)

- schema: 1
- prev-hash: d62c32699ddc2c34976bf5442692a125355806a9c72c374f9899a8dde4b9df3a
- hash: ddd38ce485f5c672ad5bef7e018a1a9e4aa314bd728a1271757332b2de66bad3

