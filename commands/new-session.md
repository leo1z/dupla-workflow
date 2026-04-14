Start work session. Read state, define next steps.

Usage: /new-session [optional goal]

---

## Execution

1. Run: `git branch --show-current`, `git log --oneline -5`, `git status --short`
2. Read: `docs/PROJECT_STATE.md` (always)
3. If planning → read `docs/ROADMAP.md`
4. If building → read `docs/ARCHITECTURE.md`
5. If debugging → read `docs/PROBLEMS.md`

Do NOT read all files. Load only what the session requires.

---

## Output (max 12 lines)

---
## Session — [date]

**Goal:** [what the user wants / inferred from PROJECT_STATE]
**Branch:** [current] [⚠️ if main]

**State:**
[1–2 lines from PROJECT_STATE + git log. If conflict → trust git log.]

**Plan:**
1. [concrete step]
2. [concrete step]
3. [if needed]

**Alert:** [only if blocker exists — credential missing, on main, conflict with state]
---

## Rules

- Max 12 lines. No filler.
- No argument → ask goal in one line.
- Do NOT require previous /progress — infer from git.
- If PROJECT_STATE is newer than last commit → use it as primary.
- If git log is newer → git log wins.
