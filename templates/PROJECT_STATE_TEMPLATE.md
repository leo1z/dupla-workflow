---
doc: PROJECT_STATE
updated: YYYY-MM-DD HH:MM
status: CURRENT
project_type: individual
---

# Project State — [PROJECT_NAME]

<session>
Updated: YYYY-MM-DD HH:MM
Status: ACTIVE | PAUSED | BLOCKED
Mode: research | lite | full
Phase: Phase [N] — [name] | N/A
Phase_Status: In Progress | GO/NO-GO Pending | Complete
Done: item1 · item2 · item3
Next: one sentence describing the immediate next action
Blockers: none | description of blocking issue
Branch: main | work/feature-name
Model: claude | gemini | other
Handoff: no | [destination model if switching]
</session>

---

## Current Goal

[1 clear objective — what done looks like for this phase]

---

## References

→ Strategic plan: docs/ROADMAP.md
→ Technical: docs/ARCHITECTURE.md
→ Issues: docs/PROBLEMS.md
→ Global: ~/.claude/CLAUDE.md

---

## Rules

- Source of truth: this file + codebase (trust git over PROJECT_STATE if conflict)
- SESSION block read first (~60 tokens for context efficiency)
- Do NOT infer state from chat — trust git and docs
- Mode field controls session behavior: research / lite / full
