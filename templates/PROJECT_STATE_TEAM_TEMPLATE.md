---
doc: PROJECT_STATE
updated: YYYY-MM-DD HH:MM
status: CURRENT
project_type: team
---

# Project State — [PROJECT_NAME]

---

## Team Status

<!-- /new-session reads ONLY your Dev section (~30 tokens).
     /checkpoint auto-updates Done from git log — no manual entry needed.
     Each dev edits ONLY their own section. Leader edits Shared Status. -->

### [Dev A Name] ([Role]) — work/[phase]-[role]
Updated: YYYY-MM-DD HH:MM
Done: [auto-generated from git log on /checkpoint]
Next: [one concrete action]
Blockers: none | [description]
Dependencies: Waiting for [Dev X] | none

### [Dev B Name] ([Role]) — work/[phase]-[role]
Updated: YYYY-MM-DD HH:MM
Done: [auto-generated from git log on /checkpoint]
Next: [one concrete action]
Blockers: none | [description]
Dependencies: Waiting for [Dev A] | none

---

## Shared Status
<!-- Leader ONLY — updated after each approved PR merge to main -->
Updated: YYYY-MM-DD HH:MM
Phase: Phase [N] — [Phase Name]
Status: In Progress | Phase Complete | Blocked
Next Phase Condition: [GO/NO-GO criteria from ROADMAP]
Last Merge: [dev name] — [what merged] — [date]

---

## References

→ Git strategy + roles: CLAUDE.md (## Team section)
→ Phase + role assignments: docs/ROADMAP.md (## Role Assignments)
→ Technical decisions: docs/ARCHITECTURE.md
→ Issues: docs/PROBLEMS.md
→ Global: ~/.claude/CLAUDE.md

---

## Rules

- Each dev edits ONLY their named section
- /checkpoint auto-generates Done from git log (no manual typing)
- Leader updates Shared Status after each PR merge
- Git conflict? Each dev has their own section → easy resolve
- /new-session reads your section + dependencies only (~60 tokens total)
