Save work session state. Unified command with modes via menu.

Usage: /checkpoint

---

## Mode Selection

**Auto-detect context first, then show relevant options:**

Detect signals:
- Uncommitted changes? → suggest Quick Save
- User mentioned "gemini", "cambiar modelo", "handoff", "otro modelo" → suggest Handoff
- project_type: team AND user is Lead → add Approve PR option
- Many commits since last close (>10) → suggest Full Close + new chat

**Individual menu:**
```
¿Qué quieres hacer?
  1 — Quick save (mid-session, 30 seg)
  2 — Full close (end of session + abre nuevo chat)
  3 — Handoff (cambiar a otro modelo o dev)
```

**Team menu:**
```
¿Qué quieres hacer?
  1 — Quick save (mid-session, 30 seg)
  2 — Full close (end of session + abre nuevo chat)
  3 — Handoff (cambiar a otro modelo)
  4 — Approve PR (Lead: revisar + mergear rama)
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

Complete session closure with state update + next-session prep + new chat guidance.

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

2.5. **ROADMAP phase sync** (if Phase ≠ "N/A"):
   - Read current phase section from ROADMAP.md (from `## Phase [N]` to next `##`)
   - Compare this session's git log vs phase **Outcomes** (not daily tasks)
   - If any phase Outcome was delivered this session → mark `[x]` in ROADMAP.md
   - Check GO/NO-GO criteria: if all "Continue if" conditions appear met → set `Phase_Status: GO/NO-GO Pending` in SESSION block and show:
     ```
     ⚠️ Phase [N] criteria met — GO/NO-GO evaluation needed
        Continue if: [criteria]
        Kill if: [criteria]
        → Decide before next session
     ```
   - If phase is NOT complete → show remaining outcomes (1 line)
   - Do NOT touch adjacent phases or other sections of ROADMAP

2.6. **Architecture sync** (signal-based — do NOT ask by default):
   - Run: `git diff HEAD~1 --name-only 2>/dev/null` (files changed this session)
   - If changed files include architecture-relevant patterns (DB schemas, config files, main entry points, API route definitions, environment files, dependency files like package.json/requirements.txt/go.mod) → THEN ask: "Detecté cambios en [file]. ¿Actualizo ARCHITECTURE.md? [s/n]"
   - If yes: append to ARCHITECTURE.md:
     ```
     ## [Date] — [brief description inferred from git diff]
     [Changes inferred from diff + user confirmation]
     ```
   - If no architecture-relevant files changed → skip entirely, no prompt

2.7. **Problems detection** (signal-based — do NOT ask by default):
   - Scan git commit messages from this session for: "fix", "error", "bug", "workaround", "hotfix", "revert"
   - If found → ask: "Detecté un fix en los commits. ¿Agrego algo a PROBLEMS.md? (Enter para omitir)"
   - If no fix signals in commits → skip entirely, no prompt
   - Cross-project issue? → only offer PROBLEMS_GLOBAL if PROBLEMS.md was updated

2.8. **Code-review graph update** (signal-based — silent otherwise):
   - **Trigger A — Phase advance** (from step 2.5): if any ROADMAP Outcome was marked `[x]` this session:
     - Update `docs/code-review-graph.json`:
       - Set `"phase"` to current phase
       - Update `"lastCommit"` to current git HEAD
       - Update `"generated"` to now
       - Re-scan project folders and update `"structure"` file counts
       - Update `"riskZones"` if architecture-relevant files changed this phase
     - Show: `📊 Graph actualizado → Phase [N] (docs/code-review-graph.json)`
   - **Trigger B — Structural changes** (dupla-workflow repo only):
     - Run: `git diff HEAD~1 --name-only 2>/dev/null`
     - If changed files include `skills/` or `templates/` → show once:
       ```
       📊 Cambios en skills/ o templates/ detectados.
          Considera regenerar el grafo: bash bin/generate-code-review-graph.sh
       ```
   - If neither trigger fires → skip entirely

2.9. **Write claude-progress.txt** (always on Full Close):
   - Read PROJECT_STATE.md SESSION → extract Done items and Next
   - Overwrite `claude-progress.txt` in project root:
     ```
     [x] [Done item 1 from SESSION]
     [x] [Done item 2 from SESSION]
     [>] [Next from SESSION — the immediate next action]
     ```
   - Max 10 lines. If file doesn't exist → create it. If exists → overwrite entirely.
   - Purpose: new-session Step 0A reads this at ~30 tokens before PROJECT_STATE

3. Recommend next model:
   - Next contains "plan", "research", "review", "decidir" → suggest Gemini
   - Next contains "implement", "debug", "code", "build" → suggest Claude
   - No clear signal → "Claude o Gemini según qué hagas primero"
4. **Team:** show dependency status for next dev:
   ```
   Dev B puede continuar (esperaba tu API) ✅
   Dev C ya terminó DB ✅
   ```
5. **Always end with new chat guidance:**
```
✅ Sesión cerrada — [fecha]

Completado: [from git log]
Próxima sesión: [Next sentence]
Modelo recomendado: [Claude / Gemini]

→ Cierra este chat
→ Abre uno nuevo
→ Escribe /new-session para continuar
   (Chats frescos = contexto limpio = menos tokens)

[Team only: Dev B puede continuar → /new-session en su chat]
```

---

## Mode 3 — Handoff (to another model or dev)

Complete save + generate handoff block + step-by-step instructions.

**Steps:**

**Detect active surface first** (shapes the handoff instructions shown):
- Claude Code IDE (VS Code extension)? → Full skills + hooks available
- Claude Code Terminal (CLI)? → Full skills + hooks available
- Antigravity/Gemini? → Skills as workflows, no hooks, no slash commands
- Claude.ai Web? → No skills, no hooks — handoff block + manual file attach only
- Chat (WhatsApp/Slack via OpenClaw)? → Handoff block only, minimal instructions
- Unknown → assume Claude Code IDE (safe default)

If unable to detect → ask: "¿Desde dónde estás usando esto? (Claude Code IDE / Terminal / Antigravity / Web / Chat)"

1. Ask destination:
```
¿A dónde vas?
  1 — Gemini (Antigravity / CLI — planificación / investigación)
  2 — Claude Opus/Sonnet (mismo IDE o diferente — tarea compleja)
  3 — GPT-4 / OpenAI API
  4 — Cursor + cualquier modelo
  5 — Otro dev del equipo
  6 — Otro (especifica — modelo local, Windsurf, etc.)
```

2. Run full close (Mode 2, skip new-chat guidance — handled below)

3. Generate `<handoff>` block:
```xml
<handoff>
Date: YYYY-MM-DD HH:MM
From: [current model] → To: [destination]
Project: [name] at [path]
Goal: [current goal from PROJECT_STATE]
Branch: [current branch]
Done: [completed this session — from git log]
Next: [next action — be specific]
Context: Read docs/PROJECT_STATE.md first, then <session> block
[Team only: Your Dev section is ### [Dev Name]]
</handoff>
```

3.5. **Persist handoff block to PROJECT_STATE.md:**
   - Write `<handoff>...</handoff>` block to PROJECT_STATE.md immediately after `</session>`
   - If a `<handoff>` block already exists → replace it
   - Update SESSION field: `Handoff: [destination]`
   - This ensures the next model can read it via `/new-session` even if the current chat is closed

4. Push if uncommitted:
```
¿Push antes del handoff? [s/n]
→ If yes: git add . && git commit -m "handoff: [brief desc]" && git push
```

5. Show step-by-step instructions for destination:

**If Gemini (Antigravity):**
```
✅ Handoff listo → Gemini en Antigravity

Pasos exactos:
  1. Abre Antigravity
  2. Selecciona Gemini como modelo (menú desplegable arriba)
  3. Crea nuevo chat (botón + o icono nuevo chat)
  4. Pega este bloque EXACTAMENTE así al inicio del chat:

[handoff block]

  5. Después del bloque, escribe en el mismo mensaje:
     "Lee el bloque handoff y corre /new-session"

  ℹ️ Nota Antigravity: los skills NO son slash commands aquí.
     Gemini los lee como instrucciones al escribir su nombre.
     Si /new-session no funciona como comando, escribe:
     "Ejecuta el skill new-session" o simplemente "Haz /new-session"

  6. Gemini leerá el handoff + PROJECT_STATE.md y continuará

Qué hará Gemini al recibir el handoff:
  → Lee el bloque <handoff> → identifica proyecto y branch
  → Lee docs/PROJECT_STATE.md → bloque <session>
  → Te muestra estado + plan para continuar
  → Trabaja en lo que dice “Next:” del handoff

Cuándo volver a Claude:
  → Cuando empieces a implementar código
  → Haz /checkpoint handoff → selecciona Claude → repite el proceso
```

**If Claude Opus / otro modelo (mismo IDE o diferente):**
```
✅ Handoff listo → [modelo]

Pasos exactos:
  1. Cierra este chat
  2. Abre nuevo chat (en VS Code / Antigravity / Claude Desktop)
  3. Selecciona el modelo destino
  4. Pega este bloque AL INICIO del nuevo chat:

[handoff block]

  5. En Claude Code / Claude Desktop: escribe /new-session
     En Antigravity con Gemini: escribe "Ejecuta /new-session"

Qué hará el modelo al recibir el handoff:
  → Lee el bloque <handoff> → identifica proyecto + branch
  → Lee docs/PROJECT_STATE.md automáticamente
  → Te muestra estado actual + plan para continuar desde donde quedaste
```

**If GPT-4 / OpenAI API:**
```
✅ Handoff listo → GPT-4

GPT no tiene slash commands ni hooks — usa system prompt.

Pasos exactos:
  1. Abre ChatGPT, API Playground, o tu cliente OpenAI
  2. Crea un nuevo chat
  3. Como SYSTEM PROMPT (antes de cualquier mensaje), pega:
     → El contenido de ~/.claude/CLAUDE.md (o tu GLOBAL_BEHAVIOR file)
  4. Como primer USER MESSAGE, pega:

[handoff block]

  5. En ese mismo mensaje, añade:
     "Lee el bloque anterior. Eres mi asistente de desarrollo.
      Tu primera tarea es: [Next del handoff]"

Lo que NO funcionará en GPT:
  - /new-session, /checkpoint (no hay slash commands)
  - Hooks automáticos
  - Lectura automática de archivos del proyecto

Workaround: adjunta docs/PROJECT_STATE.md como archivo si tu cliente lo permite,
o copia el bloque <session> y pégalo junto al handoff.
```

**If Cursor:**
```
✅ Handoff listo → Cursor

Pasos exactos:
  1. Abre Cursor y el proyecto
  2. Verifica que las rules estén activas: .cursor/rules/global.mdc (Agent Mode)
  3. Abre nuevo chat en Agent Mode (no Chat/Composer — esos no leen rules)
  4. Pega este bloque AL INICIO:

[handoff block]

  5. Escribe: /new-session
     (Skills instalados en .cursor/commands/ via install.sh)

Si no instalaste skills en Cursor: escribe el nombre del skill como texto
  → "Ejecuta el skill new-session" o copia el contenido del skill

Lo que NO funcionará en Cursor:
  - Hooks automáticos (guard, snapshot, sync-gemini)
  - Auto-snapshot de docs/
  - sync-gemini (copia manual si cambias CLAUDE.md)
```

**If another dev (Team):**
```
✅ Handoff listo → [Dev Name]

Comparte esto con [Dev Name]:
  1. git pull origin main
  2. git checkout work/[branch]
  3. Abre nuevo chat en su IDE
  4. Pega este bloque:

[handoff block]

  5. Escribe: /new-session
  Su sección en PROJECT_STATE.md ya está actualizada.
```

---

## Mode 4 — Approve PR (Team · Lead only)

Review a dev's branch and merge to main.

Usage: `/checkpoint approve-pr work/[branch-name]`

**Steps:**
1. Run: `git log main..work/[branch] --oneline` → list commits in branch
2. Run: `git diff main...work/[branch] --stat` → files changed
3. **Identify Dev and Phase:**
   - Dev: read `## Team` in CLAUDE.md → match branch to member (`work/phase1-backend` → Backend dev)
   - Phase: read branch prefix (`work/phase1-*` → Phase 1), then read ROADMAP.md Phase 1 expected outcome
   - If branch doesn't follow `work/phaseN-role` pattern → ask: "¿A qué fase y dev pertenece este branch?"
4. **Verify dev's SESSION is up to date:**
   - Read PROJECT_STATE.md → find `### [Dev Name]` section → check `Updated:` field
   - Compare `Updated:` vs date of latest commit on the branch (`git log work/[branch] -1 --format=%ci`)
   - If SESSION.Updated is OLDER than last commit → warn before continuing:
     ```
     ⚠️ La sección de [Dev Name] en PROJECT_STATE no fue actualizada.
        Último commit: [date] · Último checkpoint: [Updated date]
        Recomienda al dev: /checkpoint close antes del PR
        ¿Continuar de todas formas? [s/n]
     ```
   - If SESSION.Updated matches or is newer → ✅ proceed silently
5. **Auto-detect GO/NO-GO trigger:**
   - Read CLAUDE.md `## Team → Members` → list all branches for this phase
   - Run `git branch -r --merged main` → check which work/phaseN-* branches are already merged
   - If THIS merge = last unmerged branch of phase → auto-flag: "⚠️ Todos los branches de Phase [N] mergeados — GO/NO-GO requerido"
6. **Check who gets unblocked:**
   - Read PROJECT_STATE.md → find dev sections with `Dependencies: Waiting for [branch/role]`
   - List them in output
6. Show review summary:
```
## PR Review — work/[branch-name]

**Dev:** [Name] ([Role]) — inferred from branch name
**Commits:** [N] commits
  - feat: auth endpoint
  - fix: validate password
  
**Files changed:**
  + src/auth.ts (+150 -30)
  + src/models.ts (+45)
  
**Matches ROADMAP Phase [N]:** [YES / PARTIAL / NO]
  → Expected: [outcome from ROADMAP Phase N]
  → Actual: [what commits say was done]
  
**Blockers resolved:** [YES / NO — check Dependencies in PROJECT_STATE]
**Tests/checks:** [run if applicable]
[⚠️ Último branch de Phase [N] — se pedirá GO/NO-GO si apruebas]

Aprobar y mergear a main? [s/n]
```
7. If YES:
   - `git checkout main && git merge work/[branch] --no-ff -m "merge: [branch] — [description]"`
   - Update `## Shared Status` in PROJECT_STATE.md:
     - `Last Merge: [dev] — [what] — [date]`
     - `Updated: now`
   - If last branch of phase (from Step 4) → ask: "¿Phase [N] complete? ¿GO/NO-GO? [go/adapt/kill]"
     - Update ROADMAP.md phase status accordingly
   - `git push origin main`
8. If NO → add comment: "¿Qué falta? (Para que el dev corrija)"
9. Output (10 lines max):
```
✅ Merged — work/[branch] → main

Dev [Name]: [what was merged]
ROADMAP Phase [N]: [In Progress / Complete]

Desbloqueados: [Dev B] puede continuar (esperaba este merge) ✅
[o: Nadie bloqueado por este merge]

[If phase complete:]
Phase [N] GO/NO-GO: [GO → proceed to Phase N+1 / ADAPT / KILL]
```

---

## Rules

- Always update state block (< 2 minutes of work)
- Done field: auto-generated from git log (no manual typing needed)
- Always write claude-progress.txt on Full Close (Mode 2) — it's the lightweight state bridge
- Team: each dev edits ONLY their section — never touch others
- Leader: only Leader runs Mode 4 (approve-pr)
- Never force push — if conflict, ask user
- If stuck → `/checkpoint close` + `/restore` to review options
- Handoff instructions must match the detected surface — don't show IDE steps for a chat session
