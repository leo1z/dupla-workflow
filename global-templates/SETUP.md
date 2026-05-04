# Setup Guide — Dupla-Workflow

> For: New machine setup or new collaborator onboarding
> Time: ~10 minutes

---

## Prerequisites

- [Claude Code](https://claude.ai/code) installed (or Antigravity / Claude Desktop)
- Git installed
- GitHub CLI (optional): https://cli.github.com/

> **macOS / Linux:** Terminal nativo — funciona directo.
> **Windows:** Usa Git Bash (no PowerShell). En VS Code: terminal → ∨ → Git Bash.

---

## Step 1 — Clone and install

```bash
git clone https://github.com/leo1z/dupla-workflow
cd dupla-workflow
bash bin/install.sh
```

This deploys skills, hooks, and registers hooks in `~/.claude/settings.json`.

---

## Step 2 — Configure (one-time, in Claude Code)

```
/setup-dupla
```

Asks who you are, your stack, and your active projects.
Generates `~/.claude/CLAUDE.md`, `~/.claude/SYSTEM.md`, `~/.claude/PROBLEMS_GLOBAL.md`.

---

## Step 3 — Verify

```
/health-check
```

---

## Step 4 — Start working

**New project:**
```
/new-project
```

**Existing project:**
```
/adapt-project
```

**Small task / casual session (no project needed):**
```
/quick-start
```

---

## Daily workflow

```
/new-session     → reads state, tells you where you are and what to do
[work]
/checkpoint      → saves state, updates roadmap, closes session
```

---

## Reference

| Skill | Cuando usar |
|---|---|
| `/new-session` | Inicio de cada sesión |
| `/new-session standup` | Lead del equipo — vista consolidada del equipo |
| `/checkpoint` | Fin de sesión (o mid-sesión para guardar) |
| `/checkpoint close` | Cierre explícito |
| `/checkpoint handoff` | Cambiar de modelo (Claude ↔ Gemini) |
| `/new-project` | Proyecto nuevo con assessment IML |
| `/adapt-project` | Onboarding de proyecto existente |
| `/quick-start` | Sesión ligera — sin estructura de proyecto |
| `/quick-start save` | Guardar y cerrar sesión micro explícitamente |
| `/health-check` | Verificar que el sistema esté OK |
| `/restore` | Revertir a un save point anterior |
| `/update-dupla` | Actualizar a la última versión |

→ [Cómo funciona, instalar y usar](../docs/HOW_IT_WORKS.md)
