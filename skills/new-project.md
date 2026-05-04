Initialize new project with IML assessment. Structured discovery for ANY project type.

Usage: /new-project

---

## Phase 0 — Project Setup

> 💡 **Claude Code IDE:** Activa Plan Mode (Shift+Tab) antes de continuar — afina el plan antes de ejecutar.
> **Otros entornos (Antigravity, Terminal, Cursor):** omite esta instrucción — continúa directamente.

Ask TWO questions upfront (in same message):

**Maturity:**
"¿Dónde está tu idea?
  1 — Idea nueva (nunca investigada ni validada con personas reales)
  2 — Ya investigada (tengo research, sin MVP definido)
  3 — MVP ya definido (sé exactamente qué construir)
  4 — En construcción (ya existe, quiero integrar al workflow)"

**Team:**
"¿Trabajas solo o en equipo?
  1 — Individual (solo tú)
  2 — Equipo (2+ personas, con un lead que aprueba cambios)"

Based on Maturity:
- **1** → run **Phase 0.5 (Validation Gate)** before continuing
- **2** → skip Phase 4 research, ask "¿Dónde está el research?"
- **3** → skip Phase 2 + 4, ask "¿Dónde están ROADMAP + ARCHITECTURE?"
- **4** → redirect to `/adapt-project`

Based on Team:
- **Individual** → use CLAUDE_TEMPLATE.md + PROJECT_STATE_TEMPLATE.md
- **Equipo** → after Phase 6 (Clarity Check), ask team questions (Phase 6B)
  then use CLAUDE_TEAM_TEMPLATE.md + PROJECT_STATE_TEAM_TEMPLATE.md

---

## Phase 0.5 — IML Assessment (only if Maturity = 1)

Evaluar viabilidad de la idea antes de invertir tiempo en el flujo completo.
Ser objetivo, no optimista. El objetivo es detectar gaps reales — no aprobar todo.

Ask ALL in ONE message:

```
Antes de construir, evaluemos la viabilidad real de tu idea:

1. ¿Cuál es el problema exacto que resuelve? (una oración específica — sin solución todavía)
2. ¿Cuándo fue la última vez que tú u otra persona experimentó este problema? (situación concreta)
3. ¿Hablaste con personas reales que tienen este problema? [s/n]
   → Si sí: ¿cuántas? ¿qué dijeron exactamente?
   → Si no: ¿qué señal tienes de que existe? (post, queja, tu propia experiencia)
4. ¿Alguien pagaría por resolverlo? [s/n] ¿Cuánto? ¿Por qué sí o no?
5. ¿Qué existe hoy para resolver esto? ¿Por qué no alcanza?
6. ¿Cuál es tu ventaja real para resolver esto vs. alguien más? (acceso, skills, red, timing)
7. Si construyes esto y nadie lo usa — ¿qué asunción resultó falsa?
```

**Evaluate responses — score por dimensión (interno, no mostrar números al usuario):**

| Dimensión | Señal fuerte | Señal débil |
|---|---|---|
| Problema | Específico + momento concreto | Vago, genérico, "sería útil" |
| Validación | 3+ personas confirmaron | Solo opinión propia |
| Disposición a pagar | Cifra concreta o "pagaría X" | "Tal vez", "depende" |
| Mercado | Alternativas claras y sus gaps | "No existe nada igual" |
| Ventaja | Acceso exclusivo o skill específico | "Soy muy apasionado" |
| Riesgo | Asunción específica nombrada | "No sé" o no responde |

**Resultado — 3 posibles salidas:**

**✅ VERDE (4+ dimensiones fuertes):** continúa a Phase 1.
```
✅ Idea lista para definir.

Fortalezas:
  - [dimensión 1]: [por qué es sólida]
  - [dimensión 2]: [por qué es sólida]

Riesgo principal a monitorear: [dimensión más débil]
→ Añadiremos esto como Kill Condition en el ROADMAP.

Continuamos con la entrevista completa.
```

**⚠️ AMARILLO (2–3 dimensiones fuertes):** continúa pero con advertencia explícita.
```
⚠️ Idea con gaps — puedes continuar, pero hay riesgos reales.

Sólido:
  - [dimensiones fuertes]

Gaps a resolver antes de construir:
  - Validación: [gap específico + acción concreta]
  - [otra dimensión]: [gap + acción]

Opciones:
  1 — Continuar de todas formas (asumes los riesgos)
  2 — Primero valida [gap X] (te doy un prompt para hacerlo ahora)
  3 — Salir — vuelve cuando tengas la validación
```

**❌ ROJO (0–1 dimensiones fuertes):** stop con orientación específica.
```
❌ La idea no está lista para construir.

El problema principal: [qué es lo más débil — específico]

Antes de continuar, necesitas:
  1. [Acción concreta de validación — ej: "habla con 3 personas que hayan pagado por X"]
  2. [Segunda acción si aplica]

Prompt para validar ahora:
---
Tengo esta idea: [idea del usuario]
Ayúdame a:
1. ¿Es un problema real o una solución buscando problema?
2. ¿Quién lo tiene — 3 personas específicas con nombre/rol?
3. ¿Qué hacen hoy para resolverlo? ¿Cuánto les cuesta (tiempo/dinero)?
4. ¿Pagarían por una solución? ¿Cuánto?
5. ¿Cómo validarlo en 1 semana sin construir nada?
---

Vuelve cuando tengas al menos: problema específico + 2 personas confirmaron + señal de pago.
```

→ **Stop en ROJO.** No continuar hasta que el usuario regrese con validación.

---

## Phase 1 — Project Type

"¿Qué tipo de proyecto?
  1 — Software/SaaS (application, platform)
  2 — Negocio (service, process, business model)
  3 — Contenido (writing, marketing, creative)
  4 — Investigación (research, analysis, learning)
  5 — Otro"

Select one → determine question language + docs generated.

---

## Phase 2 — Entendamos tu idea

Ask ALL 7 questions in ONE message (language adapted to project type):

### For Software:
1. **Problem:** Describe the LAST time you (or user X) experienced this problem. Specific moment.
2. **Solution:** What does someone do TODAY when this problem happens? Describe the workaround.
3. **User:** Name 3 actual people (not "developers") who have this problem.
4. **Value:** How much would someone pay to solve it? Why yes/no?
5. **MVP:** What's the ONE most important flow in 3 steps?
6. **Risk:** What assumption, if false, kills this? Name it.
7. **Constraints:** Time/week, deadline, budget for tools. Hard limits?

### For Negocio:
1. **Problem:** When last saw/lived this problem? Real scenario.
2. **Solution:** What does market do now? Alternative services?
3. **Customer:** 3 real businesses/people with this need. Specific.
4. **Value:** Price point? Why would they buy?
5. **MVP:** Core service in 3 steps?
6. **Risk:** Market assumption that if wrong, kills it?
7. **Constraints:** Launch deadline? Team size? Budget?

### For Contenido:
1. **Audience:** Who reads/consumes this? 3 real people.
2. **Problem:** What problem does your content solve for them?
3. **Channels:** Where do they consume content? (TikTok, newsletters, etc.)
4. **Competition:** Who else makes similar content? Why better/different?
5. **Format:** Blog, video, podcast, newsletter, book? Why?
6. **Distribution:** How will people FIND it?
7. **Constraints:** Time/week to create? Tools/budget? Deadlines?

### For Investigación:
1. **Question:** What's the core question you're trying to answer?
2. **Current State:** What's known vs. unknown?
3. **Impact:** Who cares about this answer? Why?
4. **Methodology:** How will you find the answer? (research method)
5. **Sources:** Where's the data/information? (books, interviews, experiments)
6. **Risk:** What if your hypothesis is completely wrong?
7. **Timeline:** How long? Deadlines or hard stops?

**Wait for ALL answers before proceeding.**

---

## Phase 3 — ¿Está clara la idea?

Show summary with binary YES/NO for each:

```
## ¿Está clara la idea?

- [ ] El problema es ESPECÍFICO (no vago)
- [ ] Hay 3 personas reales identificadas
- [ ] El flujo principal está definido (3 pasos)
- [ ] El riesgo principal está nombrado
- [ ] Los límites están claros (tiempo/presupuesto/deadline)

✅ Todo YES → seguimos
❌ Algún NO → ¿cuál necesita más claridad?
```

If any NO → offer to refine that section:
"¿Cuál necesita más claridad?"
Ask just that section again, then re-run Clarity Check.

Repeat until all 5 are YES.

---

## Phase 4 — Research (parallel, if approved)

Only if Clarity Check passed:

"¿Investigación rápida del mercado? [s/n]"

If yes:
- **If subagents available** (Claude Code, Antigravity with multi-agent) → spawn 3 parallel subagents:
  - Agent 1: Competitive analysis (direct competitors, alternatives)
  - Agent 2: Market size (TAM/SAM/SOM, demand signals)
  - Agent 3: Similar solutions (what exists, how they work)
- **If subagents NOT available** (Claude Desktop, single-agent IDEs) → execute sequentially:
  1. Competitive analysis: "¿Quiénes son los competidores directos y alternativas actuales?"
  2. Market size: "¿Cuál es el tamaño estimado del mercado y señales de demanda?"
  3. Similar solutions: "¿Qué soluciones similares existen y cómo funcionan?"
  - Wait for each answer before next — same 3 topics, sequential instead of parallel

Combine results into brief summary (max 200 words).

---

## Phase 5 — Stack/Tools Recommendation (adaptado a constraints reales)

No recomendar stack genérico. Usar las respuestas IML para adaptar:

**Inputs que determinan el stack:**
- IML Q7 (Constraints): tiempo/semana, deadline, presupuesto
- IML Q3 (Usuario): ¿usuario técnico o no técnico?
- IML Q6 (Riesgo): ¿cuál es la asunción más frágil? → afecta qué validar primero
- Project type: Software / Negocio / Contenido / Investigación
- Maturity level: 1 (idea) vs 3 (MVP definido) → diferente profundidad

**Para Software — decision tree por constraint:**

```
Tiempo disponible < 5h/semana OR deadline < 4 semanas:
  → Stack mínimo: Next.js + Supabase + Vercel
     Razón: un solo repo, auth integrada, deploy gratis, sin ops

Tiempo disponible ≥ 10h/semana AND deadline > 8 semanas:
  → Stack adaptado al proyecto:
     - Data-heavy → Python (FastAPI) + PostgreSQL + Railway
     - Real-time → Next.js + Supabase Realtime + Vercel
     - Mobile-first → React Native (Expo) + Supabase
     - CLI/scripts → Python o Go + SQLite

Usuario no técnico (solo tú construyes, ellos usan):
  → Priorizar: UI lista (shadcn/ui, Radix) + auth sin fricción (Supabase Auth o Clerk)

Presupuesto = $0:
  → Todo en tier gratuito: Vercel (frontend) + Supabase (DB+auth) + Railway free (backend)
  → Evitar: Firebase (costoso en escala), AWS (complejo para MVP)

Riesgo principal = adopción/validación:
  → No construyas el backend completo primero
  → Semana 1: landing + waitlist (Next.js + Resend) para validar demanda antes de code
```

Mostrar como tabla concisa:
```
## Stack Recomendado — [nombre proyecto]

| Capa | Opción | Por qué |
|---|---|---|
| Frontend | [X] | [razón ligada a tu constraint] |
| Backend | [X] | [razón] |
| DB | [X] | [razón] |
| Auth | [X] | [razón] |
| Deploy | [X] | [razón] |
| Costo estimado MVP | $0–$[X]/mes | [breakdown] |

Alternativa si cambian los constraints: [opción B] — cambia si [condición]
```

**Para Negocio:** tools ligados a la etapa de madurez:
- Maturity 1–2 → Notion + Typeform + Stripe (validar antes de construir)
- Maturity 3+ → Airtable + N8N + Stripe + WhatsApp API (automatizar lo validado)

**Para Contenido:** por canal principal (inferido de IML Q3 Channels):
- TikTok/video → CapCut + Notion + Beehiiv
- Newsletter → Beehiiv o Substack + Notion
- Blog técnico → Ghost o Obsidian Publish

**Para Investigación:** por metodología (inferida de IML Q4):
- Cualitativo → Notion + Transcription (Whisper o Otter.ai)
- Cuantitativo → Jupyter + DuckDB + Observable
- Mixto → Airtable + Jupyter

---

## Phase 6 — Validation Checkpoint

Show before generating:

```
## Launch Checkpoint

**Problem:** [summary]
**User:** [3 people]
**MVP:** [3-step core flow]
**Risk:** [main assumption]
**Time:** [deadline/constraint]
**Stack:** [recommendation]
**Market:** [brief research result]

Listo para construir: [1-5] (5 = listo)
Proceed to docs? [s/n]
```

If NO → ask "¿Qué revisar?" and go back to Phase 3.
If YES → proceed to Phase 6B (if team) or Phase 7 (if individual).

---

## Phase 6B — Team Setup (only if Equipo selected in Phase 0)

Ask in ONE message:

```
Configuración del equipo:

1. ¿Quién es el Lead? (nombre)
   → Aprueba PRs, mergea a main, actualiza estado compartido

2. ¿Cuántos miembros? Lista cada uno:
   [Nombre] — [Rol: Backend/Frontend/DB/Design/etc]

3. ¿Cómo dividirían las fases del roadmap?
   (Puede editarse después — solo una idea inicial)
```

From answers → auto-generate:
- Team section in CLAUDE.md (members, roles, git strategy)
- Role Assignments in ROADMAP.md (per phase, based on roles)
- Branch naming: `work/phase1-[role]` for each dev
- Merge order: infer from dependencies (DB → Backend → Frontend)

---

## Phase 6.5 — SPEC.md (Spec-Driven Development gate)

Before generating any technical docs, create the spec. This is the source of truth for what we're building.

Generate `docs/SPEC.md` from IML answers (max 1 page):

```markdown
# Spec — [Project Name]

## Problema
[One specific sentence from IML Q1]

## Usuario
[3 real people from IML Q3 — names or personas]

## Solución Propuesta
[Core flow in 3 steps from IML Q5]

## MVP Scope (Must build)
- [feature 1]
- [feature 2]

## Out of Scope (Won't build in MVP)
- [item 1]

## Kill Condition
[IML Q6 — the assumption that if false, stops the project]

## Métrica de Éxito
[ONE metric: X users / X revenue / X validated in Y weeks]
```

**If SPEC.md already exists** (Maturity 2 or 3) → ask: "¿Actualizar SPEC.md existente? [s/n]"

---

## Phase 7 — Generate Project Docs

### Folder Structure + Version Control

Ask ONE question first:
```
¿Necesitas git para este proyecto?
  1 — Sí (colaboración, GitHub, historial completo)
  2 — No (proyecto pequeño, personal, sin remote)
```

**With git:**
```bash
# For Software
mkdir -p src docs tests public

# For Negocio
mkdir -p docs content assets

# For Contenido
mkdir -p posts assets media

# For Investigación
mkdir -p research notes data

git init
git add .
git commit -m "chore: initialize project structure"

# Individual: always create work branch (never develop on main)
git checkout -b work

# If TEAM: create role branches instead
# git checkout -b work/phase1-[role-a]
# git checkout main
# git checkout -b work/phase1-[role-b]
# git checkout main
# Push all branches + invite collaborators
# git push origin --all
```

**Without git** (opción 2):
```bash
# Same folder structure without git
mkdir -p docs
mkdir -p _versions  # auto-snapshot target for auto-snapshot.sh hook
```
- No `git init`, no remote
- `auto-snapshot.sh` hook will create `_versions/` copies automatically on Stop
- `/restore` will show `_versions/` entries instead of git stash list
- Add note to PROJECT_STATE.md: `Branch: none (no git)`

**If Team:** after pushing, show collaborator invite instructions:
```
Invitar colaboradores a GitHub:
  1. github.com/[user]/[repo] → Settings → Collaborators
  2. Add each dev by username
  3. They accept invite → git clone [repo-url]
  4. Each dev runs: git checkout work/[su-branch]
  5. Each dev runs: /new-session
```

Execute BEFORE generating docs.

### Docs to Create:

**Individual:**
1. **docs/PROJECT_STATE.md** — from PROJECT_STATE_TEMPLATE.md (`project_type: individual`)
   - Set `Phase: Phase 1 — [first phase name from ROADMAP]`
   - Set `Phase_Status: In Progress`
   - Set `Next: [first concrete action toward Phase 1 MVP]`
2. **docs/ROADMAP.md** — from ROADMAP_TEMPLATE.md (no role assignments section)
   - Fill Phase 1 Outcomes from IML answers (MVP flow = Phase 1 deliverables)
   - Fill GO/NO-GO criteria from Risk answer (IML Q6)
3. **docs/ARCHITECTURE.md** (if software) or **docs/PLAN.md** (if non-software)
4. **docs/PROBLEMS.md** (empty)
5. **CLAUDE.md** — from CLAUDE_TEMPLATE.md

**Team (all of above PLUS):**
1. **docs/PROJECT_STATE.md** — from PROJECT_STATE_TEAM_TEMPLATE.md (`project_type: team`)
   - Fill Dev sections with names and roles from Phase 6B
   - Shared Status: set `Phase: Phase 1 — [name]`, `Status: In Progress`
2. **docs/ROADMAP.md** — from ROADMAP_TEMPLATE.md WITH Role Assignments filled per phase
3. **CLAUDE.md** — from CLAUDE_TEAM_TEMPLATE.md
   - Fill Team section (leader, members, branches)
   - Fill Git Strategy (branch names, merge order)

### Create claude-progress.txt (lightweight task state bridge):

Write to project root:
```
[ ] Complete Phase 1 — [first outcome from ROADMAP]
```
This file is read by new-session Step 0A at ~30 tokens. Checkpoint updates it on close.

---

### Generate docs/code-review-graph.json (project audit map):

After all docs are created, generate the initial project map:
- Run: `ls -la` on project folders to identify actual source structure
- Read: ROADMAP.md Phase 1 Outcomes (to set initial scope)
- Write `docs/code-review-graph.json`:
  - `"project"`: actual project name from `basename $(pwd)` (never `"."` or placeholder)
  - `"generated"`: current timestamp
  - `"lastCommit"`: current git HEAD (or "initial" if no commits yet)
  - `"phase"`: `"Phase 1"` (current phase from ROADMAP)
  - `"structure"`: actual project folders with file counts and purposes
  - `"riskZones"`: critical files inferred from project type (auth/, db/, config, main entry points)
  - `"dependencies"`: doc-to-doc connections (PROJECT_STATE → ROADMAP, CLAUDE.md → PROJECT_STATE, etc.)
  - `"metadata.regenerate"`: `"after phase advance or architectural changes"`
- This file is the project's structural fingerprint at Phase 1 start

---

## Output (max 15 lines)

**Individual:**
```
✅ Project Initialized — [name]

**Type:** Individual · [Software/Negocio/Contenido/Investigación]
**Listo para construir:** [1-5]

Created:
- docs/SPEC.md (problema · usuario · MVP scope · kill condition · métrica)
- docs/PROJECT_STATE.md
- docs/ROADMAP.md (hypothesis → Phase 1 MVP → GO/NO-GO)
- [docs/ARCHITECTURE.md | docs/PLAN.md]
- docs/PROBLEMS.md
- CLAUDE.md
- claude-progress.txt (empty, ready for /checkpoint)

Branch: work (nunca desarrolles en main)
Next: /new-session to start Phase 1
```

**Team:**
```
✅ Project Initialized — [name] (Team: [N] devs)

**Type:** Team · [Software/Negocio/Contenido/Investigación]
**Lead:** [name] · **Members:** [Dev A (Role)], [Dev B (Role)]
**Listo para construir:** [1-5]

Created:
- docs/PROJECT_STATE.md (## Team Status with Dev sections)
- docs/ROADMAP.md (with Role Assignments per phase)
- [docs/ARCHITECTURE.md | docs/PLAN.md]
- docs/PROBLEMS.md
- CLAUDE.md (git strategy + team structure)

Branches created: work/phase1-[role-a], work/phase1-[role-b]
Next: each dev runs /new-session on their branch
Lead: /checkpoint approve-pr [branch] to review and merge
```

---

## Rules

- **Phase 0:** Always ask maturity + individual/team in same message
- **If Phase 3 (¿Está clara la idea?) failed:** Auto-refine, don't abandon
- **All 7 questions** must be answered before Phase 3 (unless skipped via Phase 0)
- **Phase 3 = 5 binary validations** (no maybe)
- **Listo para construir = subjective:** 1 (solo idea), 5 (listo para ejecutar)
- **Phase 0.5:** if maturity = 1 and idea not validated → stop and show validation prompt, don't continue
- **Research runs in parallel** (don't block on speed)
- **Roadmap must have GO/NO-GO** at each phase
- **NEVER create docs with empty placeholders** — infer from answers
- **Always create folder structure FIRST** (before docs generation)
- **Always init git** after folder creation (git init + commit)
