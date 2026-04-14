Register a new skill into the dupla-workflow system and update all dependent docs.

Usage: /add-skill <name>
  - <name> must match the filename in ~/.claude/commands/ (without .md)
  - Example: /add-skill token-budget

---

## Step 1 — Find and read skill file

Look for: `~/.claude/commands/<name>.md`

If not found:
  → "Skill file not found: ~/.claude/commands/<name>.md — create it first."
  → STOP

Read the file. Extract:
- **Description:** first non-empty line that isn't a header
- **When to use:** any "When", "Usage", "Cuándo" section, or infer from content
- **Command:** /<name>

---

## Step 2 — Classify skill

Classify into one of three categories:

| Category | Definition | Examples |
|---|---|---|
| **Core Workflow** | Session or project lifecycle management | new-session, progress, new-project, update-context, health-check, add-skill |
| **Utility** | Tools that assist work but aren't session lifecycle | token-budget, adopt, setup |
| **Plugin** | External/third-party skills installed separately | ui-ux-pro-max, frontend-slides |

If unsure → ask ONE question: "¿Es un skill del workflow (sesión/proyecto) o una herramienta auxiliar?"

---

## Step 3 — Update docs

### 3a. ~/.claude/PROJECTS_SKILLS.md (ALWAYS)

Read current file.

- If **Core Workflow** → add row to "Core Skills" table
- If **Utility** → add row to "Core Skills" table (below workflow skills)
- If **Plugin** → add row to "Installed Plugins" table

Row format:
```
| <name> | /<name> | <when to use — 1 line> |
```

Write updated file.

---

### 3b. dupla-workflow/templates/GUIA_COLABORADOR.md (if user-facing)

Read current file.

If skill is user-facing (not setup/internal):
  → Add row to "Sistema de comandos" table

Row format:
```
| `/<name>` | <what it does — 1 line> | <when — 1 line> |
```

Write updated file.

---

### 3c. dupla-workflow/global-templates/PROJECTS_SKILLS_TEMPLATE.md (if Core Workflow only)

Read current file.

If skill is **Core Workflow**:
  → Add row to "Core Skills" table (same format as 3a)

Write updated file.

---

### 3d. dupla-workflow/commands/<name>.md (sync)

Check if `dupla-workflow/commands/<name>.md` exists.

If NOT → copy from `~/.claude/commands/<name>.md`
If YES → skip (already synced)

---

## Step 4 — Commit dupla-workflow

```bash
cd ~/Projects/dupla-workflow
git add commands/<name>.md templates/GUIA_COLABORADOR.md global-templates/PROJECTS_SKILLS_TEMPLATE.md
git commit -m "feat: register skill /<name> — update PROJECTS_SKILLS, GUIA_COLABORADOR, template"
git push origin master
```

---

## Step 5 — Output (max 10 lines)

---
## Skill Registered — /<name>

**Category:** [Core Workflow / Utility / Plugin]

**Updated:**
- ~/.claude/PROJECTS_SKILLS.md → [table] row added
- dupla-workflow/templates/GUIA_COLABORADOR.md → Command Map row added (if applicable)
- dupla-workflow/global-templates/PROJECTS_SKILLS_TEMPLATE.md → (if Core Workflow)
- dupla-workflow/commands/<name>.md → synced

**Skipped:**
- [any doc that didn't need updating + why]
---

---

## Rules

- Never overwrite existing rows — check for duplicates first
- If skill already registered → report it and STOP (no double entries)
- Do NOT modify health-check.md — it auto-detects unregistered skills via directory scan
- Keep descriptions to 1 line max
- If dupla-workflow path doesn't exist → skip git steps, warn user
