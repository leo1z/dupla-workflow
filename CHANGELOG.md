# Changelog — Dupla-Workflow

## [2.4.0] — 2026-04-22

### New Features — Antigravity (Gemini) Full Support
- **Global workflows** — Skills deployed to `~/.gemini/antigravity/global_workflows/` as Antigravity Workflows. Type `/skill-name` in Agent to trigger.
- **GEMINI.md** — `install.sh` now syncs `~/.claude/CLAUDE.md` → `~/.gemini/GEMINI.md` (global Gemini identity, equivalent to CLAUDE.md for Claude Code)
- **Project rules** — `/adapt-project` now creates `.agents/rules/claude.md` per project (`trigger: always_on`). Gemini reads project context automatically at session start.
- **Shared state** — `docs/PROJECT_STATE.md` is the same file for both Claude and Gemini. No duplication — both models read from the same source of truth.
- **Per-project update** — `/update-dupla` now asks which projects to update `.agents/rules/` for Gemini.

### Fixed
- **`install.sh`** — Antigravity detection now finds `~/.gemini/antigravity/` (confirmed Windows path). Previous path `~/.agent/` was incorrect.
- **`install.sh`** — If Antigravity binary exists but config dir not found: shows `find` command + `ANTIGRAVITY_DIR=<path>` override.
- **`health-check.md`** — Checks updated to use `~/.gemini/antigravity/global_workflows/` and `~/.gemini/GEMINI.md` instead of old `~/.agent/` paths.
- **`setup-dupla.md`** — Detection and sync updated to correct Antigravity paths.
- **`update-dupla.md`** — Update commands corrected to deploy to `~/.gemini/antigravity/global_workflows/`.
- **`SYSTEM_MAP.md`** — Added Antigravity document layer diagram and token cost table alongside Claude Code.

---

## [2.3.1] — 2026-04-22

### Fixed (16 gaps from audit)
- **GAP-01** `session-reminder.sh` — cross-platform date parsing: Linux → macOS → Python3 fallback (Windows Git Bash now works)
- **GAP-02** `session-reminder.sh` + `suggest-checkpoint.sh` — session markers/counters moved from `.tmp/` (cleared by `git clean`) to system temp dir keyed by project path
- **GAP-03** `README.md` — documents slash command registration in Claude Code, adds troubleshooting note + workaround
- **GAP-04** `CLAUDE_GLOBAL_TEMPLATE.md` — `/update-context` (non-existent) replaced with `/adapt-project`
- **GAP-05** `token-budget.md` — `/progress` (renamed in v2.0) replaced with `/checkpoint close`
- **GAP-06** `new-session.md` — when `Phase: N/A` but `docs/ROADMAP.md` exists, offers to activate phase tracking instead of ignoring it
- **GAP-07** `restore.md` — save points now filtered by current branch (`--first-parent HEAD`); shows branch name in menu header
- **GAP-08** `quick-start.md` — adds `/quick-start save` and `/quick-start close` as explicit aliases that trigger Step 5 immediately
- **GAP-09** `checkpoint.md` Mode 4 — `approve-pr` now verifies dev SESSION was updated before merge; warns Lead if dev skipped `/checkpoint`
- **GAP-10** `health-check.md` — skills count updated from hardcoded `12/12` to `13/13`; core skills list made explicit
- **GAP-11** `adapt-project.md` — when `docs/ROADMAP.md` exists, shows preview and asks what to do instead of overwriting with placeholder
- **GAP-12** `new-session.md` — adds `/new-session standup` mode for Lead: consolidated table of all devs (Done/Next/Blocked) in ≤15 lines
- **GAP-13** `README.md` — version header updated from v2.2.0 to v2.3.0
- **GAP-14** `setup-dupla.md` — Antigravity detection now includes Windows path (`$USERPROFILE/.agent/`) with manual path fallback
- **GAP-15** `new-project.md` — Phase 4 research adds sequential fallback for IDEs without subagent support
- **GAP-16** `setup-dupla.md` — setup output now mentions `CREDENTIALS_TEMPLATE.md`; skills count corrected (14→13)

---

## [2.3.0] — 2026-04-22

### New Features
- **Micro mode** — `/quick-start` for small projects and casual sessions. Creates `QUICKSTATE.md` in any folder. No `docs/`, no git branches, no roadmap required.
- **System Map** — `docs/SYSTEM_MAP.md`: Mermaid diagram + token cost table showing how all documents connect and what loads when.
- **Roadmap phase awareness** — `/new-session` always reads the current phase section from ROADMAP.md (~100 tokens), shows phase status and GO/NO-GO criteria at session start.
- **ROADMAP auto-sync** — `/checkpoint close` compares git commits vs phase Outcomes and marks them `[x]` automatically. Flags `GO/NO-GO Pending` when criteria are met.
- **Missed checkpoint recovery** — If user skips `/checkpoint`, `/new-session` detects commits newer than SESSION.Updated and runs ROADMAP sync inline.
- **Handoff persistence** — `/checkpoint handoff` writes `<handoff>` block to PROJECT_STATE.md so next model reads it via `/new-session` even if chat closes.

### Fixed
- **install.sh** — No longer overwrites existing `.claudeignore` (was destroying user's custom ignore file)
- **suggest-checkpoint.sh** — Throttled to every 3 stops + only speaks when meaningful (was injecting ~150 tokens of noise on every response)
- **session-reminder.sh** — Fires once per session via `.tmp/` marker (was firing on every user message)
- **checkpoint close** — Architecture sync and Problems detection are now signal-based (reads git diff / commit messages) — no longer asks questions by default in every session
- **global-templates/SETUP.md** — Completely rewritten to reflect current install flow (`bin/install.sh` → `/setup-dupla`)

### Removed from repo (privacy + cleanliness)
- `.claude/settings.local.json` — contained personal paths and permissions (untracked, stays local)
- `docs/dupla-workflow.json` — orphan visualization file with hardcoded personal name

### Updated
- **SESSION block template** — Added `Phase` and `Phase_Status` fields
- **new-session** — Keyword detection for conditional doc loading (planning/building/debugging signals)
- **new-session** — Team flow reads Phase from Shared Status
- **checkpoint** — Steps renumbered; ROADMAP and Architecture sync added as 2.5/2.6/2.7
- **health-check** — Added `quick-start` to core skills; added Phase field verification
- **.claudeignore** — Excludes `docs/code-review-graph.json` and `QUICKSTART.html` from Claude context
- **.gitignore** — Explicit rules for `.claude/*.local.json`

---

## [2.2.0] — 2026-04-21

### New Features
- **Team mode** — Individual vs Team detection, per-dev sections, concurrent work without conflicts
- **approve-pr** — Lead reviews + merges branch vs ROADMAP, auto-detects GO/NO-GO per phase
- **adapt-to-team** — Convert individual project → team without redoing setup
- **add-team-member** — Add devs or change roles mid-project
- **health-check** — Full system verification (skills, hooks, project docs, team, stack coherence)
- **project-audit** — Pre-compiled dependency graph for low-token impact analysis
- **token-budget** — Session cost monitor

### Fixed
- **install.sh** — Now deploys hooks to `~/.claude/hooks/` and registers in `settings.json`
- **session-reminder.sh** — Cross-platform date parsing (macOS + Linux)
- **adapt-to-team.sh** — Cross-platform date for branch naming (Windows compatible)
- **new-session** — Detects first session (placeholder SESSION), reads `<handoff>` block, partial name matching for team
- **adapt-project** — Always sets `project_type: individual` + fills SESSION with real values
- **new-project** — `git push --all` + GitHub collaborator invite instructions for team setup
- **checkpoint approve-pr** — Infers dev/phase from branch name, auto-detects last branch of phase (GO/NO-GO), shows which devs get unblocked
- **health-check** — Verifies hooks in settings.json, custom skills flagged as INFO not WARNING
- **update-dupla** — User-run bash instructions (Claude can't execute), custom hooks warning in v1 migration
- **suggest-checkpoint** — Detects many modified files without commits (long sessions without git activity)

### Added
- Team day-1 onboarding guide in `/new-session`
- Branch fallback from ROADMAP phase when not defined in CLAUDE.md
- Windows install note in README (Git Bash / WSL required)

---

## [2.0.0] — 2026-04-20

### Major Changes
- **Architecture redesign**: Plugin system → GitHub repo + multi-IDE deployment
- **Commands overhaul**: Consolidated from 8→7 core commands with unified interface
- **Template system**: Redefined with YAML headers, SESSION blocks at document start
- **Model switching**: Added automated recommendations for Claude vs Gemini routing
- **Save point system**: Numbered human-readable checkpoints replace git hashes
- **Multi-IDE support**: Same codebase deploys to Claude Code, Antigravity, OpenCode

### New Features
- `/checkpoint` — Unified command (3 modes: quick save, full close, handoff)
- `/restore` — Human-readable save points with preview of lost changes
- `/update-dupla` — System self-update with backup before changes
- Patrón Estándar — Interview pattern (questions → process → clarity check)
- IML Assessment — Idea maturity validation across all project types
- Parallel research subagents — Competitive analysis + market sizing
- Archive mechanism — Preserves legacy data during adoption
- MCP filesystem server — Optional for technical projects
- Hooks system — Guard PROJECT_STATE writes, remind checkpoints, session staleness

### Breaking Changes
- `commands/` → `skills/` (file structure rename)
- `/progress` → `/checkpoint` (command renamed)
- `/versions` → `/restore` (command renamed + UX overhaul)
- `/adopt` → `/adapt-project` (more accurately named)
- `/setup` → `/setup-dupla` (more specific for this workflow)
- PROJECT_STATE.md: SESSION moved to top, `## Status` removed, YAML header added
- CLAUDE.md: Merged CONTEXTO + MODEL_ROUTING into single file
- SYSTEM.md: Fused STACK_GLOBAL + PROJECTS_SKILLS (new)

### Fixed
- CREDENCIALES → CREDENTIALS naming in health-check
- Removed plaintext credentials from settings.local.json
- Removed unregistered plugin (frontend-slides) from PROJECTS_SKILLS
- Absolute paths for template resolution in setup + adopt

### Removed
- `/adopt` (replaced by `/adapt-project`)
- CONTEXTO_[name].md as separate file (merged into CLAUDE.md)
- STACK_GLOBAL.md as separate file (merged into SYSTEM.md)
- Multiple context files (7 → 3 global files)

---

## [1.0.0] — 2025-Q4

Initial dupla-workflow system with plugin-based Claude Code integration, 8 core skills, context management, project adoption, and health checks.
