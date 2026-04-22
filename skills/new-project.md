Initialize new project with IML assessment. Structured discovery for ANY project type.

Usage: /new-project

---

## Phase 0 — Project Setup

Ask TWO questions upfront (in same message):

**Maturity:**
"¿Dónde está tu idea?
  1 — Idea nueva (nunca investigada)
  2 — Ya investigada (tengo research, sin MVP definido)
  3 — MVP ya definido (sé exactamente qué construir)
  4 — En construcción (ya existe, quiero integrar al workflow)"

**Team:**
"¿Trabajas solo o en equipo?
  1 — Individual (solo tú)
  2 — Equipo (2+ personas, con un lead que aprueba cambios)"

Based on Maturity:
- **1** → continue with Phase 1, include research
- **2** → skip Phase 4 research, ask "¿Dónde está el research?"
- **3** → skip Phase 2 + 4, ask "¿Dónde están ROADMAP + ARCHITECTURE?"
- **4** → redirect to `/adapt-project`

Based on Team:
- **Individual** → use CLAUDE_TEMPLATE.md + PROJECT_STATE_TEMPLATE.md
- **Equipo** → after Phase 6 (Clarity Check), ask team questions (Phase 6B)
  then use CLAUDE_TEAM_TEMPLATE.md + PROJECT_STATE_TEAM_TEMPLATE.md

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

## Phase 2 — IML Assessment (Patrón Estándar)

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

## Phase 3 — Clarity Check (binary validation)

Show summary with binary YES/NO for each:

```
## Clarity Check

- [ ] Problem is SPECIFIC (not vague)
- [ ] 3 real people/customers identified
- [ ] Core action/flow defined (3 steps)
- [ ] Main risk/assumption named
- [ ] Constraints clear (time/budget/deadline)

✅ All YES to proceed
❌ Any NO → which needs work?
```

If any NO → offer to refine that section:
"¿Cuál necesita más claridad?"
Ask just that section again, then re-run Clarity Check.

Repeat until all 5 are YES.

---

## Phase 4 — Research (parallel, if approved)

Only if Clarity Check passed:

"¿Investigación rápida del mercado? [s/n]"

If yes → spawn 3 parallel subagents:
- Agent 1: Competitive analysis (direct competitors, alternatives)
- Agent 2: Market size (TAM/SAM/SOM, demand signals)
- Agent 3: Similar solutions (what exists, how they work)

Combine results into brief summary (max 200 words).

---

## Phase 5 — Stack/Tools Recommendation

By project type, suggest:

**Software:** (4-axis decision tree)
- Frontend: React/Vue/Svelte? → suggest + npm install
- Backend: Node/Python/Go? → suggest + setup
- Database: SQL/NoSQL + provider (Supabase/MongoDB/etc)
- Deployment: Vercel/VPS/AWS? → with commands

**Negocio:** Tools table
- Operations: Notion/Airtable
- Payment: Stripe/Polar
- Communication: Slack/Telegram API
- Scheduling: Calendly/Typeform

**Contenido:**
- Writing: Markdown/Notion/Medium
- Design: Canva/Figma
- Publishing: Substack/Ghost/YouTube
- Analytics: Google Analytics/Substack stats

**Investigación:**
- Collaboration: Notion/Google Docs
- Analysis: Jupyter/Observable/Airtable
- Sources: Zotero/Notion for research library

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

IML Score: [1-5] (5 = ready to build)
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

## Phase 7 — Generate Project Docs

### Folder Structure first:

```bash
# For Software
mkdir -p src docs tests public

# For Negocio
mkdir -p docs content assets

# For Contenido
mkdir -p posts assets media

# For Investigación
mkdir -p research notes data

# All types:
git init
git add .
git commit -m "chore: initialize project structure"

# If TEAM: create work branches
git checkout -b work/phase1-[role-a]
git checkout main
git checkout -b work/phase1-[role-b]
git checkout main
```

Execute BEFORE generating docs.

### Docs to Create:

**Individual:**
1. **docs/PROJECT_STATE.md** — from PROJECT_STATE_TEMPLATE.md (`project_type: individual`)
2. **docs/ROADMAP.md** — from ROADMAP_TEMPLATE.md (no role assignments section)
3. **docs/ARCHITECTURE.md** (if software) or **docs/PLAN.md** (if non-software)
4. **docs/PROBLEMS.md** (empty)
5. **CLAUDE.md** — from CLAUDE_TEMPLATE.md

**Team (all of above PLUS):**
1. **docs/PROJECT_STATE.md** — from PROJECT_STATE_TEAM_TEMPLATE.md (`project_type: team`)
   - Fill Dev sections with names and roles from Phase 6B
2. **docs/ROADMAP.md** — from ROADMAP_TEMPLATE.md WITH Role Assignments filled per phase
3. **CLAUDE.md** — from CLAUDE_TEAM_TEMPLATE.md
   - Fill Team section (leader, members, branches)
   - Fill Git Strategy (branch names, merge order)

---

## Output (max 15 lines)

**Individual:**
```
✅ Project Initialized — [name]

**Type:** Individual · [Software/Negocio/Contenido/Investigación]
**IML Score:** [1-5]

Created:
- docs/PROJECT_STATE.md
- docs/ROADMAP.md (hypothesis → Phase 1 MVP → GO/NO-GO)
- [docs/ARCHITECTURE.md | docs/PLAN.md]
- docs/PROBLEMS.md
- CLAUDE.md

Next: /new-session to start Phase 1
```

**Team:**
```
✅ Project Initialized — [name] (Team: [N] devs)

**Type:** Team · [Software/Negocio/Contenido/Investigación]
**Lead:** [name] · **Members:** [Dev A (Role)], [Dev B (Role)]
**IML Score:** [1-5]

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
- **If Phase 3 (Clarity Check) failed:** Auto-refine, don't abandon
- **All 7 questions** must be answered before Clarity Check (unless skipped via Phase 0)
- **Clarity Check = 5 binary validations** (no maybe)
- **IML Score = subjective:** 1 (idea only), 5 (ready to build)
- **Research runs in parallel** (don't block on speed)
- **Roadmap must have GO/NO-GO** at each phase
- **NEVER create docs with empty placeholders** — infer from answers
- **Always create folder structure FIRST** (before docs generation)
- **Always init git** after folder creation (git init + commit)
