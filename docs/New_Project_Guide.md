# New Project Guide

> Type: Static
> Purpose: Standard process to create and initialize a new project
> Last updated: [DATE TIME]

---

## Overview

This guide defines the exact workflow to go from idea → execution-ready project.

Follow steps in order. Do not skip.

---

## Step 1 — Generate Idea Draft (ChatGPT)

Use RESEARCH_PROMPT.md

Process:
1. Answer discovery questions
2. Generate Idea Draft
3. Ensure all Clarity Check = YES

Output:
- docs/IDEA_DRAFT.md

---

## Step 2 — Generate Plan (Claude — PLAN MODE)

Use PLAN_PROMPT.md

Input:
- docs/IDEA_DRAFT.md

Output:
- docs/ROADMAP.md
- docs/ARCHITECTURE.md

---

## Step 3 — Create Project (Script)

Run:

bash nuevo-proyecto.sh

or

bash nuevo-proyecto.sh --config my-project.config

This will:
- Create folder structure
- Initialize git
- Create base docs
- Setup repo

---

## Step 4 — Add Idea + Plan to Project

Ensure these files exist inside /docs:

- IDEA_DRAFT.md
- ROADMAP.md
- ARCHITECTURE.md

---

## Step 5 — Initialize with Claude

Run:

/new-project

This will:
- Read Idea + Roadmap
- Refine architecture if needed
- Initialize PROJECT_STATE.md
- Set first executable steps

---

## Step 6 — Start Working

Run:

/new-session

Claude will:
- Read PROJECT_STATE.md
- Propose next steps
- Execute tasks

---

## Rules

- Do NOT skip Idea Draft
- Do NOT skip validation (prototype phase)
- Always follow roadmap order
- Always use PROJECT_STATE.md as source of truth

---

## System Flow

Idea → Validation → Plan → Setup → Execute → Iterate