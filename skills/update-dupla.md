Update Dupla-Workflow system to latest version. Downloads from GitHub with auto-backup.

Usage: /update-dupla

---

## Execution

### Step 1 — Check Current Version

```bash
cat ~/.claude/DUPLA_VERSION
# → v2.0.0 (or missing → v1 detected)
```

- If DUPLA_VERSION missing → v1 detected → go to **V1 Migration** section
- If DUPLA_VERSION present → compare with latest

### Step 2 — Check Latest Version

```bash
curl -s https://raw.githubusercontent.com/leo1z/dupla-workflow/master/VERSION
# → v2.1.0
```

Compare:
- Equal → "✅ Ya estás en la última versión (v[X.Y.Z]). Ejecuta /health-check para verificar estado."
- Local newer → "⚠️ Tu versión es más reciente. ¿Tienes cambios locales no publicados?"
- Behind → show CHANGELOG + ask to update

### Step 3 — Show CHANGELOG + Confirm

```
Nueva versión disponible: v[X.Y.Z]

Cambios:
- [feature 1]
- [feature 2]
- [bug fix]

¿Actualizar? [s/n]
```

### Step 4 — Backup + Update

Show commands to user — they must run these in terminal (Claude cannot execute bash directly):

```bash
# Backup current skills
mkdir -p ~/.claude/skills-backup/v[old-version]
cp ~/.claude/skills/*.md ~/.claude/skills-backup/v[old-version]/

# Download new version
git clone --depth 1 https://github.com/leo1z/dupla-workflow.git /tmp/dupla-new

# Update skills
cp /tmp/dupla-new/skills/*.md ~/.claude/skills/

# Update hooks
cp /tmp/dupla-new/hooks/*.sh ~/.claude/hooks/

# Update version marker
cp /tmp/dupla-new/VERSION ~/.claude/DUPLA_VERSION

# Sync Antigravity if exists
if [ -d ~/.agent/ ]; then
  cp ~/.claude/skills/*.md ~/.agent/skills/
fi

# Cleanup
rm -rf /tmp/dupla-new
```

Tell user: "Copia y pega estos comandos en tu terminal. Cuando terminen, vuelve aquí y escribe /health-check"

### Step 5 — Output

```
✅ Actualizado a v[X.Y.Z]

Cambios principales:
- [feature 1]
- [feature 2]

Backup anterior: ~/.claude/skills-backup/v[old-version]/
Siguiente: /health-check para verificar
```

---

## V1 Migration (when DUPLA_VERSION is missing)

Detected if:
- `~/.claude/DUPLA_VERSION` does not exist
- OR `~/.claude/skills/` doesn't exist but `~/.claude/commands/` does

Show:
```
⚠️ Detecté Dupla-Workflow v1 (versión anterior).

Cambios en v2:
- commands/ → skills/ (renombrado)
- CREDENCIALES.md → CREDENTIALS.md
- CONTEXTO_*.md + STACK_GLOBAL.md → CLAUDE.md + SYSTEM.md (fusionados)
- Nuevos skills: checkpoint, restore, adapt-to-team, add-team-member
- SESSION block en PROJECT_STATE (ahorro de tokens)

¿Migrar a v2? [s/n]
(Backup automático antes de cualquier cambio)
```

**If YES — Migration Steps:**

```bash
# 1. Backup everything
mkdir -p ~/.claude/v1-backup
cp -r ~/.claude/commands ~/.claude/v1-backup/ 2>/dev/null || true
cp ~/.claude/CREDENCIALES.md ~/.claude/v1-backup/ 2>/dev/null || true
cp ~/.claude/CONTEXTO_*.md ~/.claude/v1-backup/ 2>/dev/null || true
cp ~/.claude/STACK_GLOBAL.md ~/.claude/v1-backup/ 2>/dev/null || true

# 2. Install v2
git clone --depth 1 https://github.com/leo1z/dupla-workflow.git /tmp/dupla-new
bash /tmp/dupla-new/bin/install.sh

# 3. Rename credentials if needed
if [ -f ~/.claude/CREDENCIALES.md ] && [ ! -f ~/.claude/CREDENTIALS.md ]; then
  cp ~/.claude/CREDENCIALES.md ~/.claude/CREDENTIALS.md
  echo "ℹ️ CREDENCIALES.md → CREDENTIALS.md (v1 backup conservado)"
fi
```

Then ask:
```
Tus archivos globales v1 (CONTEXTO, STACK_GLOBAL) siguen en el backup.
¿Quieres migrar su contenido a CLAUDE.md + SYSTEM.md (v2)? [s/n]

Si sí → corre /setup-dupla para regenerar con tu información actual
Si no → puedes hacerlo después con /setup-dupla
```

For project docs (v1 format):
```
¿Tienes proyectos con docs en formato v1 (sin SESSION block, sin YAML header)?

Para migrar cada proyecto: ve a la carpeta del proyecto y corre /adapt-project
El sistema detectará el formato v1 y actualizará los docs.
```

**If user had custom hooks in v1:**
```
⚠️ Si tenías hooks personalizados en ~/.claude/hooks/ (no los de dupla-workflow):
  - Fueron copiados al backup en ~/.claude/v1-backup/
  - Los nuevos hooks de v2 fueron instalados encima
  - Revisa el backup si necesitas recuperar lógica personalizada
  - Los hooks v2 son: guard-project-state.sh, suggest-checkpoint.sh, session-reminder.sh
```

**Migration output:**
```
✅ Migración v1 → v2 completada

Backup en: ~/.claude/v1-backup/
Skills v2 instalados: 13 commands
Hooks configurados: guard, suggest-checkpoint, session-reminder

Siguiente:
1. /setup-dupla → regenera CLAUDE.md + SYSTEM.md con tu info
2. Para cada proyecto: /adapt-project → migra docs a formato v2
3. /health-check → verifica que todo esté correcto
```

---

## Rollback

```bash
cp ~/.claude/skills-backup/v[old-version]/*.md ~/.claude/skills/
echo "v[old-version]" > ~/.claude/DUPLA_VERSION
echo "✅ Revertido a v[old-version]"
```

---

## Rules

- Always backup before any change
- Never delete v1 files — copy only
- Show CHANGELOG before asking approval
- V1 migration: suggest /setup-dupla instead of auto-converting global docs
- Project doc migration is per-project (/adapt-project), not global
- After update: always suggest /health-check
