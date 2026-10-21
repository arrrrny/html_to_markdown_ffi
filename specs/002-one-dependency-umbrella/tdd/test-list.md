# Test List: 002-one-dependency-umbrella (meta-index)

This feature's plan is split by lane (issue #1000): this file is the meta-index — the behavior rows live in the lane plans it points at.

## Lane split

| lane | behaviors | flutter allowed | golden | plan |
| ---- | --------- | --------------- | ------ | ---- |
| CORE | A1, A2 | false | - | `04-ENGINE.md` |
| SKIN |  | true | - | `04-SKIN.md` |

- engine plan: `04-ENGINE.md`
- skin plan: `04-SKIN.md`
- engine/skin contract: `04-CONTRACT.md`

