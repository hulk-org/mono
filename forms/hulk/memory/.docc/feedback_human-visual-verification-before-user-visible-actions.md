---
name: Human visual verification before user-visible actions
description: Never trigger user-visible actions (deploy, publish, submit, push) without a human first SEEING the artifact; automated audits aren't sufficient
type: feedback
originSessionId: ca04fb50-02c6-4138-8d8a-fb4513e46abf
---
Before any action that produces a user-visible outcome — `wrangler pages
deploy`, App Store submission, GitHub Pages publish, marketing email, social
post, push to default branch — REQUIRE that a human has visually confirmed
the artifact matches what the schema declares. Automated gates ("audit PASS",
"build green", "tests pass") are necessary but NOT sufficient. The schema can
say "the right thing is at this path"; only a human can confirm "the right
thing is actually IN the file."

**Why:** During the vapor-wares.com Speedrun deploy prep, the operator caught
that `public/web/index.html` was actually Hello World's product page, not the
Vapor Wares store landing. Every automated gate had passed (audit clean,
HTML valid, project structure correct, tests green). The AI was about to
greenlight `wrangler pages deploy` of the wrong content as the store front.
Only a human saying "I have not even seen the site!" prevented shipping the
wrong page to the canonical domain. Quote: "this is WHY needing a human to
verify is important still. I hate human in the loop, but goddamn. human in
the loop."

**How to apply:**
- Before suggesting a deploy / publish / submit / push action, ASK the
  operator to confirm they've SEEN the artifact (open the file, view the
  rendered output, screenshot the page).
- Render / open the artifact for them BEFORE proposing the action — don't
  rely on file paths or descriptions.
- If the operator hasn't seen it, halt and say "show first, deploy after."
- Treat passing automated gates as evidence, not authorization. The
  operator's eyes are the final gate for user-visible outcomes.
- This applies even if every gate in the release-ops item is green — if
  none of those gates were "human looked at it," ship is NOT ready.
- The schema has `HumanVisualVerification` shape on `ReleaseOperationItem`
  (added 2026-05-12); use it to record what the human inspected, when, and
  with what verdict.
