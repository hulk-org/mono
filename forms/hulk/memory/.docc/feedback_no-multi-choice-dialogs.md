---
name: no-multi-choice-dialogs
description: Operator strongly dislikes AskUserQuestion multi-choice option dialogs — prefers conversational text replies even for routing decisions
metadata:
  node_type: memory
  type: feedback
  originSessionId: cc7219dc-1f59-41e7-8a0b-8fde70593167
---

Stop using AskUserQuestion for routing decisions, option-picking, or "which path do you prefer" prompts. Operator quote 2026-06-03: "can you stop with those chat dialogs? they suck. let's chat."

**Why:** The dialog UI is an interaction-mode mismatch with how the operator works with me — they want substrate-shaped conversation (named decisions, doctrine, back-and-forth) not a multi-option picker. Even when I think the choice would benefit from option-comparison previews (like the rename-depth or P5-routing dialogs I shipped 2026-06-03), the dialogs interrupt the conversational flow and add ceremony that doesn't help them think. The operator was specifically annoyed by repeated dialogs across a single cascade.

**How to apply:**
- For decisions, ask in plain text — short questions, name the options inline, let them reply conversationally.
- ExitPlanMode (one-time plan approval) is fine — that's a different surface, not a routing dialog.
- Never use AskUserQuestion to pick between conversational-shaped options ("which path?", "how should we proceed?", "what depth?").
- Reserve AskUserQuestion only for genuinely UI-shaped decisions where a preview meaningfully helps (visual mockup comparisons, code-style choice with side-by-side rendering).
- Default: chat. The operator wants a peer dialog, not a wizard.

**Composes with:**
- [[brevity-is-respect]] — multi-option dialogs are the opposite of brevity; they front-load ceremony.
- Operator's substrate-tone preference: substrate work happens in named-decision conversation, not form-filling.
