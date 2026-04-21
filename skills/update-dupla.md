Update Dupla-Workflow system to latest version. Downloads from GitHub with auto-backup.

Usage: /update-dupla

---

## Execution

1. Read `~/.claude/DUPLA_VERSION` → extract current version
2. Read `$DUPLA_REPO/VERSION` (from GitHub) → extract latest version
3. Compare versions:
   - If equal → "✅ Ya estás en la última versión (v[X.Y.Z])"
   - If local > remote → "⚠️ Tu versión es más reciente que la disponible"
   - If local < remote → proceed

4. Show CHANGELOG from GitHub for new version:
   - Extract section for target version
   - Display (max 30 lines)
   - Ask: "¿Actualizar a v[X.Y.Z]? [s/n]"

5. If yes:
   - **Backup current skills:**
     ```
     mkdir -p ~/.claude/skills-backup/v[old-version]
     cp ~/.claude/skills/*.md ~/.claude/skills-backup/v[old-version]/
     ```
   - **Download new skills:**
     ```
     git clone --depth 1 https://github.com/leo1z/dupla-workflow.git /tmp/dupla-new
     cp /tmp/dupla-new/skills/*.md ~/.claude/skills/
     ```
   - **Update version marker:**
     ```
     echo "v[new-version]" > ~/.claude/DUPLA_VERSION
     ```
   - **Detect IDE and sync:**
     - If ~/.agent/ exists → cp ~/.claude/skills/*.md ~/.agent/skills/
   - **Cleanup:**
     ```
     rm -rf /tmp/dupla-new
     ```

6. Output (8 lines):
```
✅ Actualizado a v[X.Y.Z]

**Cambios principales:**
- [feature 1]
- [feature 2]

**Backup anterior:** ~/.claude/skills-backup/v[old-version]/
**Próximo paso:** /health-check para verificar

⚠️ Si hay problemas: restaura desde el backup
```

---

## Rollback

If user needs to rollback after update:
```
cp ~/.claude/skills-backup/v[old-version]/*.md ~/.claude/skills/
echo "v[old-version]" > ~/.claude/DUPLA_VERSION
echo "✅ Revertido a v[old-version]"
```

---

## Rules

- Always backup before updating (never overwrite live skills)
- Detect Antigravity and sync both IDEs automatically
- Show CHANGELOG before asking for approval
- Rollback is trivial (just restore from timestamped backup)
- Check ~/.claude/settings.json for hook conflicts after update
