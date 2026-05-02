---
name: Digikoma domain architecture
description: Six semantic domains (core/context/meta/directory/build/intelligence) with DAG dependency graph; core is foundation, Ghost spans all, Komo stay within their domain
type: project
---

Digikoma system organized into six semantic domains:

- **core** — senses (echo, read-file, scan-directory). No deps. Everything depends on this.
- **context** — Ghost's mind management (probe-context, split-concept, summarize-context). Deps: core.
- **meta** — fleet self-awareness (list, need, classify). Deps: core.
- **directory** — filesystem ops, swift-directory-tools lineage (validate-naming, validate-empty, fix-case, resolve-symlinks, flatten). Deps: core.
- **build** — build/deploy pipeline (validate-build, scaffold, web-deploy). Deps: core, directory.
- **intelligence** — strategic reasoning (triage, trace-graph). Deps: core, context.

**The rule:** higher domains can depend on lower, never reverse. The Ghost is the only entity that spans all domains. On-disk: `digikoma-org/mono/domain/<domain>/<komo>/`.

**Why:** Same structure as Google Maps (geocoding/routing/traffic/places/transit/street-view). Domains are semantic boundaries that determine what can depend on what.
