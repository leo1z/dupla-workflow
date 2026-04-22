Save work session state. Unified command with modes via menu.

Usage: /checkpoint

---

## Mode Selection

Detect project_type from docs/PROJECT_STATE.md YAML:
- `project_type: individual` → show modes 1–3
- `project_type: team` → show modes 1–4 (mode 4 only for Leader)

**Individual menu:**
```
¿Qué quieres hacer?
  1 — Quick save (mid-session)
  2 — Full close (end of session)
  3 — Handoff (switch to another model)
```

**Team menu:**
```
¿Qué quieres hacer?
  1 — Quick save (mid-session)
  2 — Full close (end of session)
  3 — Handoff (switch to another model)
  4 — Approve PR (Lead only — review + merge branch)
```

---

## Mode 1 — Quick Save (mid-session)

For saving progress without ending the session.

**Steps:**
1. "¿Qué se completó? (Enter para omitir — se detecta del git log)"
2. Run: `git log --oneline -5`, `git status --short`
3. Auto-generate Done from git log since last commit to main/last checkpoint
4. **Individual:** Update `<session>` block in PROJECT_STATE.md
   - `Updated: now`, `Done: [from git log]`
   - Keep `Next`, `Branch`, `Model` unchanged
   **Team:** Update ONLY `### [Your Name]` section in PROJECT_STATE.md
   - `Updated: now`, `Done: [auto-generated from git log of your branch]`
   - Keep `Next`, `Blockers`, `Dependencies` unchanged
5. Ask: "¿Commit? [s/n] → mensaje sugerido: checkpoint: [description]"
6. Output (4 lines max):
```
✅ Checkpoint saved
Done: [from git log]
Branch: [name]
Next: [continues...]
```

---

## Mode 2 — Full Close (end of session)

Complete session closure with state update + next-session prep.

**Steps:**
1. Run quick save (Mode 1, all steps)
2. **Individual:** Update full PROJECT_STATE.md:
   - `Status: ACTIVE | PAUSED | BLOCKED`
   - `Next: [ONE sentence — specific enough to resume cold]`
   - `Blockers: [if any]`
   - Update "Recent Changes" (add from git log)
   **Team:** Update your Dev section in PROJECT_STATE.md:
   - `Next: [ONE sentence]`, `Blockers: [if any]`
   - Update `Dependencies:` if something changed
3. Ask: "¿Hay algo para PROBLEMS.md? (Enter para omitir)"
4. Check: cross-project issue? → offer "Agregar a ~/.claude/PROBLEMS_GLOBAL.md? [s/n]"
5. Recommend next model:
   - "plan", "research", "review" → suggest Gemini
   - "implement", "debug", "code" → suggest Claude
6. **Team:** show dependency status for next dev:
   ```
   Tu trabajo actualizado. Estado de dependencias:
   → Dev B puede continuar (esperaba tu API) ✅
   → Dev C ya terminó DB ✅
   ```
7. Output (10 lines max):
```
✅ Sesión cerrada — [fecha]

Completado: [from git log]
Próxima sesión: [Next sentence]
Recomendado: [model]

[Team only:]
Dev B puede continuar → /new-session en su chat
```

---

## Mode 3 — Handoff (to another model)

Complete save + generate handoff block.

**Steps:**
1. Run full close (Mode 2, skip model recommendation)
2. Generate `<handoff>` block:
```xml
<handoff>
Date: YYYY-MM-DD HH:MM
From: claude → To: [gemini/claude-opus/other]
Project: [name] at [path]
Goal: [current goal]
Branch: [current branch]
Done: [completed this session]
Next: [next action]
Context: Read docs/PROJECT_STATE.md first
[Team: your Dev section is ### [Name]]
</handoff>
```
3. Ask: "¿Push antes de handoff? [s/n]"
4. Output (8 lines):
```
✅ Listo para handoff

Copia este bloque al próximo chat:
[handoff block]
```

---

## Mode 4 — Approve PR (Team · Lead only)

Review a dev's branch and merge to main.

Usage: `/checkpoint approve-pr work/[branch-name]`

**Steps:**
1. Run: `git log main..work/[branch] --oneline` → list commits in branch
2. Run: `git diff main...work/[branch] --stat` → files changed
3. Show review summary:
```
## PR Review — work/[branch-name]

**Dev:** [Name] ([Role])
**Commits:** [N] commits
  - feat: auth endpoint
  - fix: validate password
  
**Files changed:**
  + src/auth.ts (+150 -30)
  + src/models.ts (+45)
  
**Matches ROADMAP Phase [N]:** [YES / PARTIAL / NO]
  → Expected: [outcome from ROADMAP]
  → Actual: [what was done]
  
**Blockers resolved:** [YES / NO — check Dependencies]
**Tests/checks:** [run if applicable]

Aprobar y mergear a main? [s/n]
```
4. If YES:
   - `git checkout main && git merge work/[branch] --no-ff -m "merge: [branch] — [description]"`
   - Update `## Shared Status` in PROJECT_STATE.md:
     - `Last Merge: [dev] — [what] — [date]`
     - `Updated: now`
   - Check if phase GO/NO-GO conditions are met:
     - If all branches for phase merged → ask "¿Phase [N] complete? ¿GO/NO-GO? [go/adapt/kill]"
     - Update ROADMAP.md phase status accordingly
   - `git push origin main`
5. If NO → add comment: "¿Qué falta? (Para que el dev corrija)"
6. Output (8 lines):
```
✅ Merged — work/[branch] → main

Dev [Name]: [what was merged]
ROADMAP Phase [N]: [In Progress / Complete]
Next: [Dev B] can now start (was waiting for this)

[If phase complete:]
Phase [N] GO/NO-GO: [GO → proceed to Phase N+1 / ADAPT / KILL]
```

---

## Rules

- Always update state block (< 2 minutes of work)
- Done field: auto-generated from git log (no manual typing needed)
- Team: each dev edits ONLY their section — never touch others
- Leader: only Leader runs Mode 4 (approve-pr)
- Never force push — if conflict, ask user
- If stuck → `/checkpoint close` + `/restore` to review options
