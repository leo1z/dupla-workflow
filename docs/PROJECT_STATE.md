---
doc: PROJECT_STATE
updated: 2026-04-22
status: CURRENT
project_type: individual
---

# Project State — Dupla-Workflow

<session>
Updated: 2026-05-04 (sesión 11)
Status: ACTIVE
Mode: full
Phase: N/A
Phase_Status: N/A
Done: Implementado Fast-Track en AGENTS.md, creado comando /research, limpiado HOW_IT_WORKS.md (HITL, borrado /zohar), archivados PDFs/HTMLs y Wishlist.
Next: Publicar versión v2.5.0 con las mejoras de seguridad, research y fast-track.
Blockers: none
Branch: work
Model: gemini
Handoff: no
</session>

<handoff>
Date: 2026-05-03
From: Claude (sesión 8) → To: Next session
Project: dupla-workflow at c:\Users\Leo Borjas\Projects\dupla-workflow
Goal: Dupla-Workflow como Agentic Harness — LLM-agnostic, multi-surface
Branch: work
Done: 3 sprints completos (990d906, ee0036d, 75698dc, 3c232c6) — todos los hooks corregidos, install.sh multi-IDE, checkpoint multi-destino, SURFACE_GUIDE.md creado, CLAUDE_GLOBAL_TEMPLATE agnóstico
Next: Validar con bash bin/install.sh en máquina local, luego git merge work → master
Context: Leer docs/PROJECT_STATE.md → session block. Plan en ~/.claude/plans/dupla-workflow-sprint-plan.md (Sprint 3 marcado completo).
</handoff>

---

## Current Goal

Framework listo para distribución y uso diario en todos los proyectos.

---

## Next Steps

- [ ] **Must:** Onboardear colaboradores (compartir repo + instrucciones)
- [ ] **Should:** Usar /new-session en dupla-conecta para validar flujo real
- [ ] **Could:** Documentar casos de uso avanzados (team workflow real)

---

## Blockers

- none
- *(pendiente menor: confirmar path Antigravity en macOS — no bloquea trabajo)*

---

## Recent Changes

- 2026-05-03 — sesión 8: Sprint 3 completo — LLM-agnostic hardening · hooks 4 fixes · install.sh Cursor + merge-safe · checkpoint multi-destino · SURFACE_GUIDE.md · setup-dupla/update-dupla multi-IDE · CLAUDE_GLOBAL_TEMPLATE doc:GLOBAL_BEHAVIOR
- 2026-04-27 — sesión 7: /new-project validation gate + Plan Mode + lenguaje accesible · /update-dupla check mode · README one-liner installer
- 2026-04-22 — sesión 6: v2.4.0 Antigravity completo — global_workflows + GEMINI.md + .agents/rules/ + todos los docs alineados
- 2026-04-22 — sesión 5: Antigravity detection fix (Windows ~/.gemini/antigravity/) + skills a knowledge/ + ANTIGRAVITY_DIR override
- 2026-04-22 — sesión 4: CLAUDE.md repo + quick-start fix + adapt-project clarificado en guías
- 2026-04-22 — v2.3.0 sesión 2: QUICKSTART.html + SYSTEM_MAP.html + graph lifecycle en skills
- 2026-04-22 — v2.3.0: micro mode, roadmap phase awareness, handoff persistence, hooks throttle
- 2026-04-22 — v2.2.0: team mode, 18 gaps, hooks deployment, slash commands
- 2026-04-21 — v2.1.0: health-check, MCP, update migration, handoff guide

---

## References

→ Roadmap: README.md (versiones + features)
→ Changelog: CHANGELOG.md
→ Skills: ~/.claude/skills/ · ~/.claude/commands/
→ Templates: templates/
