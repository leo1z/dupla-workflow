---
trigger: always_on
---

# Dupla-Workflow — Project Rules for Gemini

## What this project is
AI workflow framework for Claude Code + Antigravity (Gemini). Provides slash commands (skills/workflows), session state management, and document templates.

## Session start
- Read `docs/PROJECT_STATE.md` → `<session>` block first (~60 tokens)
- Load `docs/ROADMAP.md` only if planning
- Load `docs/ARCHITECTURE.md` only if building
- Load `docs/PROBLEMS.md` only if debugging

## Key files
- `skills/*.md` → workflow prompt programs (deployed to ~/.gemini/antigravity/global_workflows/)
- `bin/install.sh` → deploys everything (high risk — affects all users)
- `docs/PROJECT_STATE.md` → session state source of truth

## Rules
- Never commit to main directly
- Changes to `bin/install.sh` are high risk
- Test skill changes by reading the file, not running installs
- Commit prefix: feat / fix / chore / docs
