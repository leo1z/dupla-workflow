---
doc: SYSTEM_MAP
version: v2.4.0
updated: 2026-04-22
---

# Dupla-Workflow — System Map

How the system works, what each document does, and where tokens go.

---

## Document Layers

### Claude Code (IDE / CLI)

```mermaid
graph TB

    subgraph GLOBAL_C["🌐 GLOBAL — ~/.claude/"]
        GC["CLAUDE.md\nIdentity · Rules · Routing\n⚡ Always in context · ~1000 tokens/turn"]
        GS["SYSTEM.md\nProjects registry\n🔘 On demand only"]
        GP["PROBLEMS_GLOBAL.md\n🔘 Only if debugging cross-project"]
        SK["skills/*.md\n🎯 Zero cost until invoked\nTrigger: /skill-name"]
    end

    subgraph PROJECT_C["📁 PROJECT — ./"]
        PC["CLAUDE.md\nProject rules\n⚡ Always in context · ~200 tokens/turn"]
        PS["docs/PROJECT_STATE.md ⭐\n<session> block · ~60 tokens"]
        RD["docs/ROADMAP.md · docs/ARCHITECTURE.md\ndocs/PROBLEMS.md · 🔘 conditional"]
    end

    GC --> PC
    PS -->|read by /new-session| PS
```

### Antigravity (Gemini)

```mermaid
graph TB

    subgraph GLOBAL_A["🌐 GLOBAL — ~/.gemini/ + ~/.gemini/antigravity/"]
        GM["GEMINI.md\nIdentity · Rules · Routing\n⚡ Always in context (same as CLAUDE.md)"]
        WF["global_workflows/*.md\n🎯 Zero cost until invoked\nTrigger: /skill-name in Agent"]
    end

    subgraph PROJECT_A["📁 PROJECT — .agents/"]
        AR["rules/claude.md\nProject rules\n⚡ trigger: always_on"]
        AW["workflows/*.md\n🎯 Project-specific workflows\ntrigger: agent_requested"]
        PS2["docs/PROJECT_STATE.md ⭐\nSame file as Claude — shared source of truth"]
    end

    GM --> AR
    AR -->|instructs to read| PS2
```

**Clave:** `docs/PROJECT_STATE.md` es compartido — Claude y Gemini leen el mismo archivo. No se duplica.

---

## Token Cost — What Gets Loaded When

### Claude Code
| Document | When loaded | Tokens/turn | Skippable? |
|---|---|---|---|
| `~/.claude/CLAUDE.md` | **Always** — every session | ~1000 | No |
| `./CLAUDE.md` | **Always** — if exists in project | ~200 | No |
| `docs/PROJECT_STATE.md` `<session>` | Session start via `/new-session` | ~60 | Yes |
| `docs/ROADMAP.md` / `ARCHITECTURE.md` / `PROBLEMS.md` | Conditional | ~200-1000 | Yes |
| Skills `~/.claude/skills/*.md` | Only when `/skill-name` invoked | 0 baseline | Yes |
| `QUICKSTATE.md` | Micro sessions only | ~80 | Yes |

### Antigravity (Gemini)
| Document | When loaded | Tokens/turn | Skippable? |
|---|---|---|---|
| `~/.gemini/GEMINI.md` | **Always** — global identity | ~1000 | No |
| `.agents/rules/claude.md` | **Always** — `trigger: always_on` | ~200 | No |
| `docs/PROJECT_STATE.md` `<session>` | Session start — same file as Claude | ~60 | Yes |
| `docs/ROADMAP.md` / `ARCHITECTURE.md` | Conditional — same files as Claude | ~200-1000 | Yes |
| `~/.gemini/antigravity/global_workflows/*.md` | Only when `/skill-name` typed in Agent | 0 baseline | Yes |

**Without this system:** An LLM typically reads 3-5 docs per session = 2000-5000 tokens just to understand context.
**With this system:** Session start costs ~1260 tokens (CLAUDE.md global + project + session block).

---

## Can a New LLM Understand the Full Project from One File?

**Currently: partially.** The `<session>` block covers *what to do now* in ~60 tokens. For full architectural context a new LLM also needs `ARCHITECTURE.md`.

**Practical answer for handoffs (Claude → Gemini or new chat):**

```
1. Run /checkpoint → updates PROJECT_STATE.md
2. Tell next LLM: "Read docs/PROJECT_STATE.md first, then ARCHITECTURE.md if needed"
3. That's ~120-300 tokens total — sufficient for 90% of tasks
```

For deep architectural questions the LLM still needs `ARCHITECTURE.md`. The system doesn't eliminate that — it makes it conditional instead of constant.

---

## The Session Loop

```
/new-session                         /checkpoint
     │                                    │
     ▼                                    ▼
Read <session> (~60t)          Write <session> (update)
     │                                    │
     ▼                                    ▼
Conditional loads             Commit → push → handoff
(plan/build/debug only)
     │
     ▼
   WORK
(skills on-demand,
 hooks outside context)
```

---

## Micro Mode (QUICKSTATE)

For small projects or casual sessions — no `docs/` folder needed.

```
/quick-start                    /quick-start (existing)
      │                               │
      ▼                               ▼
  2 questions                  Read QUICKSTATE.md
  Creates QUICKSTATE.md        Show 5-line session
      │                               │
      ▼                               ▼
   WORK                           WORK
      │                               │
      ▼                               ▼
  /quick-start save          Update QUICKSTATE.md
```

Replaces `docs/PROJECT_STATE.md + ROADMAP.md + ARCHITECTURE.md` with one ~80-token file. Suitable for: scripts, experiments, research, non-code tasks, learning sessions.

---

## Code-Review Graph Lifecycle (docs/code-review-graph.json)

Structural fingerprint of the project. Zero token cost at session start — only loaded on demand.

```
/new-project or /adapt-project          /checkpoint (phase advance)
           │                                       │
           ▼                                       ▼
Generate code-review-graph.json       Update code-review-graph.json
 - project folders + file counts       - Set "phase" to current phase
 - risk zones (auth, DB, config)       - Update "lastCommit"
 - doc dependencies                    - Re-scan structure
 - "phase": "Phase 1"                  - Update risk zones if needed
           │                                       │
           ▼                                       ▼
  docs/code-review-graph.json      docs/code-review-graph.json (updated)
```

**When it's generated:** At project initialization (`/new-project`, `/adapt-project`).
**When it's updated:** When `/checkpoint` marks a ROADMAP Outcome as `[x]` (phase advances).
**When it's read:** On demand — for impact analysis, audits, or refactoring planning. Not loaded in normal sessions.

---

## 2026-04-22 — Antigravity Installation Detection

`bin/install.sh` now detects Antigravity across all known paths in priority order:

1. `~/.agent/` (Unix default) → deploys to `rules/`
2. `~/.gemini/antigravity/` (Windows confirmed) → deploys to `knowledge/`
3. `%USERPROFILE%/.agent/` (Windows fallback) → deploys to `rules/`
4. `%USERPROFILE%/.gemini/antigravity/` (Windows fallback) → deploys to `knowledge/`

Skills are wrapped with `trigger: agent_requested` frontmatter. `CLAUDE.md` is synced as `trigger: always_on`.

If binary exists but directory not found → user sees `find` command + `ANTIGRAVITY_DIR=<path>` override.
