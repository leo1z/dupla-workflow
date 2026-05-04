Lightweight session for small projects or casual work. No docs/ folder needed — just a QUICKSTATE.md in any folder.

Usage:
  /quick-start              → start or resume a micro session
  /quick-start [goal]       → resume with a specific goal override
  /quick-start save         → save/update QUICKSTATE.md and close
  /quick-start close        → alias for save

---

## What is micro mode

A single file (`QUICKSTATE.md`) replaces the full `docs/` structure. Use it for:
- Scripts, experiments, prototypes
- Research or learning sessions
- Non-code tasks (writing, planning, analysis)
- Any project where full workflow is overkill

---

## Execution

### Step 1 — Detect context

Check args first:
- Arg is `save` or `close` → skip to Step 5 directly (save/update QUICKSTATE.md)

Check current directory for `QUICKSTATE.md`:
- **Found** → read it → go to Step 3 (returning session)
- **Not found** → go to Step 2 (new micro project)

---

### Step 2 — Initialize (new)

Ask two questions (one at a time, wait for answer):

```
¿Qué estás trabajando? (una línea)
```
```
¿Cuál es el primer paso concreto?
```

Then create `QUICKSTATE.md` in the current directory using the answers:

```markdown
---
type: micro
updated: [today YYYY-MM-DD]
---

## What
[answer to question 1]

## Done
-

## Next
- [answer to question 2]

## Notes

```

Show:
```
✅ QUICKSTATE.md creado en [current folder]
   Edítalo directamente o usa /quick-start para actualizar.
```

Then go to Step 4 (output).

---

### Step 3 — Returning session

Read `QUICKSTATE.md`:
- Extract: What, Done, Next, Notes, updated date
- Check if updated > 7 days → note it (no blocker, just informational)
- If user passed an arg → override Goal with that arg

Go to Step 4.

---

### Step 4 — Output (max 8 lines)

```
## Quick Session — [date]

**What:** [from QUICKSTATE.md]
**Last updated:** [date — "today" / "X days ago"]

**Done:** [last item or "—"]
**Next:** [immediate step]

**Plan:**
1. [concrete step from Next]
2. [second step if obvious]
```

---

### Step 5 — Saving state (on user request)

When the user asks to save, update, or close the session — or when work is clearly done — update `QUICKSTATE.md`:

- Update `updated:` field to today
- Move completed items to `## Done`
- Write new `## Next` from what's actually next
- Append anything important to `## Notes`

Show:
```
✅ QUICKSTATE.md actualizado — [brief summary of what changed]
```

No git commit required. No checkpoint needed. The file IS the state.

---

## Upgrade: de proyecto pequeño a proyecto completo

Cuando el usuario quiere escalar un micro-proyecto a workflow completo (más colaboradores, roadmap, arquitectura, fases), o cuando `QUICKSTATE.md` lleva más de 2 semanas activo:

Mostrar una vez (no repetir en cada sesión):
```
💡 Este proyecto tiene [X días] activo en modo micro.
¿Quieres escalarlo a proyecto completo? (docs/ + ROADMAP + ARCHITECTURE)

  /adapt-project → si ya tienes código/estructura que preservar
  /new-project   → si prefieres empezar desde la entrevista IML

O sigue en modo micro — sin presión.
```

**Al escalar con `/adapt-project`:**
- El skill detecta `QUICKSTATE.md` y usa su contenido (What, Done, Next) como base para pre-llenar `PROJECT_STATE.md`
- `QUICKSTATE.md` se archiva en `docs/ARCHIVE.md` — no se elimina
- El usuario no pierde nada de lo que había en el archivo

**Al escalar con `/new-project`:**
- El usuario pasa por la entrevista IML completa
- Las respuestas pueden basarse en lo que ya sabe del micro-proyecto

---

## Rules

- Never create `docs/` or `CLAUDE.md` — micro mode is intentionally minimal
- Never ask about git branches, roadmaps, or architecture
- If user wants to upgrade to full project: suggest `/new-project` or `/adapt-project`
- Keep output under 8 lines — micro means micro
- QUICKSTATE.md lives in whatever directory the user is in when they run the skill
- Multiple micro projects = multiple folders, each with their own QUICKSTATE.md
- Upgrade suggestion: show only if project is >14 days old OR user asks explicitly

---

## Decision Logic

| Condition | Action |
|---|---|
| arg = `save` or `close` | Skip to Step 5 — save QUICKSTATE.md immediately |
| QUICKSTATE.md exists | Returning session — read + show state |
| QUICKSTATE.md missing | New — ask 2 questions → create file |
| User passes arg (goal) | Override Next with that goal |
| updated > 7 days | Note age — don't block |
| User says "save" / "done" / "cierra" | Update QUICKSTATE.md |
| User wants full project structure | Suggest /new-project |
