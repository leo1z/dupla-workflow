First-time Dupla-Workflow setup. Generates ~/.claude/ global configuration via interview.

Usage: /setup-dupla

---

## Pre-Check

Check ~/.claude/ for existing files:
- CLAUDE.md
- SYSTEM.md
- PROBLEMS_GLOBAL.md

For each that exists → ask: "Found [file]. Overwrite? [s/n]" → skip if "n"

Detect IDEs:
- ~/.claude/ exists? → Claude Code
- ~/.agent/ exists? → Antigravity detected (will sync CLAUDE.md later)

---

## Phase 1 — Interview (Patrón Estándar)

Ask ALL questions in ONE message, grouped into blocks:

### Block 1 — Identity
1. What's your name?
2. What's your role? (founder, developer, designer, etc.)
3. How do you work best? (e.g., "design first then execute")
4. What drives you? (what problems excite you?)

### Block 2 — Tech Stack
5. Main stack for web/SaaS projects?
6. Services you use? (Supabase, Vercel, VPS, N8N, Evolution API, etc.)
7. Alternate stacks for scripts/APIs/other?
8. VPS IP, URLs, or special infra details?

### Block 3 — Active Projects
9. List active projects: [name], [what it does], [GitHub repo], [current phase]

### Block 4 — Plugins & Tools
10. Installed Claude plugins? (ui-ux-pro-max, etc.)

**Wait for ALL answers before proceeding.**

---

## Phase 2 — Processing (silent)

Classify answers:
- Tech: web, CLI, data, hybrid?
- User style: theory-first or execution-first?
- Constraints: time-bound projects? Fixed team?

---

## Phase 3 — Clarity Check (binary validation)

Show summary:
```
## Setup Summary

**Name:** [name]
**Role:** [role]
**Main stack:** [tech]
**Projects:** [count]
**IDE:** Claude Code [+ Antigravity detected]

¿Todo correcto? [s/n]
```

If NO → ask: "¿Qué cambiar?"
If YES → proceed to generation

---

## Phase 4 — Generate Files

### 1. ~/.claude/CLAUDE.md
- Use CLAUDE_GLOBAL_TEMPLATE.md as base
- Personalize Identity section with Block 1 answers
- Keep Execution Rules + Work Model intact
- Update Work Model commands: /progress → /checkpoint, /restore

### 2. ~/.claude/SYSTEM.md
- Use SYSTEM_TEMPLATE.md as base
- Fill Tech Stack from Block 2
- Add services table
- Add VPS details if provided
- Add projects table from Block 3
- Add plugins from Block 4

### 3. ~/.claude/PROBLEMS_GLOBAL.md
- Create empty template (user populates as issues arise)

### Optional: ~/.agent/CLAUDE.md
- If Antigravity detected: copy ~/.claude/CLAUDE.md to ~/.agent/CLAUDE.md
- Same copy to ~/.agent/skills/ if they exist

### Optional: ~/.claude/.mcp.json
- If user selected "technical stack": ask "Enable MCP filesystem access? [s/n]"
- Generate .mcp.json for project-level MCP server setup
- Requires Node.js installed

### 4. Install Dupla Infrastructure
- Execute: `bash ~/Projects/dupla-workflow/bin/install.sh` (or detect dupla-workflow location)
- Copies hooks to ~/.claude/hooks/
- Configures hooks in settings.json
- Creates DUPLA_VERSION marker

---

## Phase 5 — Output (max 12 lines)

```
✅ Setup Complete — [name]

**Files created:**
- ~/.claude/CLAUDE.md (behavior + identity)
- ~/.claude/SYSTEM.md (stack + projects)
- ~/.claude/PROBLEMS_GLOBAL.md (empty, ready)

**Infrastructure installed:**
- ✓ Skills deployed (14 v2 commands)
- ✓ Hooks configured (guard-project-state, suggest-checkpoint, session-reminder)
- ✓ DUPLA_VERSION 2.0.0

**Next:** /health-check to verify
```

---

## Merge Mode (if files exist)

If user says "overwrite" to existing files:
1. Read existing file
2. Show diff summary: "These sections would change:"
3. Ask approval section-by-section (Identity, Stack, etc.)
4. Merge: keep approved sections, replace rest
5. Always preserve: Project entries (never delete projects)

---

## Rules

- Ask all questions ONCE in grouped blocks
- Do NOT generate until all answers received
- Do NOT overwrite without approval
- Preserve existing project entries when merging
- If MCP question skipped → don't create .mcp.json
- If user skips question → mark as [pending] in output files
