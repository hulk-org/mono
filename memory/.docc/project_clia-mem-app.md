---
name: clia-mem app planned
description: Planned clia-mem app browses session history across all harnesses
type: project
---

A planned **clia-mem** app will read session history across all harnesses (codex rollouts, claude-code sessions, hulk/clia/etc.) and surface them as browsable memory.

**Why:** Sessions are scattered per-harness today (e.g. `private/universal/vaults/ai/exports/open-ai/codex/sessions/`, claude runtime state under `harnesses/claude/`, etc.). A unified memory lens belongs in the clia family — consumer/agent-facing — paralleling how Source Control belongs in wrkstrm. Also dovetails with the "one truth, many lenses" principle: the sessions are the canonical data; clia-mem is one lens onto them.

**How to apply:** When session-cleanup, history browsing, or cross-harness memory comes up, expect clia-mem to be the eventual home. Keep vault session contents intact (no rewriting) so clia-mem has a faithful corpus to read.
