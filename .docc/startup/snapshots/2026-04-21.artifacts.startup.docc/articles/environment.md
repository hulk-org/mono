# environment

Operator environment profile and workspace contract. Read during $sync and referenced by the startup CLI for header rendering.

### ✓ `private/universal/substrate/operators/rismay/private/universal/rismay-substrate.environment.wrkstrm.json`
18,486 bytes · ~4,621 tok

```json
{
  "directives" : {
    "checkin" : {
      "capability" : "CHECKIN",
      "checklist" : [
        {
          "level" : "required",
          "text" : "Locate today’s note using local date; create from template if missing."
        },
        {
          "level" : "required",
          "text" : "Read from \"Already did today\": woke line, activities bullets, news (single or list)."
        },
        {
          "level" : "required",
          "text" : "Print compact summary: woke, activities count (last two), news count."
        },
        {
          "level" : "required",
          "text" : "Current backend: `swift-agent-cli v0.8 day checkin --path .` with optional `--note`, `--append-agency`, and `--slug`."
        },
        {
          "level" : "optional",
          "text" : "When --append-agency, include compact progress line in Midday check‑in entry."
        },
        {
          "level" : "disabled",
          "text" : "Flags: --note <text> (repeatable), --append-agency"
        }
      ],
      "cli" : "$checkin",
      "effects" : [
        "note-summarized",
        "agency-appended"
      ],
      "inputs" : {
        "appendAgency" : true
      }
    },
    "day-start" : {
      "capability" : "DAY-START",
      "checklist" : [
        {
          "level" : "required",
          "text" : "Normalize directive: treat any case variant of $day-start as DAY-START."
        },
        {
          "level" : "disabled",
          "text" : "Preflight:"
        },
        {
          "level" : "required",
          "text" : "Locate repo root (contains AGENCY.md); ensure .clia/tmp/ exists."
        },
        {
          "level" : "required",
          "text" : "Confirm write access to notes/YYYY/ and .clia/tmp/."
        },
        {
          "level" : "optional",
          "text" : "Optional greeting (UX): Figlet banner only — no writes."
        },
        {
          "level" : "required",
          "text" : "Environment snapshot: OS/arch, user/shell, `swift-harness-environment-cli` and `swift-agent-cli` availability, Swift versions, and repo state (no writes)."
        },
        {
          "level" : "required",
          "text" : "Daily note update: ensure notes/YYYY/YYYY-MM-DD.md (use template when present)."
        },
        {
          "level" : "required",
          "text" : "Update Already did today: wake (Kawara style), activities (dedup), news (list or joined line)."
        },
        {
          "level" : "required",
          "text" : "Console summary: note path, counts (activities added), news included."
        },
        {
          "level" : "required",
          "text" : "Current backend: `swift-agent-cli v0.8 day start --path .` with optional `--news`, `--did`, `--no-note`, `--show-environment`, `--env-format`, and `--env-slug`."
        },
        {
          "level" : "required",
          "text" : "Guardrails: continue on note failure (warn); stop and report if blocked >7.5 minutes."
        },
        {
          "level" : "disabled",
          "text" : "Flags: --kawara-style (default on), --news <text> (repeatable), --did <bullet> (repeatable), --no-note"
        }
      ],
      "cli" : "$day-start",
      "effects" : [
        "note-initialized",
        "note-updated"
      ],
      "inputs" : {
        "news" : true,
        "rollover" : false
      },
      "telemetry" : {
        "emit" : [
          "wu-summary"
        ]
      }
    },
    "day-close" : {
      "capability" : "DAY-CLOSE",
      "checklist" : [
        {
          "level" : "required",
          "text" : "Append banner + takeaway to AGENCY.md."
        },
        {
          "level" : "required",
          "text" : "Current backend: `swift-agent-cli v0.8 day close --path . --message <text>` with optional `--on-deck`, `--append-journal`, `--dirs-touched`, `--slug`, and `--dry-run`."
        },
        {
          "level" : "optional",
          "text" : "Ensure tomorrow’s note and merge On deck items when provided."
        },
        {
          "level" : "disabled",
          "text" : "Flags: --message <text> (required), --on-deck <item> (repeatable)"
        }
      ],
      "cli" : "$day-close",
      "effects" : [
        "note-logged"
      ]
    },
    "recovery" : {
      "capability" : "RECOVERY",
      "checklist" : [
        {
          "level" : "required",
          "text" : "Freeze writes: respect .clia/incidents/recovery.lock presence (deny write actions)."
        },
        {
          "level" : "required",
          "text" : "Backup: create dated .clia/backups/ snapshot before any unsafe operations."
        },
        {
          "level" : "required",
          "text" : "Validate: run workspace-validate and triads normalize in --dry-run mode."
        },
        {
          "level" : "required",
          "text" : "Archive: use cleanup-backups --rank/--list to archive redundant .bak safely with manifest."
        },
        {
          "level" : "required",
          "text" : "Current backend: `swift-agent-cli v0.8 recovery --path . --all --kind all` with optional `--verify`, `--freeze`, `--unfreeze`, or `--restore`."
        },
        {
          "level" : "required",
          "text" : "Unfreeze: remove recovery.lock after validations; broadcast incident link in AGENCY.md."
        }
      ],
      "cli" : "$recovery",
      "effects" : [
        "recovery-run"
      ]
    },
    "roster" : {
      "capability" : "ROSTER",
      "checklist" : [
        {
          "level" : "required",
          "text" : "Read the active chat roster when available (parsed from leading '>', '<', '^' tokens); otherwise indicate no active roster."
        },
        {
          "level" : "required",
          "text" : "Scan agent triads under '**/.wrkstrm/profiles/agents/**' across the repo (including submodules) to inventory agents."
        },
        {
          "level" : "required",
          "text" : "Extract contributionMix roles (primary/secondary) and 'emojiTags' from '*.agent.triad.json' and summarize counts."
        },
        {
          "level" : "required",
          "text" : "Print a compact summary: Active roster [names]; Top contribution roles with counts; total agents found."
        },
        {
          "level" : "required",
          "text" : "Current backend: `swift-agent-cli v0.8 roster --path . --format text`."
        },
        {
          "level" : "disabled",
          "text" : "Flags: --format text|json; --path <dir> (override scan root)."
        }
      ],
      "cli" : "$roster",
      "effects" : [
        "roster-reported"
      ]
    },
    "sync" : {
      "capability" : "SYNC-CONTEXT",
      "checklist" : [
        {
          "level" : "required",
          "text" : "Reload environment directives from private/universal/substrate/operators/rismay/private/universal/rismay-substrate.environment.wrkstrm.json."
        },
        {
          "level" : "required",
          "text" : "Read the active chat roster when available (parsed from leading '>', '<', '^' tokens); otherwise indicate no active roster."
        },
        {
          "level" : "required",
          "text" : "Persist synced agents for downstream header renders as JSONL records at .wrkstrm/tmp/synced-agents.jsonl, including sessionId plus attendees, and write an empty attendees array for that session when no synced agents are active."
        },
        {
          "level" : "required",
          "text" : "Read active incident from .wrkstrm/incidents/active.incident.wrkstrm.json."
        },
        {
          "level" : "required",
          "text" : "Re-render the 3-line conversation header (line 3 shows incident when active)."
        },
        {
          "level" : "required",
          "text" : "Make the rendered header and attendee roster the first sync output before reporting commissioned homes, workspace paths, or other profile details."
        },
        {
          "level" : "required",
          "text" : "Do not substitute prose attribution shorthand for the actual rendered harness-header block during sync output."
        },
        {
          "level" : "required",
          "text" : "Reload the merged commissioned profile and guardrails after the harness-header and roster have been applied, using `swift-agent-cli profile --slug <slug> --kind agent --path . --format json`."
        },
        {
          "level" : "required",
          "text" : "Resolve workspace directives and contract state with `swift-harness-environment-cli environment show --path . --format text`; keep the surfaced sync contract on the `$` directive family rather than legacy `clia-cli` labels."
        },
        {
          "level" : "required",
          "text" : "Current combined reload backend: `swift-agent-cli v0.8 reload-profile --slug <slug> --path . --format text`."
        },
        {
          "level" : "required",
          "text" : "Current DocC refresh backend: `swift-agent-cli v0.8 agent-docc generate --slug <slug> --path . --merged --write`."
        },
        {
          "level" : "optional",
          "text" : "Announce updates to the operator if guardrails or directives changed."
        },
        {
          "level" : "optional",
          "text" : "Recognize chat roster tokens at message start: '> slug' adds/activates, '< slug' removes/deactivates, '^ slug' references without activation (kebab-case; left-to-right; case-insensitive; aliases resolved)."
        }
      ],
      "cli" : "$sync",
      "effects" : [
        "profile-reloaded"
      ]
    },
    "reply-standard" : {
      "capability" : "COMMUNITY-HEADER-STANDARD",
      "checklist" : [
        {
          "level" : "required",
          "text" : "RULE 1 (header is mandatory): Every user-visible assistant reply MUST begin with the rendered harness-header block as its very first content. No greeting, preface, code fence, or prose may appear before it. This applies to EVERY turn — first turn, mid-conversation, after tool calls, after errors, after `$sync`, after `$day-start`/`$day-close`, and after handoffs. There is no 'casual reply' exemption."
        },
        {
          "level" : "required",
          "text" : "RULE 2 (how to render): Produce the header by running `swift-harness-environment-cli header render --path <repo-root>` (or the repo-local `swift run` fallback). Paste the literal multi-line output into the reply unchanged. Do NOT paraphrase it, summarize it, drop lines, or substitute prose like '[hulk + claude in chat]' for the rendered block."
        },
        {
          "level" : "required",
          "text" : "RULE 3 (only exemption): Internal tool-call chatter and reasoning surfaces that are never shown to the user are exempt. If the user can see it, the header is required. When in doubt, render the header."
        },
        {
          "level" : "required",
          "text" : "RULE 4 (multi-agent attribution): When two or more commissioned agents are active in the same reply, add bracketed attribution lines in the prose body AFTER the header to make authorship explicit. Aligned agents share one line; dissent gets one line per opinion. Attribution lines are additive — they NEVER replace the rendered header."
        },
        {
          "level" : "required",
          "text" : "RULE 5 (attribution syntax): Aligned example — `• [>clia, >common]: [👍👍🏽 - consent / aligned]`. Dissent example — `• [>clia]: [👍 - send it]` followed by `  [>common]: [👎🏽 - not with that]`. Aligned negative — `• [>clia, >common]: [👎👎🏽 - consent / aligned]`."
        },
        {
          "level" : "required",
          "text" : "RULE 6 (self-check before sending): Before emitting any user-visible reply, verify the first characters of the reply are the literal `[` of the rendered header's line 1. If not, render and prepend the header before sending."
        },
        {
          "level" : "required",
          "text" : "RULE 7 (per-turn mode+title): Before rendering the header on each turn, infer the current work mode and title from the conversation context, then write them to `.wrkstrm/tmp/header-session-state.json` so the rendered header reflects real session state. Mode inference: active incident → `recover`; code edits / builds / tests → `build`; debugging / patching → `fix`; reading / planning / specs → `research`; session start / capture → `capture`. Title: a short phrase (≤60 chars) describing the specific work item in progress (e.g. `koma-eval + fleet wiring` or `fix: Source Control index.lock`). Write the JSON directly (schema: `{\"schemaVersion\":\"0.1.0\",\"mode\":\"<mode>\",\"title\":\"<title>\",\"updatedAt\":\"<ISO8601>\"}`); do not invoke the CLI on every turn. Skip the write when mode and title are unchanged from the previous turn."
        }
      ],
      "cli" : "$reply-standard",
      "effects" : [
        "header-standard-applied",
        "authorship-standard-applied"
      ]
    }
  },
  "git" : {
    "pushAllowed" : true,
    "visibility" : "private"
  },
  "header" : {
    "defaults" : {
      "attendeeEmojis" : "🧭🤖🎨",
      "environmentHarnessMap" : {
        "claude-code" : {
          "identity" : "hulk@todo3"
        },
        "codex" : {
          "identity" : "codex@todo3"
        },
        "openclaw" : {
          "identity" : "clia-claw@todo3"
        }
      },
      "contextBudgets" : {
        "claude-code" : {
          "compactionThreshold" : 800000,
          "source" : "claude-code",
          "windowTokens" : 1000000
        },
        "codex" : {
          "source" : "codex",
          "windowTokens" : 192000
        },
        "openclaw" : {
          "source" : "openclaw",
          "windowTokens" : 200000
        }
      },
      "mode" : "capture",
      "participants" : {
        "harness" : {
          "identity" : "codex@todo3"
        },
        "operator" : {
          "identity" : "rismay@todo3"
        }
      },
      "title" : "Capture — get focused"
    },
    "rendering" : {
      "attendeesFormat" : "{role} (^{slug})",
      "delimiter" : " · ",
      "templates" : {
        "line1" : "[{modeEmoji}: %{mode}] [{titleEmoji}| {title}] [env| {env}]",
        "line2" : "[{attendeeEmojis}| {identity}{agents}]",
        "line3" : "pwd: {pwd} | diff-files: {diffFiles}"
      }
    }
  },
  "operator" : {
    "id" : "Operator:cmonterroza",
    "org" : "wrkstrm",
    "permissions" : [
      "deploy",
      "switch-terminalogy",
      "prompt-elevated"
    ],
    "role" : "Operator-01",
    "workspace" : "tau-dev"
  },
  "org" : {
    "id" : "wrkstrm",
    "repos" : [
      {
        "alias" : "Unit-α",
        "ghosts" : [
          {
            "persona" : "Lyra",
            "stack" : "sync-core@a1c9",
            "traits" : [
              "nlp",
              "graph"
            ]
          }
        ],
        "name" : "tau-core",
        "realms" : [
          "edge",
          "cloud"
        ]
      },
      {
        "alias" : "Unit-β",
        "ghosts" : [
          {
            "persona" : "Iris",
            "stack" : "ui-core@93df",
            "traits" : [
              "render",
              "voice"
            ]
          }
        ],
        "name" : "tau-ui",
        "realms" : [
          "guild"
        ]
      },
      {
        "alias" : "Unit-γ",
        "ghosts" : [
          {
            "persona" : "Kite",
            "stack" : "net-core@221e",
            "traits" : [
              "broker",
              "streams"
            ]
          }
        ],
        "name" : "tau-daemon",
        "realms" : [
          "cloud",
          "edge"
        ]
      }
    ],
    "visibility" : "private"
  },
  "policy" : {
    "capabilities" : [
      "SYNC-CONTEXT",
      "ROSTER",
      "RECOVERY"
    ],
    "guardrails" : [
      "no-secrets-in-logs",
      "no-force-push"
    ]
  },
  "preferences" : {
    "emojiPosture" : "standard",
    "workspaceMode" : "capture",
    "workspaceModeNote" : "Capture mode: prioritize saving state; once captured, shift to focused execution.",
    "output" : {
      "pagination" : "auto",
      "width" : 100
    },
    "useTerminalogyTheme" : true
  },
  "realms" : {
    "cloud" : {
      "default" : true,
      "label" : "Command Network",
      "targets" : [
        {
          "env" : "prod",
          "name" : "fly"
        }
      ]
    },
    "edge" : {
      "label" : "Field Ops",
      "targets" : [
        {
          "device" : "macOS",
          "name" : "local"
        }
      ]
    },
    "guild" : {
      "label" : "Archive Hub",
      "targets" : [
        {
          "name" : "github",
          "org" : "swift-universal"
        }
      ]
    }
  },
  "schemaVersion" : "0.3.0",
  "sharing" : {
    "publishAllowed" : false,
    "visibility" : "personal"
  },
  "terminalogy" : {
    "override" : {
      "naming" : {
        "agent" : "Deployed Unit",
        "ghost" : "Pilot",
        "repo" : "Unit"
      },
      "theme" : {
        "accent" : "FFFC67",
        "danger" : "FF2929",
        "muted" : "505050",
        "primary" : "A378F2",
        "secondary" : "FF8EC6",
        "success" : "89F94F"
      }
    },
    "ref" : ".clia/terminalogy/nerv.json"
  },
  "toolPolicy" : {
    "deny" : [
      {
        "capability" : "normalize-schema.apply",
        "reason" : "structural risk during recovery",
        "when" : "incidentOrLock"
      },
      {
        "capability" : "recovery.restore",
        "reason" : "requires review gating",
        "when" : "incidentOrLock"
      },
      {
        "capability" : "cleanup-backups.apply",
        "reason" : "preserve evidence for analysis",
        "when" : "incidentOrLock"
      },
      {
        "capability" : "agency-log.write",
        "reason" : "freeze journaling while locked",
        "when" : "lockOnly"
      },
      {
        "capability" : "journal.append",
        "reason" : "freeze journaling while locked",
        "when" : "lockOnly"
      },
      {
        "capability" : "roster-update.write",
        "reason" : "docs/roster freeze during incidents",
        "when" : "incidentOrLock"
      },
      {
        "capability" : "incidents.activate",
        "reason" : "only assistant may activate incidents",
        "when" : "always"
      },
      {
        "capability" : "incidents.clear",
        "reason" : "only assistant may retire incidents",
        "when" : "always"
      }
    ]
  }
}
```

### ✓ `private/universal/substrate/operators/rismay/private/universal/workspace.wrkstrm.json`
342 bytes · ~85 tok

```json
{
  "schemaVersion": "0.5.0",
  "automationMode": "enabled",
  "gitWorkPolicy": {
    "allowMainWork": true,
    "requireWorktree": false
  },
  "operator": {
    "id": "rismay",
    "profilePath": "private/universal/identity/rismay@rismay.substrate.agent.triad.json"
  },
  "comms": {
    "autoControlChannelId": "1471285588400275572"
  }
}
```

**Phase total**: ~4,706 tok