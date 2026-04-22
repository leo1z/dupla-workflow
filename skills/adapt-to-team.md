Convert an existing individual project to team mode.

Usage: /adapt-to-team

---

## When to Use

- Project started as individual, now adding collaborators
- Want to add Lead + Devs + git branch strategy to existing docs
- No need to redo /new-project from scratch

---

## Phase 1 — Detect Current State

Read docs/PROJECT_STATE.md YAML:
- `project_type: individual` → proceed
- `project_type: team` → "Este proyecto ya está en modo equipo. ¿Quieres editar el equipo? → /add-team-member"
- Missing → assume individual, proceed

Read current docs to understand what exists:
- CLAUDE.md (project) → current phase, stack, constraints
- docs/ROADMAP.md → phases and current progress
- docs/PROJECT_STATE.md → current state

Show summary:
```
## Proyecto actual

**Fase:** [current phase]
**Estado:** [Done + Next from PROJECT_STATE]
**Docs encontrados:** CLAUDE.md, ROADMAP.md, PROJECT_STATE.md [, ARCHITECTURE.md]

¿Convertir a modo equipo? [s/n]
```

---

## Phase 2 — Team Interview (Patrón Estándar — one message)

```
Configuración del equipo:

1. ¿Quién es el Lead? (nombre)
   → Aprueba PRs, mergea a main, controla PROJECT_STATE Shared Status

2. ¿Cuántos miembros? Lista cada uno:
   [Nombre] — [Rol: Backend/Frontend/DB/Design/etc]

3. Revisando tu ROADMAP: las fases actuales son:
   - Phase 1: [summary]
   - Phase 2: [summary]
   
   ¿Cómo dividirían el trabajo? (puede ajustarse después)
   Ejemplo: "Dev A hace backend de Phase 1, Dev B hace frontend"
```

Wait for ALL answers before proceeding.

---

## Phase 3 — Show Diff (confirm before changing)

Show exactly what will change:

```
## Cambios que se harán:

**docs/PROJECT_STATE.md:**
  - Cambiar project_type: individual → team
  - Reemplazar <session> block con ## Team Status (secciones por dev)
  - Estado actual conservado en primera sección

**CLAUDE.md:**
  - Agregar ## Team section (leader, members, branches)
  - Agregar ## Git Strategy section
  - Resto del archivo intacto

**docs/ROADMAP.md:**
  - Agregar ### Role Assignments en cada fase existente
  - Resto del archivo intacto

**Branches a crear:**
  - work/phase1-[role-a] (para [Dev A])
  - work/phase1-[role-b] (para [Dev B])

¿Proceder? [s/n]
```

---

## Phase 4 — Backup + Convert

**Step 1: Backup (automatic)**
```bash
git checkout -b backup/before-team-$(date +%Y%m%d)
git add docs/PROJECT_STATE.md CLAUDE.md docs/ROADMAP.md
git commit -m "backup: individual state before team conversion"
git checkout main
```

**Step 2: Update docs/PROJECT_STATE.md**
- Change YAML: `project_type: individual` → `project_type: team`
- Replace `<session>` block with `## Team Status` structure
- Preserve current Done/Next/Blockers → put in first Dev's section as starting state
- Add `## Shared Status` (pre-fill with current phase)

**Step 3: Update CLAUDE.md**
- Add `## Team` section with leader + member list + branch assignments
- Add `## Git Strategy` section with branch structure + merge order
- Keep all existing sections intact

**Step 4: Update docs/ROADMAP.md**
- Add `### Role Assignments` comment block to each existing phase
- Populate with assignments from Phase 2 answers
- Keep all existing content intact

**Step 5: Create work branches**
```bash
git checkout -b work/phase1-[role-a]
git checkout main
git checkout -b work/phase1-[role-b]
git checkout main
# etc for each dev
git push origin --all
```

**Step 6: If error at any step**
```bash
git checkout backup/before-team-[date]
# Revert to backup
```

---

## Output (max 12 lines)

```
✅ Proyecto convertido a modo equipo

**Lead:** [name] (aprueba PRs → main)
**Equipo:**
  - [Dev A] ([Role]) → work/phase1-[role]
  - [Dev B] ([Role]) → work/phase1-[role]

**Docs actualizados:**
  - docs/PROJECT_STATE.md (Team Status con secciones por dev)
  - CLAUDE.md (Git Strategy + Team)
  - docs/ROADMAP.md (Role Assignments por fase)

**Backup en:** backup/before-team-[date]

**Siguiente:**
  → Cada dev: git checkout work/[su-branch] → /new-session
  → Lead: /checkpoint approve-pr [branch] para revisar y mergear
```

---

## Rules

- Always backup before modifying
- Never delete existing content — only add sections
- Preserve current project state in first Dev's section
- Rollback automatically if any step fails
- Roles are editable after: /add-team-member or edit CLAUDE.md ## Team manually
