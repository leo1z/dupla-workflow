# Dupla-Workflow v2

AI-assisted project workflow system. Portable, multi-IDE, works for individuals and teams. Covers software, business, content, and research projects.

**Key features:**
- ✅ Individual, team, and micro (lightweight) workflows
- ✅ Context-efficient SESSION blocks (~60 tokens vs 3000+ without workflow)
- ✅ Auto-reconstruct state from git log (no manual discipline required)
- ✅ GO/NO-GO checkpoints for idea validation → prototype → scale
- ✅ Clean model handoffs (Claude ↔ Gemini)
- ✅ Multi-IDE: Claude Code (VS Code) + Antigravity + Claude Desktop
- ✅ Human-readable save points (/restore)

→ [How the system works — document map + token costs](docs/SYSTEM_MAP.md)

---

## Quick Start

### 1. Install (terminal — once per machine)

```bash
git clone https://github.com/leo1z/dupla-workflow.git
cd dupla-workflow
bash bin/install.sh
```

> **Windows:** use Git Bash or WSL to run `bash bin/install.sh`. In VS Code, open the integrated terminal and set it to Git Bash first.

Deploys skills to `~/.claude/skills/` (Claude Code) and `~/.agent/skills/` (Antigravity, if detected).

### 2. Configure (IDE — once per machine)

In Claude Code or Antigravity:
```
/setup-dupla
```
Creates `~/.claude/CLAUDE.md`, `~/.claude/SYSTEM.md`, `~/.claude/PROBLEMS_GLOBAL.md`.
If files already exist → system asks to update or keep each one.

### 3. Create a Project (IDE)

```
/new-project
```
Asks: project maturity + **Individual or Team** + 7 IML questions.
Generates docs + folder structure + git branches automatically.

### 4. Daily Workflow

```
/new-session     → reads state, tells you what to do next
[work]
/checkpoint      → saves state, suggests next model
git push
```

---

## Individual vs Team

### Individual Workflow
```
/new-session → work → /checkpoint → git push
```
- /new-session reads SESSION block (~60 tokens)
- /checkpoint updates PROJECT_STATE + suggests commit

### Team Workflow
```
Each dev:    /new-session → work on work/[branch] → /checkpoint → push
Lead only:   /checkpoint approve-pr [branch] → review → merge to main
```
- /new-session reads ONLY your Dev section (~30 tokens) + dependencies (~20 tokens)
- /checkpoint auto-generates Done from your git log (no typing)
- Lead reviews changes vs ROADMAP before merging
- No conflicts: each dev on their own branch + their own section in PROJECT_STATE

### Micro Workflow (small projects + casual sessions)
```
/quick-start     → creates QUICKSTATE.md in current folder, asks 2 questions
[work]
/quick-start     → update state (or just edit QUICKSTATE.md directly)
```
- No `docs/` folder, no git branches, no roadmap — just one file
- Works in any folder: scripts, notes, experiments, research
- `/new-session` auto-detects `QUICKSTATE.md` and switches to micro mode
- Upgrade anytime: `/new-project` or `/adapt-project`

### Convert Individual → Team
```
/adapt-to-team
```
Backs up current state, adds Team sections to existing docs, creates work branches.

### Add Team Member Mid-Project
```
/add-team-member
```
Adds dev section to PROJECT_STATE, updates CLAUDE.md + ROADMAP, creates branch.

---

## Roadmap Philosophy

Each project follows: **Validate → Prototype → GO/NO-GO → Scale**

```
Phase 0: Research (if needed) → GO/NO-GO
Phase 1: MVP / Prototype (2 weeks max) → GO/NO-GO → Continue / Adapt / Kill
Phase 2: Core Features / Scale → GO/NO-GO
Phase 3+: Production / Expansion
```

Kill criteria defined upfront. No sunk cost fallacy.

---

## IDE Setup

### Claude Code (VS Code)
1. Install VS Code + Claude Code extension
2. `bash bin/install.sh` (macOS/Linux: Terminal · Windows: Git Bash)
3. Skills in `~/.claude/skills/` (for Antigravity) and `~/.claude/commands/` (for slash commands)

> **Slash commands not showing?** In Claude Code, type `/` and check if `/new-session`, `/checkpoint` appear.
> If not, verify `~/.claude/commands/` has the `.md` files. You may need to restart VS Code.
> Workaround: type the skill name manually (e.g., `run /new-session`) — works even without slash registration.

### Antigravity
1. Install Antigravity (Google's Agent IDE)
2. `bash bin/install.sh` (auto-detects `~/.agent/` on macOS/Linux or `%USERPROFILE%\.agent\` on Windows)
3. Skills in `~/.agent/skills/`
4. CLAUDE.md synced to `~/.agent/CLAUDE.md`
5. **Skills activation:** in Antigravity write the skill name as instruction (e.g. "Ejecuta /new-session") — not slash commands

### Claude Desktop
1. Install Claude Desktop (Anthropic official)
2. `bash bin/install.sh`
3. Skills in `~/.claude/skills/`

---

## Model Routing

| Use Claude | Use Gemini |
|-----------|-----------|
| Writing code, debugging | Planning, strategy |
| Architecture decisions | Code review (second opinion) |
| Auth/DB changes | Research, market analysis |
| Multi-file changes | Generating docs/copy |

`/checkpoint` suggests which model to use next based on your `Next` field.

---

## Command Reference

| Command | When | Notes |
|---------|------|-------|
| `/setup-dupla` | First-time machine setup | Reads existing config, updates or keeps |
| `/new-project` | Start any new project | Individual or Team, any maturity level |
| `/new-session` | Start any work session | Reads state + suggests branch (team) |
| `/checkpoint` | Save progress | Modes: quick / close / handoff / approve-pr |
| `/checkpoint approve-pr [branch]` | Lead: review + merge | Compares vs ROADMAP, shows diff |
| `/adapt-to-team` | Convert individual → team | Backs up, adds Team sections |
| `/add-team-member` | Add dev or change role | Updates all docs + creates branch |
| `/adapt-project` | Onboard existing project | Detects what's missing, creates docs |
| `/restore` | Revert to save point | Human-readable checkpoint list |
| `/update-dupla` | Update to latest version | Auto-backup, update, sync IDEs |
| `/health-check` | Verify system state | OK / warnings / errors |
| `/project-audit` | Impact analysis before changes | Uses pre-compiled graph (low tokens) |
| `/token-budget [%]` | Monitor session burn | Cost estimate + lighter alternatives |

---

## Token Efficiency

|  | Without workflow | With workflow |
|--|-----------------|---------------|
| Per session (individual) | 3,000–5,000 tokens | ~110 tokens |
| Per session (team, per dev) | 3,000–5,000 tokens | ~60 tokens |
| Daily (3 devs, 5 sessions each) | ~45,000 tokens | ~1,650 tokens |
| **Savings** | — | **96–97%** |

Key: SESSION block + selective doc loading (never load all docs upfront).

---

## Updating

### Already have Dupla-Workflow v2?

```bash
cd ~/dupla-workflow   # wherever you cloned it
git pull
bash bin/install.sh
```

Then in your IDE:
```
/health-check   → verify everything is correct
```

### Have v2 installed but want in-IDE update?

```
/update-dupla   → checks version, shows changelog, updates with backup
```

### Coming from v1 (commands/ folder, CREDENCIALES.md)?

```
/update-dupla   → detects v1, guides migration step by step
```
Migration: backs up all v1 files → installs v2 → suggests `/setup-dupla` for global docs → `/adapt-project` per project for doc format.

---

## Troubleshooting

**"docs/PROJECT_STATE.md not found"**
→ `/adapt-project` (existing project) or `/new-project` (new project)

**Session state stale (>24h)**
→ `/new-session` auto-reconstructs from git log

**Need to switch models**
→ `/checkpoint` → option 3 (Handoff) → generates transfer block

**Lost work**
→ `/restore` → numbered save points with readable descriptions

**IDEs out of sync**
→ `/update-dupla` → auto-syncs skills + CLAUDE.md to all IDEs

**Team: conflict in PROJECT_STATE.md**
→ Each dev has their own `### Dev Name` section — resolve by keeping both sections

---

## Project Types

| Type | Docs Generated | Focus |
|------|---------------|-------|
| Software/SaaS | PROJECT_STATE, ROADMAP, ARCHITECTURE, PROBLEMS, CLAUDE | Build → validate → scale |
| Negocio | PROJECT_STATE, ROADMAP, PLAN, PROBLEMS, CLAUDE | Strategy → ops → metrics |
| Contenido | PROJECT_STATE, ROADMAP, PLAN, PROBLEMS, CLAUDE | Audience → channels → distribution |
| Investigación | PROJECT_STATE, ROADMAP, PLAN, PROBLEMS, CLAUDE | Question → methodology → answer |

---

## Version

**v2.3.0** — 2026-04-22
- Team mode: individual vs team detection, team templates, git strategy
- /adapt-to-team: convert individual projects to team
- /add-team-member: add devs + edit roles mid-project
- /checkpoint Mode 4: approve-pr for Lead (review + merge + GO/NO-GO)
- /new-session: auto-detect project_type, identify dev, suggest branch
- /new-project: Phase 6B team setup, auto-generate branches
- ROADMAP: Role Assignments per phase with sprint suggestions
- PROJECT_STATE_TEAM_TEMPLATE: per-dev sections, auto-generated from git log

**v2.0.0** — 2026-04-20
- Complete redesign: GitHub repo deployment
- SESSION block context efficiency (~60 tokens)
- GO/NO-GO checkpoints on ROADMAP
- Multi-IDE support (Claude Code + Antigravity)
- Model routing (Claude vs Gemini)
