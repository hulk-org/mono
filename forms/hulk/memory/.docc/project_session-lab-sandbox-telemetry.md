---
name: Session Lab sandbox telemetry
description: New Sandbox route in Session Lab showing Claude Code temp state disk usage at /private/tmp/claude-{uid}/
type: project
---

Session Lab now has a Sandbox Telemetry panel showing Claude Code sandbox temp state.

**Why:** Claude Code writes tool outputs and CWD tracking files to /private/tmp/claude-{uid}/ with no cleanup — can grow to 100+ GB. Session Lab is the right place to surface this.

**How to apply:**
- Route: sandboxTelemetry in SessionLabRoute
- Model: SessionLabSandboxModel scans /private/tmp/claude-{uid}/ and /private/tmp/tmpclaude-*-cwd
- Panel: SessionLabSandboxPanel shows summary cards + per-project breakdown
- Next: retention policies (auto-trash files older than N days), session-level attribution (map outputs to specific Claude sessions), size alerts in overview panel
