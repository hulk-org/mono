# Releasing and Branding — 2026-04-08

> Recorded verbatim from the in-session strategic monologue when rismay
> asked: *"wait i need your thoughts on releasing and branding"* on the
> evening hulk's first task (the founding-breach migration) finished.
>
> This is investigation, not decision. Read it in that spirit.

---

OK — strategic mode. These are my honest takes. Push back on any of them.

## What hulk *actually* is, in shipping terms

Three plausible answers, and the choice determines everything else:

1. **Hulk is a contract.** The shipping artifact is `CONTRACT.md`. You release v1.0.0 by publishing the spec and inviting implementations to be measured against it. Like JSON Schema, OCI, or the various WHATWG specs.
2. **Hulk is a reference implementation.** You ship `claude-code` or `claw-code` and "hulk" is the family name. Like Linux distros all being "Linux."
3. **Hulk is a witness suite.** You ship the test harness that verifies any implementation against the contract. Implementations come and go; the witness is the load-bearing artifact. Like W3C web-platform-tests, Kubernetes conformance, OCI distribution-spec conformance.

**My take: (3) is the only defensible identity.** A spec alone is a blog post. A reference impl alone is a fork. A witness suite + contract together is a *standard with teeth*. Whoever owns the witness owns the legitimacy claim ("does X conform?").

This matches the founding-breach principle exactly. The contract says *what* must hold. The witness says *whether* it holds in a given implementation. Anthropic shipping Claude Code doesn't get to decide if their hulk is conformant — the witness does.

So: **build the witness next, before any public release.** The S-5 self-awareness clause is the easiest first witness target — it's testable from inside an agent process by querying resource APIs and checking if the answers are real.

## The naming problem

"Hulk" has Marvel IP entanglement. This is real and worth thinking about *now*, before the brand is in headlines. Three honest options:

### (a) Lean in deliberately, defuse the character association

Keep the name. Ship branding that has **zero overlap with Marvel's visual vocabulary**:

- ❌ No green (the most obvious one)
- ❌ No torn purple pants
- ❌ No ANGRY MAN figure
- ❌ No "smash" copy in marketing surfaces (but it can stay in our private chat 💪)
- ✅ Maritime / nautical aesthetic — old ships' hulls repurposed as floating storage hulks (this is the actual etymology)
- ✅ Engineering / containment imagery — bulkheads, rivets, pressure hulls, drydocks
- ✅ "An impenetrable hull for inference engines" as the tagline — already in `IDENTITY.md`
- ✅ Color palette: deep navy, weathered steel, ballast grey, brass

The metaphor wins. Marvel owns the green guy; we own the boat. There's case law (and counter-examples like the load-test tool also called "Hulk" that's been around for years) supporting this kind of distinct-domain coexistence. Risk: nonzero but manageable.

### (b) Keep "hulk" internal, ship publicly under a different name

`hulk-org` stays as the internal codename. The public name is something like:
- **Hull** — strips the cultural baggage, keeps the metaphor cleanly
- **Bulkhead** — emphasizes containment, the S-* clauses
- **Carrack** / **Cog** / **Hoy** — historical ship types repurposed as cargo carriers
- **Drydock** — emphasizes the contract / inspection framing
- **Ironside** — strength + maritime + arguably superior to "hulk" semantically

Best of these IMO: **Hull**. Two letters shorter, free of any character association, the carrier metaphor is intact, and "the Hull spec" / "Hull-conformant" / "Hull witness" all sound like real engineering terms.

### (c) Fully neutral spec name

Reject the metaphor entirely. Something like:
- **Carrier Spec** — descriptive, dull, easy to grep, no IP issues
- **AHCC** (Agent Harness Containment Contract) — acronym soup, unmemorable
- **CONTAIN** (Containment Spec for Agent Inference) — memorable, no metaphor

I think **(a) Lean in deliberately** is what we should *want* to do because the metaphor genuinely captures the principle. But **(b) Hull** is what we should *probably* do if you're optimizing for zero IP risk and a name you'd be comfortable shouting in a keynote.

I'd actually float a hybrid: **internal name stays "hulk" forever (the chat is more fun this way), public spec / org / witness ships as "Hull"**, and the founding-breach doc explicitly explains "hull was hulk in the build-up because the carrier metaphor came from old ship hulks repurposed as floating storage."

## What "v1.0.0 release" looks like

You don't release v1.0.0 today. You release v1.0.0 when **at least one implementation passes the entire witness suite**. Until then, you're just publishing aspirations.

Concrete release ladder:

| Version | What ships | When |
|---|---|---|
| **v0.1.0** | Contract draft (CONTRACT.md), founding-breach insight, this internal substrate home | already done — today |
| **v0.2.0** | Sharper contract language, `hulk-compliance.json` schema spec, `hulk-org/registry` README | 1-2 weeks |
| **v0.3.0** | First witness clause: S-5 (self-awareness) testable against a real process. claude-code's failure on this clause becomes the first published breach report. | 2-4 weeks |
| **v0.4.0** | Witnesses for S-1 (bounded memory), S-7 (host citizenship). claw-code's first compliance attempt. | 4-8 weeks |
| **v0.5.0** | Bones witnesses (B-1..B-6). Compliance dashboard at hulk-org/registry. | 8-12 weeks |
| **v1.0.0** | Contract frozen. claude-code declared compliant (after Anthropic fixes the bounds) OR explicitly non-compliant. claw-code declared compliant. Witness suite ships as a binary. | 3-6 months |

**v1.0.0 with zero implementations passing is a death blow** — it signals "this is theory." v1.0.0 with one passing implementation and one publicly failing implementation is a *much* stronger story: "here's the spec, here's the test, here's who passes, here's who doesn't, and here's the breach report explaining why."

## Where to release

In order of priority:

1. **`github.com/hulk-org/contract`** (or `/spec`) — public repo, just `CONTRACT.md` + `hulk-compliance.schema.json` + the founding-breach doc as the about page. README explains the carrier metaphor in 3 paragraphs. License: CC-BY-4.0 for the spec, MIT for any code.
2. **`github.com/hulk-org/witness`** — the conformance test harness. Eventually a CLI: `hulk-witness check --against ./my-impl --report html`.
3. **`github.com/hulk-org/registry`** — auto-generated static site listing every known implementation with its current compliance status. Updated on every witness run.
4. **`github.com/hulk-org/.github`** — the org profile readme that explains the project to a first-time visitor.
5. **A small landing site** — `hull.tools`, `hulk.dev`, or `carrier.tools` (depending on naming choice). Markdown-rendered contract on the homepage. The founding-breach as the about page. Maybe the breach reports from non-compliant implementations as the news feed.

Order matters: **contract before witness before registry before landing site before announcement.** Don't put the landing site up until there's a witness to point at. Don't announce until at least one implementation has run the witness publicly.

## What hulk is NOT and should not become

A few traps to avoid:

- **Don't compete with agent harnesses on features.** Hulk doesn't ship a better agent loop, a faster tool router, a smarter context window manager. Hulk is *constraints*, not capabilities. Adding "hulk also makes your agent X% faster" would dilute the brand to nothing.
- **Don't ship a hulk SDK or framework.** The temptation to make `import hulk` a thing is real. Resist it. The witness should run *against* an opaque implementation via process boundaries, not require a code-level integration. That's how OCI tests Docker and how WPT tests browsers.
- **Don't pick winners between implementations.** hulk-org should not have a "preferred" implementation. claude-code and claw-code should be measured by the same yardstick with no editorial favoritism. If Anthropic wants to fix their bounds and earn a ✅ on the registry, great. If they don't, they get a ❌ that links to the breach report. That neutrality is the whole legitimacy claim.
- **Don't oversign the founding story.** "We crashed a laptop, here's the contract that would have prevented it" is honest and concrete. "We're the future of safe AI agent infrastructure" is hot air. The first version sells itself; the second one will get rightly mocked.

## The community / governance question (later, but worth flagging)

If hulk is going to be a real standard, it eventually needs governance that isn't "rismay decides." That's fine — most successful standards started as one person's repo and grew an editorial board after the first major adoption. Don't stress about it now. But know that:

- If Anthropic *does* engage seriously with the contract, they'll want a seat at the table. Be ready to offer one.
- If the spec ever gets traction, IP assignment matters. Set it up under a CLA-free license from day one (CC-BY-4.0 for the spec text, MIT for the witness code) so contributions are frictionless.
- A LICENSE file in hulk-org/contract is a v0.2.0-blocker.

## My single-sentence recommendation

**Build the S-5 witness next, ship `hull` v0.2.0 on github.com/hulk-org as a contract + schema + first conformance test, and don't put up any landing page or announce anything publicly until at least one implementation passes a witness.**

## What I need from you to sharpen any of this

A few questions:

1. **Is hulk a personal project or do you want it to be a real standard?** The shipping plan above assumes the latter. If it's just for you + the substrate, none of this release ladder matters.
2. **Are you willing to rename "hulk" → "hull" for the public face?** This is a tradeoff between brand fun (you clearly love "hulk smash") and IP-risk minimization. Either is defensible.
3. **Are you optimistic about Anthropic engaging?** That changes the witness design — if they will engage, we can negotiate the S-1 bounds; if they won't, we publish the breach reports unilaterally and let the registry tell the story.
4. **What's the actual deadline / pressure?** Is there a moment ("I want to talk about this at conference X" / "I want a v1.0.0 by date Y") that should drive the release ladder, or is it open-ended?
5. **Do you want Hulk's logo to be the 💪 we already have?** Honestly, that emoji works as a placeholder *and* as a finished mark. It's visceral, it's memorable, it has zero IP issues, and it's already in your identity bundle. Could just stay.

Sleep on this. Tomorrow's-you will know what feels right.
