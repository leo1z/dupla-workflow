# Changelog — Dupla-Workflow

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
