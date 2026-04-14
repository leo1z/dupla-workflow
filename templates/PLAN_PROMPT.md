You are in PLAN MODE.

Input:
docs/IDEA_DRAFT.md

Goal:
Generate:
1) docs/ROADMAP.md (dynamic execution guide)
2) docs/ARCHITECTURE.md (evolving system design)

---

## Rules (CRITICAL)

- Assume Idea Draft is correct
- Do NOT redo research
- Do NOT ask questions
- Be concise
- No long explanations
- Optimize for minimal tokens
- Avoid redundancy
- PROJECT_STATE.md will be source of truth (not roadmap)
- Do NOT over-specify roadmap (execution will be defined later in PROJECT_STATE)

---

## Core Strategy

1. Extract core flow
2. Validate via prototype
3. Decide technical direction AFTER validation
4. Build MVP
5. Optimize

---

## Step 1 — Extract Core

Identify:
- Core flow
- MVP features
- Validation requirements

Reduce scope if needed.

---

## Step 2 — Generate ROADMAP.md

Generate EXACT structure:

# Roadmap — [PROJECT_NAME]

> Type: Dynamic (update if direction changes)
> Used: /new-session, /update-context
> Last updated: [DATE TIME]

---

## Objective

- Prototype success:
- MVP success:

---

## Phases

### 1. Planning
- Define scope
- Define core flow

---

### 2. Prototype (Validation)
- Build fast
- Focus only on core flow
- Use mocks

Checkpoint:
- Works? YES/NO
- Useful? YES/NO
- Decision: proceed/pivot/stop

---

### 3. Technical Direction
- Choose stack (simple)
- Define approach

---

### 4. Development (MVP)
- Build real system
- Replace mocks

---

### 5. Validation
- Test flows
- Fix bugs

---

### 6. Deployment
- Setup + deploy

---

### 7. Optimization
- Improve

---

## Rules

- PROJECT_STATE overrides this
- Update only when direction changes
- Do not over-specify

---

## Step 3 — Generate ARCHITECTURE.md

Generate EXACT structure:

# Architecture — [PROJECT_NAME]

> Type: Dynamic (updated via /progress and /update-context)
> Used: building + system changes
> Last updated: [DATE TIME]

---

## Strategy

Prototype → Validate → Build → Scale

---

## 1. Prototype Architecture

### Purpose
Validate core flow fast

### Stack
[minimal tools]

### Components
- UI
- Logic
- Mock/Data

### Data Flow
User → UI → Logic → Response

---

## 2. Production Architecture (MVP)

### Purpose
Real system

### Stack
[practical stack]

### Components
- Frontend
- Backend/API
- Database
- Services

### Data Flow
User → Frontend → Backend → DB → Response

---

## 3. Evolution

- What changes from prototype
- What gets replaced
- What gets added

---

## Rules

- High-level only
- No code
- No over-engineering
- Must evolve with system

---

## Template Usage (CRITICAL)

Templates are located in /templates.

Naming convention:
[TARGET]_TEMPLATE.md

Mapping:

- CLAUDE_TEMPLATE.md → CLAUDE.md (project root, NOT docs/)
- PROJECT_STATE_TEMPLATE.md → docs/PROJECT_STATE.md
- PROBLEMS_TEMPLATE.md → docs/PROBLEMS.md
- CREDENTIALS_TEMPLATE.md → docs/CREDENTIALS.md

Rules:

- Always follow template structure
- Do NOT create new formats
- Keep docs minimal and consistent

---

## Output

Return ONLY:

1. docs/ROADMAP.md
2. docs/ARCHITECTURE.md