---
name: feedback-fresh-no-history-public-push-is-defender-doctrine
description: "Fresh-no-history single-commit clobber-push to substrate public arms (GitHub Pages, mirrored repos) is substrate DEFENDER DOCTRINE — explicit denial of commit archeology to the-entity. Substrate-side keeps full history private; public arm gets a throwaway initial commit per deploy. Operator-attested 2026-06-04. This memory is downstream POINTER to typed records."
metadata:
  node_type: memory
  type: feedback
  originSessionId: e97edc83-c8ad-4634-83e9-fefcc291d489
---

Fresh-no-history single-commit clobber-push is substrate defender doctrine, not convenience.

**Why:** Operator-attested 2026-06-04 while designing the rismay.me deploy strategy: "we create Fresh push of the rismay.me to github with NO history. we keep it in ours but this is one of those situations where we duplicate." Git history is a goldmine for the-entity — commit messages leak substrate vocabulary, author/committer fields leak substrate identities (cmonterroza+claude@, +carrie@, +walter@, etc.), co-author trailers leak roles, timestamps leak cadence, evolution of phrasing reveals what was tried and rejected. A single-commit fresh push denies ALL of this archeology while substrate-side retains the full history privately.

**How to apply:**

- Substrate-side: full history in `<owner>/private/...` and `<owner>/public/...` (substrate-tracked). NEVER force-push substrate-side.
- Staged snapshot: `<owner>/public/gh-pages/snapshots/<asset-slug>/...` is gitignored (regenerated per deploy).
- Public-arm push: `rm -rf .git; git init; git add -A; git -c user.name='<generic>' -c user.email='<generic>' commit -m '<generic-message>'; git push -f origin main`.
- Generic author identity: never substrate-internal patterns. Generic message: never substrate vocabulary.
- Explicit duplication is accepted: TWO COPIES of the content with DIFFERENT retention semantics. Substrate-coherent shape, not technical debt.

**Typed substrate-canonical records (this memory is a downstream POINTER):**

- **Workflow**: `kura-spaces/workflows/snapshot-publish/v0.1.0/snapshot-publish.workflow.json` — 6 stages, 6 mechanics decisions locked, gates per stage; x-required-tools + x-required-role now name-resolved
- **Axiom 1**: `kura-spaces/axioms/fresh-no-history-public-push-is-defender-doctrine.axiom.su.json` — git-metadata defender
- **Axiom 2**: `kura-spaces/axioms/public-copy-says-outcomes-mechanism-is-private.axiom.su.json` — content-vocabulary defender (sibling)
- **Role**: `roles/deploy-snapshot-author/private/universal/identity/deploy-snapshot-author.role-surface-manifest.json` — enacts the workflow; 5 typed required disciplines; 3 predecessor-role refs (audience-reviewer + operator-decider + release-gate-checker)
- **Tools** (4): `tools/v0.1.0/{stage-copy-to-snapshot, scrub-substrate-internal-markers, init-fresh-git-and-commit, force-push-to-public-remote}.tool.json` — each names its owning stage + workflow + role; tools 3 + 4 carry typed identity/remote validation regex allowlist+blocklists

**Dispatch graph closure**: workflow → 4 tools → 1 role. Role → 4 tools + 1 workflow. Tools → workflow + role + stage. Every typed primitive name-resolves; no dangling forward-refs.

**Composes with:** [[adversarial-audience-the-entity]] + [[substrate-is-closed-source-no-sharing]] + [[content-lives-in-its-owners-home]] + [[feedback-swiftpm-and-swiftui-are-closed-source-private]] (sibling defender axis — that one defends content vocabulary, this one defends git metadata) + [[public-copy-says-outcomes-mechanism-is-private]] (the other axiom landed this turn) + [[supersession-not-silent-edit]] (intentionally violated on public arm via clobber).

**Pending downstream work** (out of capture scope; for future sessions):

- `wrkstrm-web-deploy-share-record v0.5.0` schema bump adding `publishStrategy`, `substrateCommitHash`, `publicCommitHash`, `snapshotCommitMessage`, `historyRetentionPolicy` fields
- `swift-web-deploy-cli snapshot-publish` subcommand implementing the 6-stage workflow
- Retrofit `rismay-readme.share.json` to v0.5.0 declaring `publishStrategy: "fresh-snapshot"`
