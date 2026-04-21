---
doc: CLAUDE
type: Semi-static
updated: YYYY-MM-DD
purpose: Project-specific instructions and constraints
---

# Context — [PROJECT_NAME]

## Project

[1–2 lines — what it does and for whom]

---

## Current Phase

[Planning / Prototype / MVP / Production]

---

## Stack (High-Level)

- Tech 1
- Tech 2
- Tech 3

---

## Constraints

- Do NOT modify: [areas]
- No credentials in repo
- Follow work/* branches only
- [specific gotchas or non-obvious rules]

---

## Workflow Rules

- PROJECT_STATE.md + code = source of truth
- Always read PROJECT_STATE.md first
- Follow roadmap phases (but adapt to reality)
- Prototype first, then scale
- Do NOT over-engineer

---

## Execution Rules

- Before debugging → check docs/PROBLEMS.md
- If fix exists → reuse it
- If new issue → document it
- If stuck after multiple attempts → stop and rethink
- If request conflicts with PROJECT_STATE → flag it

---

## Command Map

- /new-session → read docs/PROJECT_STATE.md
- /checkpoint → save session + update state
- /update-context → align CLAUDE.md with reality
- /restore → revert to numbered save point

---

## Docs Map

- State → docs/PROJECT_STATE.md (always — read <session> block first)
- Roadmap → docs/ROADMAP.md (strategic direction)
- Architecture → docs/ARCHITECTURE.md (technical decisions)
- Problems → docs/PROBLEMS.md (debug only if stuck)

---

## References

→ Global behavior: ~/.claude/CLAUDE.md
→ Active projects: ~/.claude/SYSTEM.md
→ Problems across projects: ~/.claude/PROBLEMS_GLOBAL.md
→ Credentials: ~/.claude/CREDENTIALS.md (reference only, never commit)