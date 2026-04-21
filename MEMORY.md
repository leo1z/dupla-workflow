# Memory — Auto-Memory System Reference

Each user has a persistent memory directory: `~/.claude/projects/<cwd>/memory/`

This stores:
- **user_*.md** — Your role, preferences, expertise
- **feedback_*.md** — How you want Claude to work (approaches, rules, what works)
- **project_*.md** — Active project context (deadlines, goals, decisions)
- **reference_*.md** — External systems (APIs, tools, documentation)

## Structure

Memory persists across conversations. Claude reads it automatically:
- On session start: loads MEMORY.md index
- During work: checks for relevant memories
- On important decisions: uses memory to stay consistent

## Example Entry

**user_role.md:**
```markdown
---
name: Role
description: User's primary responsibility in this domain
type: user
---

System architect, hands-on builder. Leads technical design but values feedback.
Works best with frameworks and visual models before implementation.
```

**feedback_approach.md:**
```markdown
---
name: Approach to refactoring
description: How to handle refactoring in this codebase
type: feedback
---

Always propose before implementing. Prefer small, shippable PRs over big rewrites.
**Why:** Easier code review, faster feedback, less risk of broken assumptions.
**How to apply:** When touching >3 files, draft the plan first.
```

## When to Use

- Remember cross-session context
- Track what the user values (speed, quality, safety)
- Learn from past mistakes
- Build coherent mental models of the project

**Important:** Memory supplements code and documentation — it never replaces them. Always verify assumptions in the actual codebase first.
