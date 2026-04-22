Verify system coherence and detect issues. Run anytime something feels off.

Usage: /health-check

---

## Execution

Run ALL checks silently. Output only warnings and errors, plus a summary.

---

## Check 1 — Global System

```bash
# Files exist?
~/.claude/CLAUDE.md          → ✅ / ❌ MISSING
~/.claude/SYSTEM.md          → ✅ / ❌ MISSING
~/.claude/PROBLEMS_GLOBAL.md → ✅ / ❌ MISSING
~/.claude/DUPLA_VERSION      → ✅ v[X.Y.Z] / ❌ MISSING

# Skills installed?
~/.claude/skills/ → list .md files → check that CORE skills are present:
  new-project, new-session, checkpoint, restore, setup-dupla,
  update-dupla, adapt-project, adapt-to-team, add-team-member,
  health-check, token-budget, project-audit, quick-start
  → ✅ core skills present / ⚠️ missing: [list only missing core ones]
  → Extra .md files not in core list → ℹ️ Custom skills found: [list] (not an error)

# Core skills count (dynamic)
CORE_SKILLS=(new-project new-session checkpoint restore setup-dupla update-dupla adapt-project adapt-to-team add-team-member health-check token-budget project-audit quick-start)
FOUND=$(ls ~/.claude/skills/*.md 2>/dev/null | wc -l)
# Compare found vs 13 expected — flag missing by name only

# CLAUDE.md has required fields?
grep "Name:" ~/.claude/CLAUDE.md    → ✅ / ⚠️ empty
grep "Stack" ~/.claude/SYSTEM.md    → ✅ / ⚠️ empty

# Antigravity: if ~/.agent/ exists
~/.agent/skills/ → same skills present? → ✅ / ⚠️ out of sync
~/.agent/CLAUDE.md matches ~/.claude/CLAUDE.md? → ✅ / ⚠️ different

# Hooks installed?
~/.claude/hooks/guard-project-state.sh   → ✅ / ⚠️ MISSING
~/.claude/hooks/suggest-checkpoint.sh   → ✅ / ⚠️ MISSING
~/.claude/hooks/session-reminder.sh     → ✅ / ⚠️ MISSING
# Hooks registered in settings?
~/.claude/settings.json → contains "Stop", "PreToolUse", "UserPromptSubmit" hooks? → ✅ / ⚠️ hooks not wired (run /setup-dupla to re-add)

# Security
CREDENTIALS.md in project .gitignore? → ✅ / ❌ RISK
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

## Output Format

### If all OK:
```
✅ Health Check — All systems OK

Global: ✅ Skills (13/13) · CLAUDE.md · SYSTEM.md · v[version]
Project: ✅ PROJECT_STATE (CURRENT) · ROADMAP · CLAUDE.md
[Team: ✅ 3 devs · 3 sections · 3 branches]
Stack: ✅ Coherent
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
  ℹ️ Antigravity not detected (normal if not using it)
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
