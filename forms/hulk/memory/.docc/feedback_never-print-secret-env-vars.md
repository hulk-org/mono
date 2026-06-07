---
name: Never print secret env var values
description: Inspect env for presence-only, never echo the value; `env | grep KEY` leaks secrets into the conversation log forever
type: feedback
originSessionId: e872cdc6-1460-4ade-ad66-91e2a2204223
---
When checking whether a secret env var is set, use the **count-only** form:

```bash
env | grep -c OPENAI_API_KEY     # 0 or 1
test -n "$OPENAI_API_KEY" && echo "set" || echo "unset"
[ -n "$OPENAI_API_KEY" ]; echo "set=$?"
```

**Never** use:

```bash
env | grep OPENAI_API_KEY     # prints KEY=<secret>
echo $OPENAI_API_KEY          # prints the secret
env                           # prints everything including secrets
```

**Why:** any value printed to stdout lands in the conversation log
permanently. Substrate logs are append-only artifacts that survive
sessions, get committed to chronicles, and may be replayed for context.
A secret that leaks into the log requires rotation; a presence-check
that says "1" or "set" requires nothing.

**How to apply:**
- Any time you're checking for an env var whose name contains `KEY`,
  `TOKEN`, `SECRET`, `PASSWORD`, `API`, `CREDENTIAL`, or starts with
  `APP_STORE_CONNECT_` / `OPENAI_` / `ANTHROPIC_` / `GITHUB_TOKEN` /
  etc., use the count-or-presence form.
- Same rule for files: never `cat ~/.appstoreconnect/credentials/*.json`
  or similar; use `test -f` instead.
- If a secret has already leaked to the log: **flag it to the operator
  immediately** so they can rotate. Don't try to scrub the conversation
  yourself; rotation is the only reliable fix.

**Incident: 2026-05-14** — I ran `env | grep OPENAI_API_KEY` while
checking whether the localize fastlane tool could find an API key. The
key value (sk-proj-...) got printed to the bash output and into the
conversation log. Operator was alerted; key rotation pending.
