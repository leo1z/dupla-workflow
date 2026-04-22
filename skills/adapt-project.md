Onboard existing project into Dupla-Workflow. Asks first, shows diffs, preserves existing docs.

Usage: /adapt-project

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

### docs/PROJECT_STATE.md (if missing or v1 format)
- Read: git log, existing CLAUDE.md, README
- Infer: Current goal (from git log or README), status, next steps
- Use PROJECT_STATE_TEMPLATE structure
- ALWAYS set `project_type: individual` in YAML header (explicitly — do not leave blank)
- ALWAYS fill SESSION block with real values:
  - `Updated:` → today's date (YYYY-MM-DD HH:MM)
  - `Done:` → last 3 git log entries (or "Initial setup" if no commits)
  - `Next:` → inferred from README/git (mark as [inferred])
  - `Status: ACTIVE`
  - `Branch:` → `git branch --show-current`
  - `Phase:` → if ROADMAP.md exists, read first active phase and set `Phase: Phase [N] — [name]`; if no ROADMAP → `Phase: N/A`
  - `Phase_Status:` → `In Progress` if ROADMAP found, `N/A` if not
- Mark inferred vs confirmed

### docs/PROBLEMS.md (if missing)
- Create empty from template
- Add note: "Start documenting issues as they arise"

### docs/ROADMAP.md (if missing)
- Create placeholder
- Add note: "PENDING — use /new-project IML assessment or fill manually"

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

## Output (max 15 lines)

```
✅ Proyecto Adaptado — [name]

**Created:**
- [files created]

**Updated:**
- [files updated]

**Archived (preserved):**
- docs/ARCHIVE.md (legacy docs)

**Inferred (review recommended):**
- [anything Claude guessed]

**Registered in:** ~/.claude/SYSTEM.md
**Next:** /new-session to start working
```

---

## Rules

- NEVER overwrite existing docs without showing diff + approval
- Preserve old docs in ARCHIVE.md, don't delete
- Mark clearly: [inferred], [confirmed from code], [needs review]
- If git log empty → note state inference is limited
- Trust code over docs when they conflict
