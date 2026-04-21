# Dupla-Workflow v2

AI-assisted project workflow system. Portable, newbie-friendly, multi-IDE. Works for software projects, business planning, content, research—anything.

**Key features:**
- ✅ Single repo, deploy to Claude Code + Antigravity
- ✅ Structured interviews (Patrón Estándar)
- ✅ Context-efficient SESSION blocks (~60 tokens vs 300)
- ✅ Clean model handoffs (Claude ↔ Gemini)
- ✅ Human-readable save points (numbered, not hashes)
- ✅ GO/NO-GO checkpoints for validation

---

## Quick Start

### 1. Install

```bash
git clone https://github.com/leo1z/dupla-workflow.git
cd dupla-workflow
bash bin/install.sh
```

This deploys skills to:
- `~/.claude/skills/` (Claude Code)
- `~/.agent/skills/` (Antigravity, if detected)

### 2. First Setup

In Claude Code or Antigravity:

```
/setup-dupla
```

Answer questions about your name, role, stack, and active projects.
Creates:
- `~/.claude/CLAUDE.md` (your identity + behavior rules)
- `~/.claude/SYSTEM.md` (tech stack + projects registry)
- `~/.claude/PROBLEMS_GLOBAL.md` (cross-project issues)

### 3. Create a Project

In your project root:

```
/new-project
```

Guided discovery:
- Answer 7 questions (problem, user, MVP, risk, constraints)
- Binary clarity check
- Optional market research (parallel subagents)
- Auto-generates docs + folder structure

Creates:
- `docs/PROJECT_STATE.md` (current state, saved checkpoints)
- `docs/ROADMAP.md` (phases + GO/NO-GO checkpoints)
- `docs/ARCHITECTURE.md` or `docs/PLAN.md` (design or strategy)
- `docs/PROBLEMS.md` (issues + solutions)
- `CLAUDE.md` (project-specific rules)

### 4. Daily Workflow

**Start session:**
```
/new-session
```
Shows: goal, current branch, state summary, next 3 steps + save points.

**Work:**
Edit files, run commands, implement features.

**Save checkpoint (mid-session):**
```
/checkpoint
```
Menu:
1. Quick save (update state)
2. Full close (end of day)
3. Handoff (switch to Gemini/another model)

---

## IDE Setup

### Claude Code (VS Code)

1. Install Claude Code CLI
2. Run `bash bin/install.sh`
3. Skills available immediately in VS Code command palette

### Antigravity (Google's Agent IDE)

1. Install Antigravity
2. Run `bash bin/install.sh` (auto-detects ~/.agent/)
3. Skills in `.agent/skills/`
4. Your CLAUDE.md synced to `~/.agent/CLAUDE.md`

---

## Project Types

Dupla-Workflow adapts to ANY project type:

| Type | Focus | Example |
|---|---|---|
| **Software/SaaS** | Build → validate → scale | Web app, mobile app, API |
| **Negocio** | Strategy → implementation → metrics | Service, process, business model |
| **Contenido** | Audience → channels → distribution | Newsletter, blog, podcast, TikTok |
| **Investigación** | Question → methodology → sources | Research paper, data analysis |

---

## Model Routing

**Use Claude (this) for:**
- Code writing + debugging
- Architecture decisions
- Auth/DB modifications

**Use Gemini for:**
- Planning + strategy
- Code review (second opinion)
- Research + market analysis

How: `/checkpoint` suggests next model based on your work.

---

## Command Reference

| Command | When | Output |
|---------|------|--------|
| `/new-session [goal]` | Start any work session | State summary + next steps |
| `/checkpoint` | Save progress | Menu: quick/close/handoff |
| `/restore` | Undo to a save point | Human-readable checkpoint list |
| `/update-context` | Stack/architecture changed | Suggests CLAUDE.md updates |
| `/adapt-project` | Onboard existing project | Checks what's missing, creates docs |
| `/setup-dupla` | First-time setup | Guided interview, creates ~/.claude/ |
| `/update-dupla` | New version available | Auto-backup, update, sync IDEs |
| `/health-check` | Verify system state | OK/warnings/errors |
| `/token-budget [%]` | Monitor session burn | Cost estimate + lighter alternatives |

---

## Troubleshooting

### "docs/PROJECT_STATE.md not found"
→ Run `/adapt-project` to onboard existing project, or `/new-project` for new project.

### Session state is stale (> 48 hours)
→ Run `/new-session` — it will reconstruct state from git log + PROJECT_STATE.

### Need to switch models (Claude → Gemini)
→ Run `/checkpoint handoff` — generates transfer block for Gemini chat.

### Lost work (wrong branch, uncommitted changes)
→ Run `/restore` to revert to last numbered save point.

### IDEs out of sync
→ Run `/update-dupla` — auto-syncs skills + CLAUDE.md to both Claude Code + Antigravity.

---

## Version

**v2.0.0** — 2026-04-20
- Complete redesign: plugin system → GitHub repo
- New commands: checkpoint, restore, setup-dupla
- IML assessment + GO/NO-GO checkpoints
- Multi-IDE support (Claude Code + Antigravity)
- SESSION block context efficiency
- Model routing (Claude vs Gemini)

---

**Questions?** Check `/health-check` for system state, or read the skill files in `skills/` for detailed behavior.

Good luck! 🚀
| `/setup` | Setup del sistema por primera vez en una máquina | Una vez por máquina |
| `/adopt` | Adopta proyecto existente al workflow | Una vez por proyecto existente |
| `/token-budget` | Conciencia de tokens + alertas de presupuesto | En sesiones largas |

---

## Crear un proyecto nuevo

### Flujo rápido: interactivo

```bash
bash /ruta/a/dupla-workflow/nuevo-proyecto.sh
```

El script te hace las preguntas directamente en la terminal y crea el proyecto en tu carpeta actual (o pregunta dónde).

### Flujo planificado: config file (opcional)

**Paso 1 — Planificar en Claude**

Usa el PLANNING_PROMPT.md para generar un bloque `proyecto.config`.

**Paso 2 — Correr con config**

```bash
bash /ruta/a/dupla-workflow/nuevo-proyecto.sh --config mi-proyecto.config
```

El script auto-detecta dónde guardar el proyecto sin preguntar rutas.

---

## Qué crea el script

```
mi-proyecto/
├── CLAUDE.md                  ← contexto para la AI (stack, arquitectura, reglas)
├── docs/
│   ├── PROJECT_STATE.md       ← estado dinámico: dónde estamos, qué sigue
│   └── PROBLEMS.md            ← errores ya resueltos (no repetir)
├── .env.example               ← variables sin valores — sí a git
└── .gitignore
```

Además: git init, branch `main` + `work/setup`, y repo privado en GitHub (requiere token en `~/.claude/CREDENCIALES.md`).

---

## Configuración inicial (una sola vez por usuario)

Después de instalar con `bash instalar.sh`:

### 1. Setup automático

Abre VS Code con cualquier proyecto y escribe:
```
/setup
```

Responde las preguntas y Claude genera automáticamente:
- `~/.claude/CLAUDE.md` — tu configuración global personalizada
- `~/.claude/CONTEXTO_[nombre].md` — perfil tuyo
- `~/.claude/STACK_GLOBAL.md` — tus herramientas y servicios
- `~/.claude/PROJECTS_SKILLS.md` — tus proyectos activos

### 2. Credenciales (opcional pero recomendado)

```bash
nano ~/.claude/CREDENCIALES.md
```

Llena tokens de GitHub, Supabase, etc. **Nunca subas este archivo a git.**

### 3. Verifica

Escribe `/health-check` en cualquier proyecto. Debe reportar: skills instalados, CLAUDE.md presente, etc.

---

## Flujo de trabajo por sesión

```
Inicio:   git pull → /new-session
Trabajo:  commits frecuentes en work/*
Cierre:   git push → /progress
```

---

## Actualizaciones

```bash
cd sistema-trabajo
git pull
bash instalar.sh
```

---

## Estructura del repo

```
dupla-workflow/
├── commands/          ← skills de Claude Code (.md)
├── templates/         ← PROJECT_STATE, GUIA_COLABORADOR, PLAN_PROMPT, otros templates
├── global-templates/  ← templates para setup inicial (~/.claude/)
├── docs/              ← guías del sistema (New_Project_Guide, WORKFLOW_IDEAL)
├── nuevo-proyecto.sh  ← script de setup (interactivo o --config)
└── instalar.sh        ← instala todo en la máquina local
```
