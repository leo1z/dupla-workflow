Revert to a previous save point. Replaces /versions with human-readable checkpoints.

Usage: /restore

---

## Execution

1. Run: `git branch --show-current` → store as CURRENT_BRANCH
2. Run: `git log --oneline -20 --first-parent HEAD` → commits on current branch only
   - This prevents mixing in checkpoints from other team members' branches
3. Extract commits with "checkpoint:" or "handoff:" or commit messages from /checkpoint
4. Number them (5, 4, 3, 2, 1) with most recent = 5
5. For each commit, extract:
   - Time (from commit date)
   - Message summary (e.g., "Agrega validación de email")
6. Display menu:

```
Tus puntos de guardado — branch: [CURRENT_BRANCH] (más recientes primero):

  5 · hace 2h      → "Agrega validación de email"
  4 · hace 4h      → "Conecta Supabase auth"
  3 · ayer 3pm     → "Setup inicial completado"
  2 · ayer 10am    → "Configura ambiente"
  1 · hace 2 días  → "Proyecto creado"

⚠️ Solo muestra commits de este branch. Para ver otros branches usa: git log --all --oneline
¿A cuál quieres volver? (número) o Enter para cancelar:
```

6. If user enters number (e.g., 3):
   - Show what will be lost:
```
⚠️ Si vuelves al punto 3, PERDERÁS:
  • Cambios en [file1] (línea X)
  • 2 commits posteriores ([commit1], [commit2])
  • [X líneas de código]

No se puede deshacer. ¿Confirmar? (escribe CONFIRMAR)
```

7. Wait for exact text "CONFIRMAR"
8. Create safety branch:
   ```
   git checkout -b backup/restore-YYYY-MM-DD-HH-MM
   git checkout [target-commit-hash]
   ```
9. Output (5 lines):
```
✅ Restaurado al punto 3

Rama de seguridad: backup/restore-2026-04-20-14-30
Commits perdidos: [commit1], [commit2]

Para volver al presente: git checkout [original-branch]
```

---

## Rules

- Save points numbered 1–5 (ascending = older, descending = newer)
- Times shown in human format ("hace 2h", "ayer 3pm", "hace 2 días")
- Require exact "CONFIRMAR" before reverting (no other variations)
- Always create backup branch with timestamp
- Never force destructive operation without explicit multi-step confirmation
- If restoring to commit 3+ hours old, add: "⚠️ Recuerda actualizar docs/PROJECT_STATE.md después de restaurar"
