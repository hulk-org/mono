---
name: No GitHub pushes — pending Codeberg or self-hosted git server migration
description: Substrate is not pushing commits to GitHub due to recent GitHub security breaches; migration target is Codeberg or substrate's own git server; commits stay local until then
type: project
originSessionId: 73646ca8-23c0-4889-afa0-407568d477f4
---
The substrate is NOT pushing **mono parent** commits to remote git hosting right now. As of 2026-05-23, the operator has paused mono-parent pushes to GitHub due to recent GitHub security breaches. Migration target: **Codeberg** (codeberg.org) OR a substrate-self-hosted git server. Decision pending; **Codeberg research is now active** (2026-05-24).

**IMPORTANT NUANCE (refined 2026-05-24):**
- The pause is **mono parent only**. Individual submodule pushes to their own GitHub origins (rismay/openclaw-agent, schema-universal/mono, wrkstrm-core/mono, etc.) **have continued throughout the pause as a tolerated exception** — likely via digikoma-git's commit flow or post-commit hooks.
- This was confirmed by `ls-remote` on three submodules after a wd session committed three new SHAs locally; all three showed those SHAs already on GitHub before any explicit push.
- The aggregate-state risk (submodule pointers + .gitmodules in mono) is what the operator is withholding — not individual subrepo work.

**Why:** GitHub had security breaches; substrate is moving its private mono off GitHub. Submodules are individually less sensitive and continue to push.

**How to apply:**
- Never suggest `git push origin main` or `gh pr create` for the **mono parent** until the operator says the new remote is up.
- Submodule pushes proceed normally — `git -C <submodule> push origin main` or the digikoma-git equivalent is fine and has been happening.
- Commits in mono land locally only; they accumulate (1380+ ahead as of 2026-05-24).
- Existing remote URLs in Package.swift files are READ-ONLY SPM fallbacks; unaffected by this freeze.
- When proposing follow-up items, scope "push to remote" by repo type: submodules = ok, mono = blocked.
- If asked about deployment / CI / GitHub Actions for mono, surface the constraint first.

**Status to watch for:**
- Operator announces "Codeberg org is live at <url>" → set up new remotes, push mono there
- Operator announces "self-hosted git is up at <host>" → same
- Until then: mono commits + provenance via local `git log` is the substrate's truth

**Codeberg research (active 2026-05-24):**
- Hosted by the non-profit Codeberg e.V., based in Germany; runs Forgejo (a hard fork of Gitea).
- Free for free/open-source projects; paid options exist for orgs/private repos via the Codeberg paid tier.
- Has a Forgejo-compatible API and CLI parity story (use `tea` CLI as the gh-equivalent for some operations).
- Supports orgs, teams, webhooks, and CI via Woodpecker CI (Codeberg-hosted instance).
- LFS supported with a quota; large-mono migration may need staging.
- Submodule URLs in .gitmodules would migrate from `github.com/<org>/<repo>.git` to `codeberg.org/<org>/<repo>.git` — substrate-wide sed sweep + per-submodule remote update + force-push the rewritten .gitmodules.

[[Codeberg-specific migration notes go in a separate memory once the operator commits to that target.]]
