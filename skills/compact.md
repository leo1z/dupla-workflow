Summarize project state to reduce context bloat. Run when sessions feel heavy or after 10+ sessions.

**When to use:** When responses feel generic, after 10+ sessions, or before handing off to a new LLM. Not a replacement for `/checkpoint`.
**See also:** `/checkpoint` (save state first) · `/restore` (undo if compact went wrong)

Usage:
  /compact          → summarize current project
  /compact global   → summarize cross-project memory (MEMORY_GLOBAL.md)

---

## When to run

Run manually when:
- Session feels slow or responses are getting generic/hallucinated
- After 10+ work sessions without compacting
- Before a handoff to a different LLM (reduce context size)
- When PROJECT_STATE Done field has 10+ accumulated items

---

## Execution — Project Compact

### Step 1 — Read current state (targeted, not full load)

Read in order, stop when you have enough:
1. `docs/PROJECT_STATE.md` → SESSION block only (~60 tokens)
2. `claude-progress.txt` → if exists (~30 tokens)
3. `git log --oneline -20` → last 20 commits (~80 tokens)
4. `docs/ROADMAP.md` → current phase section only (~100 tokens)

Do NOT load ARCHITECTURE.md or PROBLEMS.md unless explicitly needed.

### Step 2 — Detect what's stale

- Done items in SESSION that are also in git log → confirmed, can compress
- Completed ROADMAP outcomes (`[x]`) → archive-ready
- PROBLEMS.md entries older than current phase → can summarize
- Recent Changes in PROJECT_STATE older than 5 entries → can drop

### Step 3 — Compress (show diff before writing)

Show summary of what will change:
```
## Compact Preview

PROJECT_STATE.md SESSION:
  Done: [5 items] → compressed to "[N] items desde Phase [X]"
  Next: [unchanged]

ROADMAP.md:
  Phase 1 outcomes [x][x][x] → archived to "Phase 1 Complete — [date]"
  Phase 2 [current] → unchanged

PROBLEMS.md:
  3 resolved entries → summarized to 1 pattern entry in MEMORY_GLOBAL.md

claude-progress.txt:
  [x] items → cleared, only [>] and [ ] remain
```

Ask: "¿Aplicar compact? [s/n]"

### Step 4 — Apply (only if approved)

1. **PROJECT_STATE.md SESSION** — compress Done to 1-line summary, keep Next verbatim
2. **ROADMAP.md** — completed phases: collapse outcomes to single `✅ Phase N Complete — [date] — [key deliverable]` line
3. **PROBLEMS.md** — resolved entries: promote pattern to MEMORY_GLOBAL.md, then delete from PROBLEMS.md
4. **claude-progress.txt** — clear all `[x]` lines, keep `[>]` and `[ ]`
5. Commit: `git commit -m "chore: compact — Phase [N] archived, context reduced"`

### Step 5 — Output

```
✅ Compact complete

Reducido:
  PROJECT_STATE SESSION: [before tokens] → [after tokens] tokens
  ROADMAP: Phase [N] archivada
  PROBLEMS: [N] entradas → [N] patrones en MEMORY_GLOBAL
  claude-progress.txt: [N] [x] eliminados

Contexto estimado antes: ~[N] tokens · después: ~[N] tokens
```

---

## Execution — Global Compact (/compact global)

Only for MEMORY_GLOBAL.md when it grows beyond ~500 tokens.

### Steps:
1. Read `~/.claude/MEMORY_GLOBAL.md` entirely
2. Identify:
   - Duplicate patterns → merge into one
   - Kill conditions older than 1 year with no recurrence → archive
   - Resolved problems that became patterns → move to Patrones section
3. Show diff preview → ask approval → write

---

## Rules

- Never compact without showing preview first (Human in the Loop)
- Never delete Next field from SESSION — it's the resumption anchor
- Never touch ARCHITECTURE.md — structural decisions are permanent record
- Promote resolved problems to MEMORY_GLOBAL before deleting from PROBLEMS.md
- If /compact global → only touch MEMORY_GLOBAL.md, nothing else
- Safe to run mid-session — does not require /checkpoint first
