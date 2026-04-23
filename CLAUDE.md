# Dupla-Workflow — Project Context

## What this is

AI workflow framework for Claude Code + Antigravity (Gemini). Provides slash commands (skills), session state management, and document templates that save tokens and reduce cognitive load across projects.

## Stack

- **Skills:** `.md` files in `skills/` — slash commands in Claude Code · Workflows in Antigravity (type `/skill-name` in Agent)
- **Hooks:** shell scripts in `hooks/` — automations running outside context window
- **Templates:** `.md` files in `templates/` — used by skills to generate project docs
- **Install:** `bin/install.sh` — deploys to:
  - Claude Code: `~/.claude/skills/` + `~/.claude/commands/`
  - Antigravity: `~/.gemini/antigravity/global_workflows/` (Workflows) + `~/.gemini/GEMINI.md` (identity)
  - Per-project: `.agents/rules/claude.md` via `/adapt-project`
- **Version:** read from `VERSION` file

## Key Files

- `skills/new-session.md` — reads PROJECT_STATE + phase, generates session plan
- `skills/checkpoint.md` — saves state, syncs ROADMAP, handles handoff
- `skills/new-project.md` — IML assessment + full doc generation
- `bin/install.sh` — installation entry point (risky — affects all users)
- `docs/PROJECT_STATE.md` — current session state (read `<session>` block first)
- `CHANGELOG.md` — version history
- `VERSION` — current version string

## Rules

- Never force push to master
- Changes to `bin/install.sh` are high risk — affects setup for all users
- Changes to `skills/new-session.md` or `skills/checkpoint.md` are medium risk — core session flow
- Test skill changes by reading the skill file, not by running installs
- `docs/code-review-graph.json` is auto-generated — don't edit manually

## How Skills Work

Skills are `.md` files that Claude reads when you invoke `/skill-name`. They are prompt programs — instructions Claude follows. Zero token cost until invoked. Installed to `~/.claude/skills/` by `bin/install.sh`.

## Current Version

See `VERSION` file. Changelog in `CHANGELOG.md`.
