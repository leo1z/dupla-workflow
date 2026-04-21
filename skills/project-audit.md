Audit project structure and code impact using pre-compiled code-review-graph.

Usage: /project-audit [change-area]

---

## How It Works

1. **Read** `docs/code-review-graph.json` (pre-compiled structure analysis)
2. **No re-parsing:** uses static JSON, ~200 tokens vs 8000+ for full codebase read
3. **Impact analysis:** shows what breaks if you change X
4. **Risk zones:** highlights critical areas (setup, onboarding, core skills)

---

## Phase 1 — Load Graph

Read `docs/code-review-graph.json` (if not regenerated > 2 weeks, regenerate):

```bash
bash bin/generate-code-review-graph.sh
```

---

## Phase 2 — Audit Mode

### Default (Full Audit)
No args → show:
- **Structure overview** (folders, file counts)
- **Risk zones** (5 highest-impact areas)
- **Dependencies** (what depends on what)
- **Stability score** (how much churn each section has)

### Targeted Audit
`/project-audit [path]` → analyze impact of changes to [path]:

```
/project-audit skills/setup-dupla.md

→ Shows:
  - What depends on setup-dupla
  - Who breaks if it changes
  - Testing recommendations
  - Regenerate graph after change? [y/n]
```

Supported paths:
- `bin/install.sh` (critical: multi-IDE deployment)
- `skills/new-project.md` (critical: project init)
- `skills/setup-dupla.md` (critical: onboarding)
- `skills/new-session.md` (high: context parsing)
- `hooks/guard-project-state.sh` (medium: workflow guard)
- `templates/` (medium: doc generation)

---

## Phase 3 — Output Format

### Full Audit Output

```
## Project Audit — [project]

**Structure:**
- 8 v2 skills (setup, new-project, new-session, checkpoint, restore, adapt-project, update-dupla, token-budget)
- 10 templates (PROJECT_STATE, ROADMAP, ARCHITECTURE, PLAN, PROBLEMS, CLAUDE, etc.)
- 3 automation hooks (guard, checkpoint, session)
- 2 deployment scripts (install.sh, generate-code-review-graph.sh)

**Stability Score:** 85/100
- Stable: skills/, templates/, docs/ (low churn)
- New: hooks/ (needs monitoring)

**Risk Zones (Critical):**
1. bin/install.sh — multi-IDE deploy breaks onboarding for all new users
2. skills/setup-dupla.md — first-time config breaks entire workflow
3. skills/new-project.md — project init logic
4. skills/new-session.md — SESSION parsing
5. hooks/guard-project-state.sh — prevents unguarded changes

**Last graph generated:** [date]
**Regenerate after:** new skills, hook changes, template updates
```

### Targeted Audit Output

```
## Impact Analysis — skills/setup-dupla.md

**This file is referenced by:**
- bin/install.sh (execution)
- skills/new-session.md (context setup)
- README.md (installation doc)
- QUICKSTART.html (new user guide)

**If you change setup-dupla.md:**
- ❌ New user onboarding breaks
- ❌ ~/.claude/CLAUDE.md generation breaks
- ❌ ~/.claude/SYSTEM.md generation breaks
- ⚠️  Antigravity integration may fail

**Risk level:** HIGH
**Testing needed:** 
  1. /setup-dupla with new answers
  2. Check ~/.claude/ files created correctly
  3. Verify ~/.agent/ synced (Antigravity)
  4. Run /health-check

**After changes:**
bash bin/generate-code-review-graph.sh
git add docs/code-review-graph.json
```

---

## Phase 4 — Regen Decision

If auditing before a big change:

"Changes to [path]? 
→ Recommend regenerating graph after merge
→ Helps next person understand impact"

Ask: "Regenerate graph now? [y/n]"

---

## Rules

- **Graph is static:** Update only after meaningful structural changes
- **No full-codebase reads:** All analysis from JSON only
- **Dependencies are explicit:** Added manually or inferred from filenames
- **Risk zones are critical:** Changes there need extra testing
- **Always push updated graph** after structural changes (git push)

---

## When to Use

- **Before refactoring:** /project-audit skills/ → see impact
- **Before merging:** /project-audit [branch-change] → check risks
- **Onboarding audit:** /project-audit → full structure overview
- **Security review:** /project-audit hooks/ → guard logic check
- **Dependency analysis:** /project-audit → who broke if X fails?

---

## References

→ Full graph: docs/code-review-graph.json
→ Regenerate: bash bin/generate-code-review-graph.sh
→ Guard rules: hooks/guard-project-state.sh
