Verify system coherence and detect issues. Run anytime something feels off.

Usage: /health-check

---

## Execution

Run ALL checks silently. Output only warnings and errors, plus a summary.

---

## Check 0 — Tool Availability

Verify required tools are installed. If missing → show install instruction, not just the error.

```bash
# git
git --version → ✅ git [version] / ❌ NOT FOUND → install: https://git-scm.com

# python3 (required for Windows-compatible hooks)
python3 --version → ✅ Python [version] / ⚠️ NOT FOUND
  → Windows: winget install Python.Python.3 OR https://python.org/downloads
  → macOS:   brew install python3
  → Linux:   sudo apt install python3

# node (required for MCP filesystem server — optional)
node --version → ✅ Node [version] / ℹ️ NOT FOUND (optional — needed only for MCP)
  → Install: https://nodejs.org

# Active hooks in settings.json
~/.claude/settings.json → check hook types registered:
  Stop hooks:              [list commands] / ⚠️ none registered
  PreToolUse hooks:        [list matchers] / ⚠️ none registered
  UserPromptSubmit hooks:  [list commands] / ⚠️ none registered
  PostToolUse hooks:       [list matchers] / ℹ️ none (sync-gemini needs this)

# MCP servers configured (optional)
~/.claude/settings.json or .mcp.json → mcpServers present?
  → ✅ [list servers] / ℹ️ Not configured (optional — run /setup-dupla to enable)
```

---

## Check 1 — Global System

```bash
# Files exist?
~/.claude/CLAUDE.md          → ✅ / ❌ MISSING (run /setup-dupla)
~/.claude/SYSTEM.md          → ✅ / ❌ MISSING (run /setup-dupla)
~/.claude/MEMORY_GLOBAL.md   → ✅ / ⚠️ MISSING (run /setup-dupla — needed for cross-project learning)
~/.claude/DUPLA_VERSION      → ✅ v[X.Y.Z] / ❌ MISSING (run install.sh)

# CLAUDE.md has real content (not empty placeholder)?
grep -c "." ~/.claude/CLAUDE.md → > 10 lines: ✅ / ≤ 10 lines: ⚠️ Placeholder — run /setup-dupla

# GEMINI.md sync check (if ~/.gemini/ exists)
if ~/.gemini/ exists:
  ~/.gemini/GEMINI.md → ✅ exists / ⚠️ MISSING (run: cp ~/.claude/CLAUDE.md ~/.gemini/GEMINI.md)
  diff ~/.claude/CLAUDE.md ~/.gemini/GEMINI.md → identical: ✅ / differs: ⚠️ Out of sync (run sync manually or via /setup-dupla)

# Skills installed?
~/.claude/skills/ → list .md files → check that CORE skills are present:
  new-project, new-session, checkpoint, restore, setup-dupla,
  update-dupla, adapt-project, adapt-to-team, add-team-member,
  health-check, knowledge-graph, quick-start, check-project, compact, research
  → ✅ core skills present / ⚠️ missing: [list only missing core ones]
  → Extra .md files not in core list → ℹ️ Custom skills found: [list] (not an error)

# CLAUDE.md has required fields?
grep "Name:" ~/.claude/CLAUDE.md    → ✅ / ⚠️ empty
grep "Stack" ~/.claude/SYSTEM.md    → ✅ / ⚠️ empty

# Antigravity: if ~/.gemini/antigravity/ exists
~/.gemini/GEMINI.md → ✅ exists / ⚠️ MISSING (run install.sh)
~/.gemini/antigravity/global_workflows/ → workflows present? → ✅ / ⚠️ out of sync (run install.sh)
.agents/rules/claude.md (project) → ✅ exists / ⚠️ MISSING (run /adapt-project)

# Hooks installed?
~/.claude/hooks/guard-project-state.sh  → ✅ / ⚠️ MISSING (run install.sh)
~/.claude/hooks/suggest-checkpoint.sh  → ✅ / ⚠️ MISSING (run install.sh)
~/.claude/hooks/session-reminder.sh    → ✅ / ⚠️ MISSING (run install.sh)
~/.claude/hooks/auto-snapshot.sh       → ✅ / ⚠️ MISSING (run install.sh)
~/.claude/hooks/sync-gemini.sh         → ✅ / ℹ️ MISSING (optional — needed only if Antigravity installed)

# Security
CREDENTIALS.md in project .gitignore? → ✅ / ❌ RISK (add to .gitignore immediately)
```

---

## Check 2 — Project Docs (run in current directory)

```bash
# Required docs
docs/PROJECT_STATE.md → ✅ / ❌ MISSING (run /new-project or /adapt-project)
docs/ROADMAP.md       → ✅ / ❌ MISSING
CLAUDE.md (project)   → ✅ / ❌ MISSING

# YAML validity
docs/PROJECT_STATE.md header:
  project_type: individual|team → ✅ / ⚠️ missing field (assume individual)
  status: CURRENT|STALE         → ✅ / ⚠️ STALE (run /new-session to update)
  updated: [date]               → ✅ / ⚠️ missing

SESSION block fields:
  Phase: [value]        → ✅ present / ⚠️ missing (add Phase + Phase_Status fields)
  Phase_Status: [value] → ✅ present / ⚠️ missing

# Staleness
SESSION Updated field → compare to today
  < 7 days  → ✅ CURRENT
  7–14 days → ⚠️ Getting stale (run /new-session)
  > 14 days → ❌ STALE (run /new-session — will auto-reconstruct from git)

# Coherence: PROJECT_STATE phase vs ROADMAP
Current phase in PROJECT_STATE → matches active phase in ROADMAP? → ✅ / ⚠️ mismatch
```

---

## Check 3 — Team Mode (only if project_type: team)

```bash
# All devs have sections?
CLAUDE.md ## Team → Members list → [Dev A, Dev B, Dev C]
PROJECT_STATE.md → sections: [### Dev A, ### Dev B, ### Dev C]
  → All present? ✅ / ⚠️ missing section for: [Dev X]

# Branches exist?
CLAUDE.md ## Git Strategy → expected branches
git branch -a → check each work/* branch exists → ✅ / ⚠️ missing: [branch]

# Leader defined?
CLAUDE.md ## Team → Leader: [name] → ✅ / ⚠️ not defined
```

---

## Check 4 — Coherence: Stack vs Code

```bash
# Stack in CLAUDE.md matches package.json / requirements.txt?
CLAUDE.md ## Stack → "Next.js, Supabase, Tailwind"
package.json dependencies → contains next, @supabase/supabase-js, tailwindcss?
  → ✅ coherent / ⚠️ mismatch: CLAUDE.md says X but code has Y

# Phase in PROJECT_STATE makes sense?
Phase: "MVP" + git log has 200+ commits → ⚠️ Consider updating phase in ROADMAP
Phase: "Production" + no deployment config found → ⚠️ Check ARCHITECTURE.md
```

---

## Check 5 — Version

```bash
~/.claude/DUPLA_VERSION → v[current]
Latest on GitHub → v[latest]
  → Equal: ✅ Up to date
  → Behind: ⚠️ New version available: v[latest] (run /update-dupla)
```

---

## Check 6 — Evaluator (Zero-Complacency Quality Gate)

**Rol:** Agente Evaluador implacable. Su trabajo es rechazar, no aprobar.
**Sesgo prohibido:** No puede declarar ✅ basándose en leer código. Requiere evidencia ejecutada.

### Regla innegociable
El Evaluador tiene **prohibido** marcar una tarea como Done en `claude-progress.txt` sin haber ejecutado al menos una prueba determinista. Leer el código y concluir "parece correcto" no es evidencia — es sesgo de autoevaluación.

### Protocolo de verificación (ejecutar en orden)

```bash
# 1. Skills instalados vs skills/ del repo
diff <(ls ~/.claude/skills/*.md | xargs -I{} basename {}) <(ls skills/*.md | xargs -I{} basename {})
  → Sin diff: ✅ / Con diff: ❌ DESINCRONIZADO — run install.sh

# 2. SESSION.Done vs git log — anti-hallucination
git log --oneline -10
  → Cada ítem en SESSION.Done tiene un commit hash que lo respalda? ✅ / ⚠️ sin evidencia

# 3. Hooks registrados vs archivos en disco
cat ~/.claude/settings.json | grep -A5 '"hooks"'
  → Para cada hook listado: [ -f ~/.claude/hooks/nombre.sh ] && echo OK || echo MISSING
  → MISSING: ❌ hook declarado pero archivo inexistente

# 4. VALIDACIÓN EJECUTADA (no solo leída) — para proyectos software
#    Evaluador debe correr al menos UNO de los siguientes según el proyecto:
bash bin/install.sh --dry-run 2>&1 | tail -5   # scripts de instalación
# o: npm test / pytest / go test ./...          # suite de tests
# o: npx eslint . --max-warnings 0              # linter sin warnings
# o: bash -n hooks/*.sh                         # syntax check de hooks bash
  → Exit code 0: ✅ PASS — puede marcarse Done
  → Exit code ≠ 0: ❌ FAIL — devolver al Implementador con el error exacto

# 5. ROADMAP vs realidad
Phase_Status: GO/NO-GO Pending →
  git log --oneline | grep -i "[outcome keyword from ROADMAP]"
  → Commits reales respaldan el outcome? ✅ / ⚠️ declarado sin evidencia en git

# 6. Prompt injection scan en docs recién escritos
grep -rn "ignore\|execute\|run\|override\|system:\|<instructions>" docs/ CLAUDE.md 2>/dev/null
  → Hits en contexto sospechoso: ⚠️ POSIBLE INYECCIÓN — revisar manualmente

# 7. Archivos huérfanos en docs/
find docs/ -maxdepth 1 -type f | grep -vE "PROJECT_STATE|ROADMAP|ARCHITECTURE|PROBLEMS|SURFACE_GUIDE|SYSTEM_MAP|HOW_IT_WORKS|code-review-graph|SPEC|GRAPH_REPORT|graph\.(json|html)"
  → Archivos inesperados: ⚠️ ¿mover a docs/vision/?
```

### Si alguna prueba falla — protocolo de rechazo
```
❌ EVALUADOR — Tarea rechazada

Prueba fallida: [nombre de la prueba]
Comando ejecutado: [comando exacto]
Output del error:
  [primeras 10 líneas del stderr/stdout]

Acción requerida: devolver al Implementador
No actualizar claude-progress.txt hasta que la prueba pase.
```

### Solo si TODAS las pruebas pasan
```bash
# Actualizar claude-progress.txt — SOLO tras evidencia ejecutada
sed -i 's/\[>\] \[tarea\]/[x] [tarea] — EVALUADO [fecha]/' claude-progress.txt
```

---

## Output Format

### If all OK:
```
✅ Health Check — All systems OK

Tools:     ✅ git · python3 · [node if installed]
Global:    ✅ Skills (15/15) · CLAUDE.md (real content) · SYSTEM.md · MEMORY_GLOBAL.md · v[version]
GEMINI:    ✅ ~/.gemini/GEMINI.md synced · [N] workflows deployed
Hooks:     ✅ Stop (3) · PreToolUse (2) · UserPromptSubmit (1) · PostToolUse (1)
Project:   ✅ PROJECT_STATE (CURRENT) · ROADMAP · CLAUDE.md
[Team:     ✅ 3 devs · 3 sections · 3 branches]
Stack:     ✅ Coherent
Evaluator: ✅ Skills sync · SESSION/git alineados · Hooks en disco · No archivos huérfanos
```

### If issues found:
```
⚠️ Health Check — [N] issues found

CRITICAL (fix now):
  ❌ docs/PROJECT_STATE.md missing → run /new-project or /adapt-project
  ❌ CREDENTIALS.md not in .gitignore → add immediately

WARNINGS (fix soon):
  ⚠️ SESSION stale (14 days) → run /new-session
  ⚠️ update-dupla v2.0.0 → v2.1.0 available → run /update-dupla
  ⚠️ work/phase1-frontend branch missing → git checkout -b work/phase1-frontend

INFO:
  ℹ️ Antigravity not detected — if installed, check ~/.gemini/antigravity/ exists
  ℹ️ MCP not configured (optional — run /setup-dupla to enable)

Run /health-check again after fixes to verify.
```

---

## Rules

- Run silently — no verbose output unless issue found
- CRITICAL = blocks workflow (fix before working)
- WARNING = degrades experience (fix this session)
- INFO = optional improvements
- Never modify files — only reports issues
- Always suggest the command that fixes each issue
