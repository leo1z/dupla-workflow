Start work session. Read state, define next steps.

Usage:
  /new-session              → start or resume session
  /new-session [goal]       → start with specific goal
  /new-session standup      → Team Lead: consolidated team status table

---

## ⚡ Handoff Reception (when you receive a <handoff> block)

If the user's message contains a `<handoff>` block (pasted from another model/session):

1. Read the block: `Date`, `From`, `To`, `Project`, `Goal`, `Branch`, `Done`, `Next`
2. Confirm you received it:
   ```
   ✅ Handoff recibido — [From] → [To]
   Proyecto: [Project] · Branch: [Branch]
   Continuando desde: [Next]
   ```
3. Locate the project: the `Project:` field contains the path — navigate there mentally
4. Proceed with `/new-session` flow below (the handoff block replaces a stale SESSION read)
5. In the output, show `**Handoff from:** [From model/dev]` instead of save points

> This is the protocol for Claude ↔ Gemini ↔ dev handoffs. The handoff block is the bridge.

---

## Execution

### Step 0A — Check claude-progress.txt (lightweight task state)

Before reading PROJECT_STATE, check if `claude-progress.txt` exists in the current directory:
- **Found** → read it entirely (~30 tokens max). Show in-progress tasks `[>]` in the output Plan section.
- **Not found** → skip silently. Do not create it.

Format of claude-progress.txt:
```
[ ] tarea pendiente
[>] tarea en curso ahora
[x] tarea completada
```

### Step 0B — Check _versions/ (for projects without git)

If `_versions/` directory exists AND no `.git/` directory:
- List the 3 most recent snapshot folders (by name, descending)
- Note in the output: "📂 Snapshots disponibles — /restore para recuperar uno anterior"
- Do not auto-restore. Just inform.

---

### Step 1 — Detect Project Type

First, check for `QUICKSTATE.md` in the current directory:
- **Found** → Micro flow: delegate entirely to `/quick-start` skill and stop here

If no `QUICKSTATE.md`, check if `docs/PROJECT_STATE.md` exists:
- **Not found** → stop and show:
  ```
  ❌ Este proyecto no está inicializado en Dupla-Workflow.

  ¿Proyecto existente?  → /adapt-project
  ¿Proyecto nuevo?      → /new-project
  ¿Sesión pequeña?      → /quick-start
  ```
- **Found** → read YAML header:
  - `project_type: individual` → Individual flow (below)
  - `project_type: team` → Team flow (below)
  - No YAML / missing field → assume Individual (fallback)

---

### Step 2A — Individual Flow

1. **Read <session> block** from docs/PROJECT_STATE.md
   - If SESSION contains placeholder values (e.g., `Updated: YYYY-MM-DD`, `Done: -`, `Next: [...]`) → treat as first session, skip staleness check, go to output
   - Check for `<handoff>` block in PROJECT_STATE.md → if found, read it (Date, From, Done, Next) and use as context BEFORE reading SESSION
   - Extract: Updated, Done, Next, Blockers, Branch, Model, **Phase, Phase_Status, Mode**
   - **Mode field:** if missing or blank → assume `full`
   - **Mode: research** → note in output "🔬 Modo Research — investigar, no construir"
   - **Mode: lite** → if no docs/ folder, redirect to /quick-start; else continue with lite output (no roadmap phase read)
   - **Mode: full** → flujo normal completo
   - If Updated > 24h OR git log is newer → auto-reconstruct from git log (silent)
   - **Phase: N/A check:** if `Phase: N/A` AND `docs/ROADMAP.md` exists → show once:
     ```
     ℹ️ Tienes docs/ROADMAP.md pero Phase está en N/A.
        ¿Quieres activar el tracking de fase? [s/n]
        (Si sí → leo el ROADMAP y te sugiero en qué fase estás)
     ```
     - If yes → read ROADMAP.md, infer current phase from git log + outcomes, update SESSION Phase field
     - If no → continue with Phase: N/A (won't ask again this session)
   - **Check for missed checkpoint:** compare `SESSION.Updated` vs date of latest commit
     - If git has commits newer than SESSION.Updated AND Phase ≠ "N/A" → missed checkpoint detected
     - Run ROADMAP phase sync inline (same as checkpoint step 2.5):
       - Compare those commits vs current phase Outcomes
       - Mark any delivered Outcomes as `[x]` in ROADMAP.md
       - If GO/NO-GO criteria now met → set `Phase_Status: GO/NO-GO Pending`
     - Update SESSION.Done from git log, SESSION.Updated to now
     - Note in output: `📌 Sesión anterior sin checkpoint — ROADMAP sincronizado desde git`
     - This runs silently if nothing changed in the phase

2. **Read current Roadmap phase** (always, lightweight — ~100 tokens):
   - If Phase ≠ "N/A" AND docs/ROADMAP.md exists:
     - Read ONLY the section matching `## Phase [N]` from ROADMAP.md (from that heading to the next `##`)
     - Extract: Outcomes, GO/NO-GO criteria (Continue if / Kill if)
     - Do NOT read the full ROADMAP — only the current phase
   - This tells you: where we are strategically, what this phase needs to deliver, and when to trigger GO/NO-GO
   - The Roadmap is the strategic compass — it defines what "done" means for the phase, not the daily task list

3. **Load conditionally** based on keywords in `Next` field:

   | Signal in Next | Load |
   |---|---|
   | "plan", "decide", "fase", "roadmap", "evaluar", "definir", "investigar" | Full docs/ROADMAP.md (adjacent phases too) |
   | "implement", "build", "code", "crear", "desarrollar", "conectar", "integrar" | docs/ARCHITECTURE.md (relevant section) |
   | "fix", "error", "bug", "no funciona", "problema", "roto", "broken" | docs/PROBLEMS.md |
   | None of the above | No additional load — session block + phase section is sufficient |

4. **Show 3 most recent save points:**
```
Save points:
  3 · hace 2h   → "Conecta auth"
  2 · ayer 3pm  → "Setup inicial"
  1 · hace 3d   → "Init"
```

---

### Step 2B — Team Flow

**Special mode: `/new-session standup`** (Lead only — consolidated team view)
- Read ALL `### [Dev Name]` sections in PROJECT_STATE.md + `## Shared Status`
- Show:
  ```
  ## Standup — [date] · [Project] Phase [N]

  | Dev       | Branch         | Hizo          | Siguiente        | Bloqueado |
  |-----------|----------------|---------------|------------------|-----------|
  | Dev A     | work/ph1-back  | auth endpoint | tests + PR       | No        |
  | Dev B     | work/ph1-front | login UI      | Waiting Dev A PR | Sí ⏳     |
  | Dev C     | work/ph1-db    | schema        | migración        | No        |

  PRs pendientes de merge: [list branches not yet merged to main]
  GO/NO-GO status: [Phase_Status from Shared Status]
  ```
- Max 15 lines. No planning, no branch suggestions — solo el estado del equipo.
- Return after showing standup (don't continue with individual dev flow)

**If first time (no section found for dev AND git log shows <2 commits on branch):**
```
Bienvenido al equipo. Día 1:
  1. git clone [repo-url] (si aún no lo tienes)
  2. git checkout work/[tu-branch]  ← Lead ya lo creó
  3. Verifica que tu sección exista en docs/PROJECT_STATE.md
     → Si no existe: avisa al Lead → /add-team-member
  4. Lee docs/PROJECT_STATE.md → tu sección + ## Shared Status
  5. Lee CLAUDE.md → ## Team + ## Git Strategy
  6. Continúa con /new-session para tu primera sesión
```

1. **Identify who you are:**
   - Read `~/.claude/CLAUDE.md` → extract `Name:` field (use FIRST name only for matching — e.g., "Leo Borjas" → search for "Leo")
   - If not found → ask: "¿Tu nombre? (para saber tu sección en el proyecto)"
   - Check for `<handoff>` block in PROJECT_STATE.md → if found and `To:` matches your name/role, read it before Dev section

2. **Read your Dev section + Shared Status** in docs/PROJECT_STATE.md:
   - Search for `### [Your First Name]` section (partial match — "Leo" matches "### Leo (Backend)")
   - Extract: Updated, Done, Next, Blockers, Dependencies
   - Also read `## Shared Status` → extract Phase and Phase_Status (~10 tokens)
   - If Updated > 24h OR git log of your branch is newer → auto-reconstruct from git log

3. **Check dependencies:**
   - Read Dependencies field in your section
   - If "Waiting for [Dev X]" → check [Dev X]'s section (Updated + Done only, ~20 tokens)
   - Report: "⏳ Waiting for Dev X" or "✅ Dev X ready — you can proceed"

4. **Suggest branch:**
   - Read CLAUDE.md → ## Team → Members section → find your branch
   - If branch not in CLAUDE.md → read ROADMAP.md current phase → infer `work/phase[N]-[your-role]`
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

**Phase:** [Phase N — name] · [🟡 In Progress / ⚠️ GO/NO-GO Pending / ✅ Complete / N/A]
**Mode:** [🔬 Research / ⚡ Lite / 🔨 Full] · **Goal:** [from user arg / inferred from Next / ask if missing]
**Branch:** [current] [⚠️ if on main]
**LLM:** [from Model field / Claude]

**State:** [Done + Next in 1–2 lines]
**Phase progress:** [what this phase needs to deliver — 1 line from ROADMAP]

**Plan:**
1. [concrete step — aligned with phase outcome]
2. [concrete step]
3. [if needed]

**Alert:** [blocker / stale state / GO/NO-GO criteria met / conflict — if any]
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
| QUICKSTATE.md found | Micro flow — delegate to /quick-start |
| docs/PROJECT_STATE.md not found | Stop — show /adapt-project / /new-project / /quick-start options |
| project_type missing | Assume Individual (fallback) |
| SESSION has placeholder values | First session — show output, skip staleness |
| handoff block found | Read it first, use as additional context |
| Phase ≠ "N/A" | Read current phase section from ROADMAP (~100 tokens) |
| Phase = "N/A" or no ROADMAP | Skip roadmap read |
| git commits newer than SESSION.Updated AND Phase ≠ "N/A" | Missed checkpoint — run ROADMAP sync inline, note in output |
| Phase_Status = "GO/NO-GO Pending" | ⚠️ Alert: GO/NO-GO evaluation needed before continuing |
| Next has planning keywords | Load full ROADMAP (adjacent phases too) |
| Next has building keywords | Load ARCHITECTURE (relevant section) |
| Next has debug keywords | Load PROBLEMS.md |
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
