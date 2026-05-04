Onboard existing project into Dupla-Workflow. Asks first, shows diffs, preserves existing docs.

**When to use:** When you have an existing repo and want to add Dupla structure to it. Run once per project.
**See also:** `/new-project` (brand new project from scratch) · `/check-project` (validate docs after onboarding) · `/adapt-to-team` (convert to team mode)

Usage: /adapt-project

---

## Phase 0.5 — Detect QUICKSTATE.md (micro → full upgrade)

Before anything else, check if `QUICKSTATE.md` exists in the current directory:

**Found:**
```
Encontré QUICKSTATE.md — este es un proyecto micro escalando a completo.

Contenido actual:
  What: [value]
  Done: [value]
  Next: [value]

Usaré esto para pre-llenar PROJECT_STATE.md. El archivo se archivará en docs/ARCHIVE.md.
¿Continuar? [s/n]
```

If YES → read QUICKSTATE.md and store values:
- `What` → use as project description in PROJECT_STATE.md and CLAUDE.md
- `Done` → pre-fill SESSION.Done
- `Next` → pre-fill SESSION.Next
- Archive QUICKSTATE.md to `docs/ARCHIVE.md` at end of Phase 4

**Not found:** → continue to Phase 1 normally.

---

## Phase 1 — Ask First

"Where is the project docs? (Enter project root path or current if here)"

Wait for answer, then:
1. Run: `git log --oneline -10`, `git branch --show-current`, `git status --short`
2. Read: CLAUDE.md (if exists), README.md, package.json/equiv
3. List: docs/ contents
4. Check: which workflow docs exist
   - docs/PROJECT_STATE.md?
   - docs/PROBLEMS.md?
   - docs/ROADMAP.md?
   - docs/ARCHITECTURE.md?

---

## Phase 2 — Report Gaps

Show checklist BEFORE doing anything:

```
## Adapt Report — [project name]

**Found:**
- [existing files]

**Missing:**
- [needed files]

**Mapping:**
- Old doc [X] → New location docs/[Y]
- [other mappings]

**CLAUDE.md:** [matches template / needs update / doesn't exist]

Proceed? [s/n]
```

Wait for confirmation.

---

## Phase 3 — Map Old Docs to New Schema

If docs exist with old names (DECISIONS.md, KANBAN.md, etc.):
- Show mapping: OLD → NEW
- Ask for each: "Keep as docs/ARCHIVE.md? [s/n]"
- Create docs/ARCHIVE.md if user says yes
- Archive = preserved reference without interfering with new system

Preserve: don't delete, archive instead.

---

## Phase 4 — Generate Missing Docs

### docs/PROJECT_STATE.md

**If missing:** Create from PROJECT_STATE_TEMPLATE.md.
**If exists with real SESSION data (Updated ≠ placeholder):**
- NEVER overwrite — show the existing SESSION block and ask:
  ```
  Encontré SESSION block existente con datos reales.
  ¿Qué hago?
    1 — Mantenerlo (solo agrego campos faltantes como Mode si no están)
    2 — Reemplazarlo (el actual se muestra primero para que lo copies)
  ```
  - Option 1 (default): only add missing fields (e.g., `Mode: full`) — do not touch Done/Next/Branch
  - Option 2: show full current SESSION → ask explicit confirmation → replace

**Fields to fill (when creating or user chose replace):**
- `project_type: individual` (default — change after if team)
- `Mode: full` (default — user changes as needed)
- `Updated:` → today
- `Done:` → last 3 git log entries (or "Initial setup")
- `Next:` → inferred from README/git (mark [inferred])
- `Status: ACTIVE`
- `Branch:` → `git branch --show-current`
- `Phase:` → from ROADMAP if exists, else `N/A`
- `Phase_Status:` → `In Progress` if ROADMAP found, `N/A` if not

### docs/PROBLEMS.md (if missing)
- Create empty from template
- Add note: "Start documenting issues as they arise"

### docs/ROADMAP.md
- **If missing:** Create placeholder with note "PENDING — use /new-project IML assessment or fill manually"
- **If exists:** Show first 20 lines and ask:
  ```
  Encontré docs/ROADMAP.md existente.
  ¿Qué hago?
    1 — Mantenerlo (solo agrego YAML header + GO/NO-GO blocks si faltan)
    2 — Reemplazarlo con plantilla nueva (el actual se guarda en docs/ARCHIVE.md)
    3 — Déjarlo como está (no tocar)
  ```
  - Option 1: add `---\ndoc: ROADMAP\n---` header if missing + append GO/NO-GO block to any phase without it
  - Option 2: move to docs/ARCHIVE.md → create fresh from ROADMAP_TEMPLATE.md
  - Option 3: skip entirely

### docs/ARCHITECTURE.md (if missing)
- Read: folder structure, package.json, git log, CLAUDE.md
- Infer: Core modules, tech decisions
- Use ARCHITECTURE_TEMPLATE structure
- Mark: [inferred], [needs review], [confirmed from code]

### CLAUDE.md Update (if exists but wrong format)
- Show diff of what would change
- Ask approval per section
- Merge, don't overwrite

### CLAUDE.md Create (if missing)
- Generate from CLAUDE_TEMPLATE.md
- Use project type (software/business/content) as hint
- Fill Stack, Constraints from existing code

---

## Phase 5 — Register Project

Add to ~/.claude/SYSTEM.md:
- Project name, path, GitHub, current phase
- If file missing → create ~/.claude/SYSTEM.md first

---

## Phase 5.5 — Set Up Antigravity (.agents/) Structure

Create `.agents/` folder in project root for Gemini/Antigravity:

### .agents/rules/claude.md
- Content: copy of project CLAUDE.md (if exists) OR short rule block:
  ```
  ---
  trigger: always_on
  ---

  # [Project Name] — Project Rules

  Read docs/PROJECT_STATE.md <session> block at session start.
  Read docs/ARCHITECTURE.md only if building.
  Read docs/PROBLEMS.md only if debugging.
  Commit prefix: feat/fix/chore/docs. Never commit to main directly.
  ```

### .agents/workflows/ (optional, for project-specific workflows)
- Only create if project has custom prompts/workflows
- Skip if none needed — global workflows in ~/.gemini/antigravity/global_workflows/ cover standard skills

Show in output: "✓ .agents/rules/ created — Gemini reads project rules automatically"

---

## Phase 6 — Generate docs/code-review-graph.json (project audit map)

After registering the project, generate the initial structural map:
- Run: `git log --oneline -10`, `ls -la` on project root and src/ (or equivalent)
- Read: docs/ROADMAP.md current phase section (or Phase: N/A if no ROADMAP)
- Write `docs/code-review-graph.json`:
  - `"project"`: actual project name from `basename $(pwd)` (never `"."` or generic)
  - `"generated"`: current timestamp
  - `"lastCommit"`: `git rev-parse --short HEAD`
  - `"phase"`: current phase from PROJECT_STATE (or "initial" if N/A)
  - `"structure"`: actual project folders with file counts, purposes inferred from code
  - `"riskZones"`: critical files inferred from git log + project structure (auth, DB, config, entry points)
  - `"dependencies"`: doc connections inferred from adapt analysis
  - `"metadata.regenerate"`: `"after phase advance or architectural changes"`
- Add `docs/code-review-graph.json` to output "Created" section

---

## Phase 4.5 — Create claude-progress.txt

After generating PROJECT_STATE.md, create `claude-progress.txt` in project root:
- If PROJECT_STATE Next is filled → `[>] [Next value]`
- If not → `[ ] Start first session — run /new-session`
- This is the lightweight state bridge read by new-session Step 0A (~30 tokens)
- If file already exists → do NOT overwrite (user may have tasks in progress)

---

## Output (max 15 lines)

```
✅ Proyecto Adaptado — [name]

**Created:**
- [files created]
- claude-progress.txt (lightweight task state)

**Updated:**
- [files updated]

**Archived (preserved):**
- docs/ARCHIVE.md (legacy docs)

**Inferred (review recommended):**
- [anything Claude guessed — mark clearly]

**SESSION preservada:** [YES — no changes / UPDATED — campos faltantes añadidos]
**Registered in:** ~/.claude/SYSTEM.md
**Next:** /new-session to start working
```

---

## Rules

- NEVER overwrite existing SESSION block with real data — always ask first
- NEVER overwrite other docs without showing diff + approval
- Preserve old docs in ARCHIVE.md, don't delete
- Mark clearly: [inferred], [confirmed from code], [needs review]
- Only add missing fields to existing SESSION — never remove existing ones
- If git log empty → note state inference is limited
- Trust code over docs when they conflict
- claude-progress.txt: create if missing, never overwrite if exists
