First-time setup. Generates all global config files for ~/.claude/ through an interview.

Usage: /setup

---

## Pre-check

Before starting, check which files already exist in ~/.claude/:
- CLAUDE.md
- STACK_GLOBAL.md
- PROJECTS_SKILLS.md
- CONTEXTO_[name].md

For each that exists → ask: "Found [file]. Overwrite? [s/n]"
Skip if user says n.

---

## Interview (ask ALL questions in ONE message, grouped)

### Block 1 — About you
1. What's your name?
2. What's your role? (founder, developer, designer, marketer, etc.)
3. How do you work best? (e.g. design system first then execute, prefer direct output, etc.)
4. Any key context about how you think or what drives you?

### Block 2 — Tech stack
5. What's your main stack for web/SaaS projects?
6. What services do you use? (Supabase, Vercel, VPS, N8N, Evolution API, etc.)
7. Any alternate stacks for scripts, APIs, or other project types?
8. Any specific infra details? (VPS IP, service URLs, etc.)

### Block 3 — Active projects
9. List your active projects: for each → name, what it does, GitHub repo, current phase

### Block 4 — Skills & plugins
10. What Claude plugins do you have installed? (e.g. ui-ux-pro-max, frontend-slides)

Wait for all answers before generating anything.

---

## Generate files

### 1. CONTEXTO_[name].md → ~/.claude/CONTEXTO_[name].md

Use answers from Block 1. Follow CONTEXTO_USER_TEMPLATE.md structure.
Keep concise — max 50 lines.

### 2. STACK_GLOBAL.md → ~/.claude/STACK_GLOBAL.md

Use answers from Block 2. Follow STACK_GLOBAL_TEMPLATE.md structure.

### 3. PROJECTS_SKILLS.md → ~/.claude/PROJECTS_SKILLS.md

Use answers from Blocks 3 + 4. Follow PROJECTS_SKILLS_TEMPLATE.md structure.
Include the standard Core Skills table (new-session, new-project, progress, update-context, health-check).

### 4. CLAUDE.md → ~/.claude/CLAUDE.md

Use the global template as base (dupla-workflow/global-templates/CLAUDE_GLOBAL_TEMPLATE.md if it exists).
Personalize: update the Identity section with what you learned about the user.
Keep behavior rules intact — only customize the "who is this person" part.

---

## Output (max 15 lines)

---
## Setup Complete — [name]

**Files created:**
- ~/.claude/CONTEXTO_[name].md
- ~/.claude/STACK_GLOBAL.md
- ~/.claude/PROJECTS_SKILLS.md
- ~/.claude/CLAUDE.md

**Next step:** run /health-check to verify everything is in order
---

## Rules

- Ask all questions ONCE in grouped blocks — not one by one
- Do NOT generate until all answers received
- Do NOT over-fill — keep files minimal and scannable
- If user skips a question → leave that section as [pending] in the file
