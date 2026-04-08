# Worktrees Do Not Isolate Submodules - 2026-04-07

## What this is

A structural fact about `git worktree` and the Claude Code agent harness's
worktree isolation feature: **a parent-repo worktree does not give you an
isolated copy of the submodules inside it.** Two agents dispatched in
parallel against the same monorepo with `isolation: "worktree"` will
share submodule storage and race on submodule HEADs, indexes, and
working trees.

This is the lesson from running a parallel bake-off between Option C
(phantom-tag wrapper) and Option D (Swift macro) for the
exact-schema-version decoding proposal in
`schema-universal/universal-schema.architecture.docc/exact-schema-version-decoding-proposal.md`.

## The discovery

Two agents were dispatched with `isolation: "worktree"` to implement
the two competing options end-to-end on dedicated branches in
`swift-universal-main` and `schema-universal` (both submodules of
mono). The intent was a clean head-to-head: each agent gets its own
worktree, makes changes, builds, runs tests, and reports back.

The Option D agent ran first and immediately surfaced the structural
problem before touching any state:

- The harness placed the agent in a worktree at
  `/Users/sonoma/mono/.claude/worktrees/agent-<id>` with its own branch
  name `worktree-agent-<id>`. That part is real worktree isolation -
  the parent mono repo's index and HEAD are independent.
- But `git worktree list` inside each target submodule showed a single
  worktree pointing back at `.git/modules/...` under the **main** mono
  checkout. The submodules' `.git` files are gitlinks back into the
  shared submodule object store. Submodules are not multiplexed by
  parent-repo worktrees.
- A sibling worktree `agent-a537f78c` was already running concurrently
  (the parallel Option C agent). Any branch the Option D agent created
  in `swift-universal-main` or `schema-universal` would be **visible
  to and collide with** that sibling.

The Option D agent stopped and reported rather than mutate shared
state. That was the right call. Whoever ran `swift test` second would
have seen the other agent's edits; whoever committed second might have
overwritten working-tree changes that hadn't been committed yet on
the other side.

## Why this matters

The whole pitch of `isolation: "worktree"` is "give the agent an
isolated copy of the repository." That pitch is technically accurate
for the parent repo but silently false for any submodules inside it.
A user dispatching parallel agents to work on different parts of a
monorepo can reasonably assume isolation extends to the whole tree,
and it does not.

The blast radius depends on what the agents touch:

- **Parallel agents editing only parent-repo files**: safe. Worktrees
  isolate parent-repo state and the agents can run truly in parallel.
- **Parallel agents editing different submodules from each other**:
  safe. No collision because they touch disjoint storage.
- **Parallel agents editing the same submodule**: unsafe. Worktrees
  do not help. They will race on submodule HEAD, index, working tree,
  and refs. Branches give logical separation of *commits* but not of
  *intermediate working state*.

The third case is exactly what a "compare two implementations of the
same proposal head-to-head" workflow looks like, and it's the case
where the user most expects worktrees to deliver isolation.

## Workarounds

In rough order of preference:

1. **Sequential dispatch into the same worktree.** Run Option C to
   completion in worktree A, capture results, then run Option D in
   worktree B. Slower wall-clock but trivially correct. The "what
   wins wins" comparison still works at the end.
2. **Scratch clones outside the submodule layout.** For each option,
   `git clone` the affected submodules into a fresh scratch directory
   that the agent owns exclusively. Costs an extra clone per option
   but gives true parallel isolation. Cleanup is manual.
3. **Branches with strict naming + hope for no race.** Each agent uses
   distinct branch names (e.g. `proposal/option-c-phantom-tag` vs
   `proposal/option-d-macro`). Commits land on logically separate
   lines of history. But intermediate working-tree state and index
   are still shared, so concurrent `swift test` results are not
   trustworthy as a comparison and concurrent uncommitted edits will
   clobber. Only acceptable if the parallel work touches **disjoint
   files** within the same submodule, and even then test results may
   interleave.
4. **Sibling worktree of the submodule itself.** `git worktree add`
   from inside the submodule. Untested in this harness; likely works
   for the submodule's parent-repo equivalent of isolation but the
   harness doesn't know about it, so cleanup falls to the user.

## What to do next time

Before dispatching parallel agents that will touch submodules:

- Check the dispatch plan for "do these agents edit the same
  submodule?" If yes, default to sequential or scratch clones.
- If parallel is essential, instruct each agent to verify worktree
  isolation **as the first step**, fail loudly on shared state, and
  report rather than proceed. (The Option D agent did this correctly
  on its own; bake it into the dispatch prompt instead of relying on
  the agent to notice.)
- Add unique branch names per agent to give logical commit isolation
  even if working-tree isolation isn't possible.
- Consider whether the affected submodules are themselves nested.
  `swift-universal-main` is nested inside `swift-universal`, which
  meant the Option C agent had to cut a third branch. Nested
  submodules compound the isolation problem.

## Related

- The Option C agent's full report (what shipped on
  `proposal/option-c-phantom-tag` branches) is in the common chronicle
  entry for 2026-04-08.
- The proposal that drove the experiment:
  `schema-universal/universal-schema.architecture.docc/exact-schema-version-decoding-proposal.md`
- Open follow-up: extend `clia-git` so abandoned-on-a-branch agent
  work like tonight's `proposal/option-c-phantom-tag` commits is
  discoverable from the workspace overview without `cd` + `git branch
  -a` per submodule. Without that affordance, branch-bound work from
  parallel agent runs is invisible until someone remembers it exists.
