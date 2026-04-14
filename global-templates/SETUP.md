# Setup Guide — Dupla Workflow

> For: New machine setup or new collaborator onboarding
> Time: ~15 minutes

---

## What this repo is

A structured development workflow system for Claude Code.
All commands, templates, and guides to develop projects consistently.

---

## Prerequisites

- Claude Code installed: https://claude.ai/code
- Git installed
- GitHub CLI: https://cli.github.com/

---

## Step 1 — Clone the repo

```bash
git clone https://github.com/leo1z/dupla-workflow "C:/Users/YOUR_USER/Projects/dupla-workflow"
```

---

## Step 2 — Install commands (skills)

```bash
bash "C:/Users/YOUR_USER/Projects/dupla-workflow/instalar.sh"
```

This copies all commands to ~/.claude/commands/

---

## Step 3 — Create global config files in ~/.claude/

Copy and fill each template from global-templates/:

| Template | Destination | Notes |
|---|---|---|
| CLAUDE_GLOBAL_TEMPLATE.md | ~/.claude/CLAUDE.md | Behavior config — edit to your preferences |
| STACK_GLOBAL_TEMPLATE.md | ~/.claude/STACK_GLOBAL.md | Your tech stack |
| PROBLEMS_GLOBAL_TEMPLATE.md | ~/.claude/PROBLEMS_GLOBAL.md | Start empty |
| PROJECTS_SKILLS_TEMPLATE.md | ~/.claude/PROJECTS_SKILLS.md | Your projects + skills |
| CONTEXTO_USER_TEMPLATE.md | ~/.claude/CONTEXTO_[YOUR_NAME].md | Who you are |
| CREDENTIALS_TEMPLATE.md → | ~/.claude/CREDENCIALES.md | Your credentials (NEVER commit) |

---

## Step 4 — Verify

In Claude Code, run:
```
/health-check
```

---

## Daily workflow

See: docs/New_Project_Guide.md and templates/GUIA_COLABORADOR.md
