# Traceability: 002-one-dependency-umbrella

Coverage proof for `zfa tdd plan` (bug #846): every FR/AC requirement statement maps to a behavior row or an explicit manual declaration. Verify re-checks the hash — a spec edited after plan is drift (exit 3, re-plan required).

<!-- tdd:traceability
spec-hash: sha256:044553b4ea59119c915e77f664f6fa012fcf85ea0c13c5caf44e4fc52aa9c3a5
statements: 2
automated: 2
manual: 0
fr-manual: 0
open-gaps: 0
-->

| requirement | line | statement | behavior | status |
| --- | --- | --- | --- | --- |
| AC-1 | 7 | 1. **Given** a consumer of the app-facing `html_to_markdown_ffi` package **When** it imports the package's public entry point **Then** the shared conversion contract and all three platform adapters — the Android, iOS, and macOS registration helpers — are reachable from that one entry point. | A1 | automated |
| AC-2 | 9 | 2. **Given** a consumer that declares only `html_to_markdown_ffi` as a dependency **When** the family's dependency graph is read **Then** the shared platform package and the three adapters come along with it, and no family member depends back on the app-facing package, so the graph stays acyclic. | A2 | automated |

