First-time Dupla-Workflow setup. Generates ~/.claude/ global configuration via interview.

Usage: /setup-dupla

---

## Phase 0 — Detect Environment (silent, before any question)

### 0A — Tool availability
Check silently what is installed:
- `git --version` → available? (required)
- `python3 --version` → available? (required for Windows hooks)
- `node --version` → available? (optional — MCP filesystem)
- `pip3 --version` or `pip --version` → available? (optional — MCP Fetch)

If git missing → stop: "❌ git no encontrado. Instálalo primero: https://git-scm.com"
If python3 missing AND running on Windows (detected via USERPROFILE env or OS hints):
  → STOP: "❌ python3 no encontrado. Los hooks de Dupla requieren python3 en Windows.
     Instalar: https://python.org/downloads (marca 'Add to PATH')
     Luego cierra y vuelve a abrir la terminal, y corre /setup-dupla de nuevo."
If python3 missing AND on macOS/Linux:
  → WARN (don't stop): "⚠️ python3 no encontrado — algunos hooks usarán fallbacks. Recomendado: brew install python3"

### 0B — Detect IDEs and surface
- `~/.claude/` exists? → Claude Code detected → **full hooks + skills available**
- `~/.gemini/antigravity/` or `~/.agent/` exists? → Antigravity detected → **skills as workflows, no hooks**
- `~/.cursor/` exists? → Cursor detected → **skills as slash commands in .cursor/commands/, no hooks**
- `.windsurfrules` or `~/.windsurf/` exists? → Windsurf detected → **passive rules only, no hooks**
- None found → ask: "¿Desde qué IDE o terminal usas esto? (Claude Code / Antigravity / Cursor / Windsurf / otro)"

Show detected surface at setup end so user understands what's available.

If Antigravity detected → show this warning ONCE at the end of setup:
```
⚠️ Nota Antigravity: los skills NO son slash commands en Gemini.
   Para invocar un skill, escribe su nombre como texto:
   ✅ "Ejecuta new-session" o "Haz el skill new-session"
   ❌ /new-session  ← no funciona en Antigravity como slash command

   Sin hooks: no hay auto-snapshot, suggest-checkpoint ni guard.
   Antes de cerrar Antigravity, corre en terminal:
   git add . && git commit -m "checkpoint: [descripción]"
```

If Antigravity NOT detected but user says they have it:
  `"¿Dónde está instalado Antigravity? (ej: ~/.gemini/antigravity/)"`
  Then set: ANTIGRAVITY_DIR=<path> bash bin/install.sh

If Cursor detected → install.sh will auto-deploy to `~/.cursor/commands/` during Phase 4.

### 0C — Detect existing config
Check ~/.claude/ for existing files:
- CLAUDE.md? → "Found CLAUDE.md. Update with new answers or keep current? [update/keep]"
- SYSTEM.md? → "Found SYSTEM.md. Merge new projects or replace? [merge/replace]"
- MEMORY_GLOBAL.md? → "Keep existing learnings? [y/n]"
- PROBLEMS_GLOBAL.md? (legacy) → "Found legacy PROBLEMS_GLOBAL.md. Migrate to MEMORY_GLOBAL.md? [s/n]"

Also check ~/Projects/ or ~/projects/ for existing projects with docs/:
- If found: "Detected X projects. Include in SYSTEM.md registry? [y/n]"

### 0D — Work mode (before interview)
Ask ONE question:
```
¿Cómo usarás Dupla principalmente?
  1 — Full (proyectos completos: código, docs, roadmap)
  2 — Research (investigación, análisis, síntesis — sin construir)
  3 — Lite (sesiones rápidas, sin docs completos)
```
Store selection → default `Mode` field in templates generated later.

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

## Phase 3.5 — MEMORY_GLOBAL seed (after clarity check, before generation)

Ask ONE question only if this is a first-time setup (MEMORY_GLOBAL.md doesn't exist):
```
¿Has tenido problemas recurrentes con tus proyectos de código o con algún LLM antes?
(Opcional — si sí, dime los 1-2 más frecuentes. Los guardo en tu memoria global para que no se repitan.)
[respuesta libre / saltar]
```

If user provides content → add to MEMORY_GLOBAL.md `## Problemas Recurrentes` section during generation.
If user skips → create empty MEMORY_GLOBAL.md with template structure. Never block on this question.

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

### 3. ~/.claude/MEMORY_GLOBAL.md
- Use MEMORY_GLOBAL_TEMPLATE.md as base
- Empty sections (user populates as patterns emerge)
- Note: replaces PROBLEMS_GLOBAL.md (legacy)

### Antigravity setup (if detected)
- `~/.gemini/GEMINI.md` ← copy of ~/.claude/CLAUDE.md (global Gemini identity)
- `~/.gemini/antigravity/global_workflows/` ← skills deployed as workflows (type /skill-name in Agent)
- Per-project: `/adapt-project` creates `.agents/rules/claude.md` automatically

### Optional: MCP Servers
Ask only if user is in "Full" or "Research" mode and Claude Code was detected:

**MCP Filesystem** (read project files automatically):
- "¿Activar lectura automática de archivos del proyecto? [s/n]"
- Requires Node.js → if missing: "node no encontrado — instalar en nodejs.org primero"
- Does NOT work in Antigravity

**MCP Fetch** (internet access for research):
- "¿Activar acceso a internet para research? [s/n]"
- Requires pip: `pip install mcp-server-fetch` (no Node.js needed)
- Works in Claude Code IDE/CLI · Confirm before installing

**Other IDEs (Cursor / Windsurf)**:
- If user mentions Cursor/Windsurf → show: "Copia skills relevantes a `.cursor/rules/` o `.windsurf/rules/`. Los docs del proyecto (.md) son universales — funcionan en cualquier IDE."

If YES → generate based on IDE detected:

**Claude Desktop** (`~/Library/Application Support/Claude/claude_desktop_config.json` on Mac,
`%APPDATA%\Claude\claude_desktop_config.json` on Windows):
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/[name]/Projects"]
    }
  }
}
```

**VS Code + Claude Code** (`.mcp.json` in project root):
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "."]
    }
  }
}
```

**What MCP enables:** Claude reads project files automatically at session start — no need to use Read tool manually. SESSION block still used for efficiency (MCP doesn't replace it).

**Without MCP:** System works fine — Claude uses Read tool on demand. MCP is a convenience improvement, not required.

### 4. Install Dupla Infrastructure

Detect dupla-workflow repo path in this order:
1. `~/.claude/DUPLA_VERSION` exists → repo was already installed, path in `~/.claude/hooks/` (skip clone)
2. `~/Projects/dupla-workflow/bin/install.sh` exists → use that path
3. `~/projects/dupla-workflow/bin/install.sh` exists → use that path
4. None found → ask user: "¿Dónde clonaste dupla-workflow? (ej: ~/code/dupla-workflow)"

Then run:
```bash
bash [detected-path]/bin/install.sh
```

- Copies hooks to ~/.claude/hooks/
- Configures hooks in settings.json
- Creates DUPLA_VERSION marker

If install.sh not found and user doesn't know the path:
```
❌ No encontré dupla-workflow. Clónalo primero:
   git clone https://github.com/leo1z/dupla-workflow.git ~/Projects/dupla-workflow
   Luego vuelve a correr /setup-dupla
```

---

## Phase 5 — Output (max 15 lines)

```
✅ Setup Complete — [name] · Modo: [Full / Research / Lite]

**Files created:**
- ~/.claude/CLAUDE.md (behavior + identity + roles + frameworks)
- ~/.claude/SYSTEM.md (stack + projects)
- ~/.claude/MEMORY_GLOBAL.md (cross-project patterns — empty, ready)

**Infrastructure installed:**
- ✓ Claude Code skills (14 commands in ~/.claude/skills/)
- ✓ Antigravity workflows (14 in ~/.gemini/antigravity/global_workflows/) [if detected]
- ✓ ~/.gemini/GEMINI.md synced [if detected]
- ✓ Hooks: guard-project-state · suggest-checkpoint · session-reminder · auto-snapshot · sync-gemini
- ✓ DUPLA_VERSION [from VERSION file]

**Tu superficie activa:**
  [Claude Code IDE/CLI] → Skills (/cmd) + Hooks automáticos + MCP opcional ← capacidad completa
  [Antigravity/Gemini]  → Skills (nombre del skill) · Sin hooks · run_command disponible
  [Cursor]              → Skills (/cmd en Agent Mode) · Sin hooks · Sin MCP
  [Windsurf]            → Reglas pasivas (@workflow) · Sin hooks
  [Chat/Web]            → Pegar <handoff> block + PROJECT_STATE adjunto

→ Ver docs/SURFACE_GUIDE.md para tabla completa de capacidades por entorno

ℹ️ Para credenciales seguras: crea ~/.claude/CREDENTIALS.md

**Next:** /health-check → luego /new-project o /adapt-project
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
