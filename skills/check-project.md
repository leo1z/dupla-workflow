Validate that project docs reflect current reality. Asks targeted questions, detects drift, offers to update.

Usage: /check-project

---

## Purpose

Docs drift. Code moves faster than documentation. This skill reads the project's key context files, extracts their KEY claims, and asks the user to validate them. Anything that doesn't match reality gets flagged and offered for update.

---

## Step 1 — Read Context Docs (silent)

Read in this order, extract only the claims that CAN change over time:

| Doc | What to extract |
|---|---|
| `./CLAUDE.md` | Stack, constraints, current goal, team if any |
| `docs/PROJECT_STATE.md` | Current goal, phase, status, next steps, blockers |
| `docs/ROADMAP.md` (if exists) | Current active phase + its outcomes + GO/NO-GO status |
| `docs/ARCHITECTURE.md` (if exists) | Core tech decisions, integrations, deployment |
| `docs/PROBLEMS.md` (if exists) | Open problems listed |

If a doc is missing → note it, skip it, don't ask about it.

---

## Step 2 — Build Questionnaire

Generate questions from what you read. Max 12 questions total. Group by doc.

**Rules for questions:**
- Only ask about things that change (not project name, not git init date)
- One question = one claim. Binary first (yes/no), then open if "no"
- Skip questions where the answer is clearly derivable from git log

**Question template per claim:**

```
[Doc source] — [claim from doc]
¿Sigue siendo así? [s / no / cambió]
```

If user says "no" or "cambió" → follow up: "¿Cuál es la realidad actual?"

---

## Step 3 — Present All Questions in One Block

Do NOT ask one by one. Send all questions together:

```
## Check-Project — [project name]

Voy a validar que tus docs reflejen la realidad actual.
Responde cada punto: s = sigue igual · no = ya no aplica · cambió = hay una versión nueva

─── PROJECT_STATE ───────────────────────────────────────
1. Goal: "[current goal from PROJECT_STATE]"
   ¿Sigue siendo el objetivo principal? [s/no/cambió]

2. Status: [ACTIVE/PAUSED/BLOCKED] · Phase: [phase]
   ¿El estado y fase son correctos? [s/no/cambió]

3. Next: "[next steps from SESSION]"
   ¿Esto es lo que realmente toca hacer? [s/no/cambió]

4. Blockers: [blockers or "none"]
   ¿Hay bloqueadores activos ahora? [s/no/cambió]

─── CLAUDE.md ───────────────────────────────────────────
5. Stack: [stack from CLAUDE.md]
   ¿El stack sigue igual? [s/no/cambió]

6. Constraints: [constraints from CLAUDE.md if any]
   ¿Las restricciones siguen vigentes? [s/no/cambió]

─── ROADMAP ─────────────────────────────────────────────
7. Fase activa: [phase name + outcomes]
   ¿El plan de esta fase sigue siendo el correcto? [s/no/cambió]

8. ¿Algún outcome de esta fase ya está completo pero no marcado? [s/no]

─── ARCHITECTURE ────────────────────────────────────────
9. [Key integration or tech decision from ARCHITECTURE.md]
   ¿Sigue siendo así en el código real? [s/no/cambió]

─── PROBLEMS ────────────────────────────────────────────
10. Problemas abiertos: [list from PROBLEMS.md or "ninguno documentado"]
    ¿Alguno ya está resuelto? [s/no]
    ¿Hay nuevos problemas recurrentes que no están documentados? [s/no]
```

Adjust question count to what docs actually contain. Skip sections for missing docs.

---

## Step 4 — Process Responses

For each "no" or "cambió":
- Ask follow-up inline: "¿Cuál es la realidad actual?" (if not already answered)
- Tag it: `[DESACTUALIZADO]`

Build a diff table:

```
## Resultado — [N] items a actualizar

| Doc | Campo | Doc dice | Realidad actual |
|-----|-------|----------|-----------------|
| PROJECT_STATE | Goal | "X" | "Y" |
| ROADMAP | Phase 2 outcome | pending | completed |
| PROBLEMS.md | Issue #3 | open | resolved |
```

If everything matches:
```
✅ Docs alineados — todo refleja la realidad actual.
```

---

## Step 5 — Offer Updates

For each item in the diff table, offer to update:

```
¿Actualizo los docs? Puedo hacerlo todo ahora o elegir cuáles:
  1 — Actualizar todo (recomendado)
  2 — Elegir cuáles actualizar
  3 — Solo ver el reporte, yo lo actualizo manualmente
```

**If 1 or 2 selected:**

Apply changes to each doc:
- `PROJECT_STATE.md` → update SESSION block fields + Recent Changes
- `CLAUDE.md` → update only the changed sections (show diff before writing)
- `ROADMAP.md` → mark completed outcomes `[x]`, update phase status
- `ARCHITECTURE.md` → append updated section with date
- `PROBLEMS.md` → mark resolved items, add new ones

After each update → confirm: "✓ [doc] actualizado"

**Always ask:**
```
¿Commit con los cambios? [s/n]
→ mensaje sugerido: docs: check-project sync — [brief description]
```

---

## Step 6 — Output

```
✅ Check-Project completo — [project name]

Validados: [N] puntos
Actualizados: [N] docs
  ✓ PROJECT_STATE.md — goal + next actualizados
  ✓ ROADMAP.md — Phase 2 outcome marcado [x]
  ✓ PROBLEMS.md — Issue #3 cerrado

Drift detectado: [N items] → [N actualizados / N pendientes manual]

Siguiente: /new-session para continuar con contexto fresco
```

---

## Rules

- Never update docs without showing what changes and getting confirmation
- Ask all questions in ONE block — no one-by-one interrogation
- Skip docs that don't exist — don't create them (use /adapt-project for that)
- Max 12 questions — prioritize by drift risk (state > roadmap > architecture > problems)
- If user answers all "s" → finish in < 30 seconds, no updates needed
- Cross-project issues → only offer PROBLEMS_GLOBAL update if PROBLEMS.md was updated
