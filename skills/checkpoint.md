Save work session state. Unified command with 3 modes via menu.

Usage: /checkpoint

---

## Mode Selection

Display menu:
```
¿Qué quieres hacer?
  1 — Quick save (mid-session)
  2 — Full close (end of session)
  3 — Handoff (switch to another model)
Enter choice (1-3):
```

---

## Mode 1 — Quick Save (mid-session)

For saving progress without ending the session.

**Steps:**
1. "¿Qué se completó? (Enter para omitir)"
2. Run: `git log --oneline -1`, `git status --short`
3. Update docs/PROJECT_STATE.md `<session>` block:
   - `Updated: now`
   - `Done: [items completed]`
   - Keep `Next`, `Branch`, `Model` unchanged
4. Ask: "¿Commit? [s/n]"
   - If yes → `git add . && git commit -m "checkpoint: [description]"`
5. Output (4 lines max):
```
✅ Checkpoint saved
Done: [item1] · [item2]
Branch: [name]
Next: [current action continues...]
```

---

## Mode 2 — Full Close (end of session)

Complete session closure with state update + next-session prep.

**Steps:**
1. Run quick save (Mode 1 steps 1–4)
2. Update docs/PROJECT_STATE.md fully:
   - `Updated: now`
   - `Status: ACTIVE | PAUSED | BLOCKED` (ask if not clear)
   - `Done: [items from commits + session]`
   - `Next: [ONE sentence — must be specific enough to resume cold]`
   - `Blockers: [if any]`
   - Update "Recent Changes" section (add 3–5 latest from git log)
3. Ask: "¿Hay algo en PROBLEMS.md que deba documentarse? (Enter para omitir)"
   - If yes → append to docs/PROBLEMS.md
4. Check: Is this a cross-project issue?
   - If yes, offer: "Agregar a ~/.claude/PROBLEMS_GLOBAL.md? [s/n]"
5. Recommend next model:
   - If `Next` contains: "plan", "research", "review" → suggest Gemini
   - If `Next` contains: "implement", "debug", "code" → suggest Claude
6. Suggest: `/restore` to review save points
7. Output (10 lines max):
```
✅ Sesión cerrada — [fecha]

Completado:
- [item1]
- [item2]

Próxima sesión:
→ [ONE sentence from Next field]
→ Recomendado: [model]

/restore para ver puntos de guardado
```

---

## Mode 3 — Handoff (to another model)

Complete session save + generate handoff block for another model.

**Steps:**
1. Run full close (Mode 2, all steps except model recommendation)
2. Generate `<handoff>` block:
```xml
<handoff>
Date: YYYY-MM-DD HH:MM
From: claude-haiku → To: [model: gemini/claude-opus/other]
Project: [project name] at [path]
Goal: [current goal from PROJECT_STATE]
Branch: [current branch]
Done: [completed in this session]
Next: [next action]
Context: Read docs/PROJECT_STATE.md first, then check <session> block
</handoff>
```
3. Ask: "¿Push antes de handoff? [s/n]"
   - If yes → `git add . && git commit -m "handoff: [brief desc]" && git push`
4. Output (8 lines):
```
✅ Listo para handoff

Copia este bloque a tu próximo chat:

[handoff block]

Dile al modelo siguiente: "Continúa desde aquí."
```

---

## Rules

- Always update SESSION block (< 2 minutes of work)
- PROJECT_STATE.md must be useful for someone who didn't see the session
- Save points created automatically on successful commit
- If stuck on decision → `/checkpoint close` + `/restore` to review options
- Never force push — if conflict, ask user
