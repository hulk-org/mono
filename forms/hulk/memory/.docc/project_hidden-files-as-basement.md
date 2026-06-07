---
name: Hidden files as basement levels
description: Dotfiles/hidden dirs in Agent RPG render as basement/underground levels — .docc is the knowledge vault, .git is the sewer, .wrkstrm is the utility closet
type: project
---

In Agent RPG's room navigation, hidden files/directories (dotfiles) should render as **basement levels** below the main room, not as regular doors:

- `.docc` bundles → knowledge vault / library basement
- `.git` → sewer system / underground tunnels
- `.wrkstrm` → utility closet / maintenance room
- `.build` → factory basement / forge
- `.swiftpm` → supply closet

Access: trapdoor in the floor, stairs going down, or a special "hidden passage" interaction. Not visible by default — the operator discovers them.

**How to apply:** Add a trapdoor quad to rooms that have hidden children. Clicking or walking onto it reveals the basement level. Different visual treatment from regular doors (darker, descending, mysterious).
