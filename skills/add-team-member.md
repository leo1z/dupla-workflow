Add a new member to an existing team project. Also used to edit roles.

Usage: /add-team-member

---

## When to Use

- Adding a new collaborator mid-project
- Changing an existing dev's role or branch
- Project was individual, now adding first collaborator → use /adapt-to-team instead

---

## Phase 1 — Detect State

Read docs/PROJECT_STATE.md YAML:
- `project_type: team` → proceed
- `project_type: individual` → "Este proyecto es individual. Para convertirlo a equipo: /adapt-to-team"

Read CLAUDE.md → ## Team section → show current team:
```
## Equipo actual

**Lead:** [name]
**Members:**
  - [Dev A] ([Role]) → work/phase1-[role]
  - [Dev B] ([Role]) → work/phase1-[role]

¿Qué quieres hacer?
  1 — Agregar nuevo miembro
  2 — Cambiar rol de miembro existente
  3 — Cambiar Lead
```

---

## Phase 2A — Add New Member

Ask in ONE message:
```
Nuevo miembro:
1. Nombre:
2. Rol: [Backend / Frontend / DB / Design / Other]
3. ¿En qué fase empieza? [Phase 1 / Phase 2 / current phase]
4. ¿Hay trabajo ya asignado que deba asumir, o empieza desde cero?
```

From answers → determine:
- Branch name: `work/phase[N]-[role]`
- Which ROADMAP tasks to assign
- Dependencies with existing devs

---

## Phase 2B — Edit Existing Member

Ask:
```
¿Qué cambiar?
  - [Dev A] → nuevo rol: [?]
  - [Dev A] → nueva rama: [?]
  - [Dev A] → asumir tareas de [Dev B]
```

Show current assignment → confirm change → update.

---

## Phase 2C — Change Lead

Ask: "¿Quién será el nuevo Lead? (debe ser miembro actual del equipo)"

Confirm: "¿[New Lead] asumirá la responsabilidad de aprobar PRs y mergear a main? [s/n]"

---

## Phase 3 — Show Changes

```
## Cambios:

**CLAUDE.md → ## Team:**
  + [New Dev] ([Role]) → work/phase[N]-[role]

**docs/PROJECT_STATE.md → ## Team Status:**
  + ### [New Dev] ([Role]) — work/phase[N]-[role]
    Updated: [today]
    Done: (starts fresh)
    Next: [assigned tasks from ROADMAP]
    Blockers: none
    Dependencies: [if applicable]

**docs/ROADMAP.md → Phase [N] Role Assignments:**
  + [New Dev]: work/phase[N]-[role]
    - [assigned tasks]

**Branch to create:** work/phase[N]-[role]

¿Confirmar? [s/n]
```

---

## Phase 4 — Apply Changes

**Step 1: Update CLAUDE.md**
- Add new member to ## Team → Members list
- Add branch to git strategy section

**Step 2: Update docs/PROJECT_STATE.md**
- Add new `### [Dev Name]` section under ## Team Status
- Pre-fill Next with assigned tasks from ROADMAP

**Step 3: Update docs/ROADMAP.md**
- Add member to `### Role Assignments` in relevant phases

**Step 4: Create branch**
```bash
git checkout -b work/phase[N]-[role]
git checkout main
git push origin work/phase[N]-[role]
```

**Step 5: Commit**
```bash
git add CLAUDE.md docs/PROJECT_STATE.md docs/ROADMAP.md
git commit -m "team: add [Name] as [Role] to project"
git push origin main
```

---

## Output

```
✅ [Dev Name] agregado al equipo

**Rol:** [Role]
**Branch:** work/phase[N]-[role]
**Tareas asignadas:**
  - [Task 1 from ROADMAP]
  - [Task 2]

**Para empezar:**
  → [Dev Name]: git clone [repo] && git checkout work/phase[N]-[role]
  → Luego: /new-session (el sistema mostrará su sección y tareas)

**Docs actualizados:** CLAUDE.md, PROJECT_STATE.md, ROADMAP.md
```

---

## Rules

- Roles are flexible — change anytime without breaking system
- New dev always gets their own section in PROJECT_STATE.md
- Branch created automatically (or gives command if can't run git)
- If dev assumes work from another → move their tasks to new section, don't delete old section
- Lead change: old Lead still visible in history
