---
name: brew is OK to invoke autonomously; npm is not
description: Operator preference 2026-05-18 — Homebrew commands (brew install / brew upgrade / brew list / etc.) are pre-authorized for autonomous invocation in mono substrate work. npm is NOT pre-authorized — surface npm requirements explicitly for operator decision; do not run npm install / npm exec / etc. autonomously. npx is npm-adjacent and likely falls under the same caveat (verify with operator before invoking). When tooling requires npm (e.g., deck2video's Marp/Slidev path uses `npx @marp-team/marp-cli`), surface the npm dependency as a blocker requiring operator approval, do not silently use brew-installed npm-shaped tools instead.
type: feedback
originSessionId: 088c9833-58f7-4dea-a3f3-7442f8ecdbdf
---
# brew is OK; npm is not

## The rule

- **brew**: pre-authorized for autonomous invocation in substrate work (any `brew install`, `brew upgrade`, `brew list`, `brew info`, etc. — no per-invocation operator approval needed).
- **npm**: NOT pre-authorized. Surface as a blocker. Do not invoke `npm install`, `npm exec`, `npm run`, `npm publish`, etc. autonomously.
- **npx**: npm-adjacent. Treat as npm-requiring unless operator explicitly clarifies. When `npx` is the substrate-canonical invocation path for a tool (Marp CLI, etc.), flag for operator and let them decide.

## Why

- **brew** is the macOS-canonical package manager for native binaries (Python, ffmpeg, openssl, etc.) — substrate has near-universal reliance on it for local dev tooling, and operator wants the friction removed.
- **npm** is operator-rejected as autonomous in mono. Possible reasons (not stated, inferring from substrate doctrine): npm's install surface is much larger and more network-touchy than brew; npm's supply-chain risk profile is higher; substrate's Swift-first + no-throwaway-scripts doctrine means JS deps should be deliberate, not casual.

## How to apply

- When a tool I want to run depends only on brew-installable deps → just run `brew install <pkg>` without asking.
- When a tool depends on npm/npx → STOP, surface the npm dependency explicitly, propose alternatives (e.g., if a Python-equivalent exists; if brew has the binary; if the tool can be run without the npm layer).
- When in doubt → ask. The cost of asking once is low; the cost of an unwanted npm install touching node_modules / package-lock state is higher.

## Concrete instances

- 2026-05-18 — `brew install python@3.11` for deck2video venv: brew-permitted, ran fine.
- 2026-05-18 — deck2video's Marp/Slidev rendering layer requires `npx @marp-team/marp-cli` per its README; this is the kind of dependency that needs operator surfacing rather than silent invocation.
