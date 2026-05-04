Update Dupla-Workflow system to latest version. Fully automatic — Claude runs all commands.

**When to use:** when `/health-check` reports a version mismatch, or when you want to get the latest skills and hooks.
**See also:** `/health-check` (verify after update) · `/setup-dupla` (first-time setup)

Usage:
  /update-dupla        → full automatic update (backup + download + install)
  /update-dupla check  → check version only (no changes)

---

## Execution

### Step 0 — Detect Mode

If `/update-dupla check`:
- Run Steps 1 + 2 only → show version comparison → STOP

If `/update-dupla` (no args) → full automatic flow below.

---

### Step 1 — Check Current Version

Run via Bash:
```bash
cat ~/.claude/DUPLA_VERSION
```

- Missing → v1 detected → go to **V1 Migration**
- Present → continue

### Step 2 — Check Latest Version

Run via Bash:
```bash
curl -s https://raw.githubusercontent.com/leo1z/dupla-workflow/master/VERSION
```

- Equal → "✅ Ya estás en la última versión (vX.Y.Z). Ejecuta /health-check para verificar."  → STOP
- Local newer → "⚠️ Tu versión local es más reciente que master. ¿Tienes cambios no publicados?" → STOP
- Behind → show CHANGELOG + ask `¿Actualizar? [s/n]`

### Step 3 — Show CHANGELOG + Confirm

Fetch and show relevant section:
```bash
curl -s https://raw.githubusercontent.com/leo1z/dupla-workflow/master/CHANGELOG.md | head -60
```

Show new version + key changes. Ask: `¿Actualizar? [s/n]`

If NO → stop.

---

### Step 4 — Auto-detect Environment (silent)

Run via Bash:
```bash
git --version
python3 --version 2>/dev/null || echo "python3: missing"
ls ~/.cursor/ 2>/dev/null && echo "cursor: yes" || echo "cursor: no"
ls ~/.gemini/antigravity/ 2>/dev/null && echo "antigravity: yes" || echo "antigravity: no"
ls ~/.agent/ 2>/dev/null && echo "agent-legacy: yes" || echo "agent-legacy: no"
```

Detect:
- `HAS_CURSOR` — `~/.cursor/` exists
- `HAS_ANTIGRAVITY` — `~/.gemini/antigravity/` exists
- `HAS_AGENT_LEGACY` — `~/.agent/` exists (old Antigravity path)
- `OLD_VERSION` — from DUPLA_VERSION
- `ANTIGRAVITY_KNOWLEDGE` — `~/.gemini/antigravity/knowledge/` if exists, else `~/.gemini/antigravity/global_workflows/`

---

### Step 5 — Backup + Download

Run via Bash (Claude executes these directly):

```bash
# Backup
mkdir -p ~/.claude/skills-backup/v${OLD_VERSION}
cp ~/.claude/skills/*.md ~/.claude/skills-backup/v${OLD_VERSION}/ 2>/dev/null || true

# Download
rm -rf /tmp/dupla-new
git clone --depth 1 https://github.com/leo1z/dupla-workflow.git /tmp/dupla-new
```

Verify clone: `ls /tmp/dupla-new/skills/*.md | wc -l` — must be > 0, else abort with error.

---

### Step 6 — Deploy Claude Code

```bash
cp /tmp/dupla-new/skills/*.md ~/.claude/skills/
cp /tmp/dupla-new/skills/*.md ~/.claude/commands/
cp /tmp/dupla-new/hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh
cp /tmp/dupla-new/VERSION ~/.claude/DUPLA_VERSION
```

---

### Step 7 — Deploy Antigravity (if detected)

**knowledge/ directory** (trigger: agent_requested):
```bash
KNOWLEDGE_DIR=~/.gemini/antigravity/knowledge
mkdir -p "$KNOWLEDGE_DIR"

# Build current skill filenames
CURRENT_SKILLS=$(ls /tmp/dupla-new/skills/*.md | xargs -I{} basename {})

# Orphan cleanup — only remove files that were deployed by dupla
# (have trigger: frontmatter AND are no longer in source)
for existing in "$KNOWLEDGE_DIR"/*.md; do
  [ -f "$existing" ] || continue
  fname=$(basename "$existing")
  [ "$fname" = "CLAUDE.md" ] && continue
  [ "$fname" = "DUPLA_VERSION" ] && continue
  if ! echo "$CURRENT_SKILLS" | grep -qw "$fname"; then
    # Only delete if this file was previously deployed by dupla (has trigger: header)
    if grep -q "^trigger:" "$existing" 2>/dev/null; then
      rm -f "$existing"
    fi
  fi
done

# Deploy with trigger: agent_requested
for f in /tmp/dupla-new/skills/*.md; do
  fname=$(basename "$f")
  dest="$KNOWLEDGE_DIR/$fname"
  if ! grep -q "^trigger:" "$f" 2>/dev/null; then
    printf -- "---\ntrigger: agent_requested\n---\n\n" > "$dest"
    cat "$f" >> "$dest"
  else
    cp "$f" "$dest"
  fi
done
```

**global_workflows/ directory** (description: frontmatter):
```bash
WORKFLOWS_DIR=~/.gemini/antigravity/global_workflows
mkdir -p "$WORKFLOWS_DIR"

# Orphan cleanup — only remove files deployed by dupla (have description: frontmatter)
for existing in "$WORKFLOWS_DIR"/*.md; do
  [ -f "$existing" ] || continue
  fname=$(basename "$existing")
  if ! echo "$CURRENT_SKILLS" | grep -qw "$fname"; then
    if grep -q "^description:" "$existing" 2>/dev/null; then
      rm -f "$existing"
    fi
  fi
done

# Deploy with description: frontmatter
for f in /tmp/dupla-new/skills/*.md; do
  fname=$(basename "$f")
  desc=$(grep -m1 "^[^#]" "$f" 2>/dev/null | sed 's/^[[:space:]]*//' | cut -c1-200)
  printf -- "---\ndescription: %s\n---\n\n" "$desc" > "$WORKFLOWS_DIR/$fname"
  cat "$f" >> "$WORKFLOWS_DIR/$fname"
done

# Sync CLAUDE.md as always_on rule
if [ -f ~/.claude/CLAUDE.md ] && [ -s ~/.claude/CLAUDE.md ]; then
  printf -- "---\ntrigger: always_on\n---\n\n" > "$KNOWLEDGE_DIR/CLAUDE.md"
  cat ~/.claude/CLAUDE.md >> "$KNOWLEDGE_DIR/CLAUDE.md"
fi
```

**Legacy ~/.agent/ path (if detected):**
```bash
# Same deploy to ~/.agent/rules/ if exists
```

---

### Step 8 — Deploy Cursor (if detected)

```bash
mkdir -p ~/.cursor/commands
cp /tmp/dupla-new/skills/*.md ~/.cursor/commands/
```

---

### Step 9 — Cleanup

```bash
rm -rf /tmp/dupla-new
```

---

### Step 10 — Output

```
✅ Actualizado a v[NEW] (desde v[OLD])

Claude Code:   ~/.claude/skills/ ✓ [N skills] + hooks ✓ [N hooks]
Antigravity:   knowledge/ ✓ [N skills] · global_workflows/ ✓ [N skills]   [si detectado]
Cursor:        ~/.cursor/commands/ ✓ [N skills]                            [si detectado]

Backup anterior: ~/.claude/skills-backup/v[OLD]/

→ /health-check para verificar que todo está OK
```

---

## V1 Migration (DUPLA_VERSION missing)

Detected if `~/.claude/DUPLA_VERSION` does not exist.

Show:
```
⚠️ Dupla-Workflow v1 detectado.

Cambios en v2:
- commands/ → skills/
- CREDENCIALES.md → CREDENTIALS.md
- CONTEXTO_*.md + STACK_GLOBAL.md → CLAUDE.md + SYSTEM.md
- Nuevos skills: checkpoint, restore, adapt-to-team, add-team-member
- SESSION block en PROJECT_STATE

¿Migrar a v2? [s/n]
```

If YES → Claude runs:
```bash
mkdir -p ~/.claude/v1-backup
cp -r ~/.claude/commands ~/.claude/v1-backup/ 2>/dev/null || true
cp ~/.claude/CREDENCIALES.md ~/.claude/v1-backup/ 2>/dev/null || true
cp ~/.claude/CONTEXTO_*.md ~/.claude/v1-backup/ 2>/dev/null || true
cp ~/.claude/STACK_GLOBAL.md ~/.claude/v1-backup/ 2>/dev/null || true
rm -rf /tmp/dupla-new
git clone --depth 1 https://github.com/leo1z/dupla-workflow.git /tmp/dupla-new
bash /tmp/dupla-new/bin/install.sh
if [ -f ~/.claude/CREDENCIALES.md ] && [ ! -f ~/.claude/CREDENTIALS.md ]; then
  cp ~/.claude/CREDENCIALES.md ~/.claude/CREDENTIALS.md
fi
rm -rf /tmp/dupla-new
```

Then show:
```
✅ Migración v1 → v2 completada
Backup en: ~/.claude/v1-backup/

Siguiente:
1. /setup-dupla → regenera CLAUDE.md + SYSTEM.md con tu info actual
2. Por proyecto: /adapt-project → migra docs a formato v2
3. /health-check → verifica todo
```

---

## Rollback

If something breaks after update, Claude runs:
```bash
cp ~/.claude/skills-backup/v[OLD]/*.md ~/.claude/skills/
echo "v[OLD]" > ~/.claude/DUPLA_VERSION
```

---

## Rules

- **Claude executes all Bash commands directly** — never show copy-paste blocks to the user
- Always backup before any change
- Orphan cleanup: only delete files that have dupla frontmatter (`trigger:` or `description:`) AND are no longer in source — never delete user-created files
- Never delete v1 backup files
- After update: always run `/health-check` automatically or suggest it
- If git clone fails → abort with error, do not proceed
- If skill count after deploy is 0 → abort with error, restore from backup
