Start work session. Read state, define next steps.

Usage: /new-session [optional goal]

---

## Execution

### Step 1 — Detect Project Type

Read YAML header of docs/PROJECT_STATE.md:
- `project_type: individual` → Individual flow (below)
- `project_type: team` → Team flow (below)
- No YAML / missing field → assume Individual (fallback)

---

### Step 2A — Individual Flow

1. **Read <session> block** from docs/PROJECT_STATE.md
   - Extract: Updated, Done, Next, Blockers, Branch, Model
   - If Updated > 24h OR git log is newer → auto-reconstruct from git log (silent)

2. **Load conditionally** (do NOT load all):
   - If planning → read docs/ROADMAP.md (current phase only)
   - If building → read docs/ARCHITECTURE.md (relevant section)
   - If debugging → read docs/PROBLEMS.md

3. **Show 3 most recent save points:**
```
Save points:
  3 · hace 2h   → "Conecta auth"
  2 · ayer 3pm  → "Setup inicial"
  1 · hace 3d   → "Init"
```

---

### Step 2B — Team Flow

1. **Identify who you are:**
   - Read `~/.claude/CLAUDE.md` → extract `Name:` field
   - If not found → ask: "¿Tu nombre? (para saber tu sección en el proyecto)"

2. **Read ONLY your Dev section** in docs/PROJECT_STATE.md:
   - Search for `### [Your Name]` section
   - Extract: Updated, Done, Next, Blockers, Dependencies
   - If Updated > 24h OR git log of your branch is newer → auto-reconstruct from git log

3. **Check dependencies:**
   - Read Dependencies field in your section
   - If "Waiting for [Dev X]" → check [Dev X]'s section (Updated + Done only, ~20 tokens)
   - Report: "⏳ Waiting for Dev X" or "✅ Dev X ready — you can proceed"

4. **Suggest branch:**
   - Read CLAUDE.md → ## Team → Members section → find your branch
   - If on wrong branch: "⚠️ Tu branch es work/[phase]-[role]. Cambia con: git checkout work/[phase]-[role]"
   - If branch doesn't exist: "git checkout -b work/[phase]-[role]"

5. **Load conditionally** (do NOT load all):
   - If planning → read your Role Assignments in ROADMAP.md (your section only)
   - If building → read docs/ARCHITECTURE.md (relevant section)
   - If debugging → read docs/PROBLEMS.md

---

## Output (max 12 lines)

**Individual:**
```
## Session — [date]

**Goal:** [from user arg / inferred from Next / ask if missing]
**Branch:** [current] [⚠️ if on main]
**LLM:** [from Model field / Claude]

**State:** [Done + Next in 1–2 lines]

**Plan:**
1. [concrete step]
2. [concrete step]
3. [if needed]

**Alert:** [blocker / stale state / conflict — if any]
```

**Team:**
```
## Session — [date] · [Your Name] ([Role])

**Branch:** work/[phase]-[role] [⚠️ if on wrong branch]
**LLM:** [recommended model]

**Your state:** [Done + Next from your section]

**Dependencies:**
→ ✅ Dev C (DB) ready — you can proceed
→ ⏳ Waiting for Dev B (UI) — blocked on their part

**Plan:**
1. [concrete step from your Next]
2. [concrete step]

**Alert:** [blocker / wrong branch / conflict — if any]
```

---

## Decision Logic

| Condition | Action |
|-----------|--------|
| project_type missing | Assume Individual (fallback) |
| No goal provided (individual) | Ask: "¿Cuál es el objetivo?" |
| Next field is clear | Don't ask goal — use Next |
| SESSION > 24h OR git log newer | Auto-reconstruct (no prompt) |
| status: STALE | Warn before continuing |
| Blockers ≠ "none" | Highlight in Alert |
| On main branch | ⚠️ Strong warning |
| git conflicts | Block, don't continue |
| Team: wrong branch | Suggest correct branch + git command |
| Team: dep not ready | Show who to wait for, suggest other work |

---

## Rules

- Max 12 lines. No filler.
- Individual: trust SESSION block first, git log second
- Team: read ONLY your Dev section + dependencies (~60 tokens total)
- Never load all docs upfront — only what session requires
- Never require previous /checkpoint — infer from git
- Show 3 save points as reference (individual only)
