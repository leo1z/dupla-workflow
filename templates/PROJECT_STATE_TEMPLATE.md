---
doc: PROJECT_STATE
updated: YYYY-MM-DD HH:MM
status: CURRENT
---

# Project State — [PROJECT_NAME]

<session>
Updated: YYYY-MM-DD HH:MM
Status: ACTIVE | PAUSED | BLOCKED
Done: item1 · item2 · item3
Next: one sentence describing the immediate next action
Blockers: none | description of blocking issue
Branch: main | work/feature-name
Model: claude | gemini | other
Handoff: no | [destination model if switching]
</session>

---

## Current Goal

[1 clear objective]

---

## Team (optional)

- Owner: [name or model]
- Current handler: [who's working on it]
- Last handoff: [date + direction]
- Shared branch: [work/feature-name]

---

## In Progress

- Task
- Task

---

## Next Steps

- [ ] **Must:** [critical task]
- [ ] **Should:** [important, not urgent]
- [ ] **Could:** [nice to have]

---

## Blockers

- [blocker description] | none

---

## Recent Changes (last 3–5)

- [DATE] — Change description
- [DATE] — Change description

---

## References

→ Current branch: [work/name]
→ Compared to main: [ahead/behind/equal]
→ Ready to merge: [YES/NO]
→ Strategic plan: docs/ROADMAP.md
→ Technical: docs/ARCHITECTURE.md
→ Issues: docs/PROBLEMS.md
→ Global: ~/.claude/CLAUDE.md

---

## Rules

- Source of truth: this file + codebase (trust git over PROJECT_STATE if conflict)
- Updated on: /progress command
- SESSION block read first (max ~60 tokens for context efficiency)
- Do NOT infer state from chat — trust git and docs
