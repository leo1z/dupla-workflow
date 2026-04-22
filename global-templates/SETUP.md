# Setup Guide — Dupla-Workflow

> For: New machine setup or new collaborator onboarding
> Time: ~10 minutes

---

## Prerequisites

- [Claude Code](https://claude.ai/code) installed
- Git installed
- GitHub CLI (optional): https://cli.github.com/

> **Windows:** use Git Bash or WSL to run bash commands. In VS Code, set the integrated terminal to Git Bash first.

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

| Skill | When to use |
|---|---|
| `/new-session` | Start of every work session |
| `/checkpoint` | End of session (or mid-session to save) |
| `/new-project` | Initialize a new project with IML assessment |
| `/adapt-project` | Onboard an existing project |
| `/quick-start` | Lightweight session — no full project setup needed |
| `/health-check` | Verify system is working correctly |
| `/restore` | Revert to a previous save point |
| `/update-dupla` | Update system to latest version |

→ Full system map: [docs/SYSTEM_MAP.md](../docs/SYSTEM_MAP.md)
