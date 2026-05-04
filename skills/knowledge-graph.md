Generate a knowledge graph of the project docs for AI navigation and exploration.

**When to use:** After a new phase starts, when ARCHITECTURE.md changes significantly, or when `/health-check` shows graph is stale. Auto-runs via hook after each response.
**See also:** `/research` (explore external topics) · `/check-project` (validate doc accuracy, not structure)

Usage:
  /knowledge-graph          → generate graph from docs/ (full project)
  /knowledge-graph update   → regenerate after major doc changes
  /knowledge-graph open     → show path to graph.html (open in browser)

---

## What this does

Transforms `docs/*.md`, `CLAUDE.md`, `ARCHITECTURE.md`, and `ROADMAP.md` into three outputs:
- `docs/graph.html` — interactive visualization (open in browser, search nodes)
- `docs/graph.json` — machine-readable graph (AI can query relationships)
- `docs/GRAPH_REPORT.md` — key concepts, connections, and confidence tags

Powered by [graphify](https://github.com/safishamsi/graphify) — local processing, no API calls for markdown files.

---

## Phase 0 — Check Prerequisites

```bash
# Check if graphify is installed
graphify --version 2>/dev/null || python3 -m graphify --version 2>/dev/null
```

**If missing:**
```
⚠️ graphify no instalado.

Instalar:
  pip install graphify

Requiere: Python 3.8+ · pip

Después vuelve a correr /knowledge-graph
```

**If present:** proceed silently.

---

## Phase 1 — Select Scope

Detect what docs exist:
```bash
ls docs/*.md CLAUDE.md 2>/dev/null
```

Show scope before running:
```
Generando grafo desde:
  docs/PROJECT_STATE.md
  docs/ROADMAP.md
  [docs/ARCHITECTURE.md — si existe]
  [docs/SPEC.md — si existe]
  CLAUDE.md

Archivos excluidos: docs/code-review-graph.json, _versions/, docs/vision/
¿Continuar? [s/n]
```

---

## Phase 2 — Generate Graph

```bash
# Run from project root
graphify docs/ CLAUDE.md \
  --output docs/ \
  --format html,json,markdown \
  --ignore _versions "*.json" "vision/"
```

Silent while running. If it takes >10s, show: `⏳ Analizando relaciones entre documentos...`

---

## Phase 3 — Output

```
✅ Knowledge Graph generado

  docs/graph.html     → abre en navegador para explorar visualmente
  docs/graph.json     → legible por AI (Claude puede leer este archivo)
  docs/GRAPH_REPORT.md → resumen de conceptos clave + conexiones detectadas

Nodos encontrados: [N]
Relaciones detectadas: [N]
Confianza: EXTRACTED [N] · INFERRED [N] · AMBIGUOUS [N]

Para explorar: abre docs/graph.html en tu navegador
Para que el AI navegue: lee docs/GRAPH_REPORT.md al inicio de sesión
```

---

## How AI uses the graph

The graph makes it easier for any LLM to navigate a large project:

1. **At session start:** read `docs/GRAPH_REPORT.md` (~500 tokens) instead of reading all docs separately
2. **When building:** use `docs/graph.json` to understand which docs relate to each other before reading them
3. **For audits:** `/project-audit` reads `docs/graph.json` to map risk zones and dependencies

Add to SESSION loading strategy:
- If `docs/GRAPH_REPORT.md` exists → load it instead of full ARCHITECTURE.md when building
- It's ~5x more token-efficient than reading all docs individually

---

## When to regenerate

Regenerate (`/knowledge-graph update`) when:
- A new phase starts (ROADMAP updated)
- ARCHITECTURE.md changed significantly
- New skills or major docs added
- `/health-check` shows graph is stale (lastCommit mismatch)

Add to `docs/.gitignore` if graph.html is too large (>500KB):
```
# Optional: ignore generated graph files
docs/graph.html
```
Keep `docs/graph.json` and `docs/GRAPH_REPORT.md` in git — they're small and useful for AI.

---

## Rules

- Never overwrite existing graph without confirmation (user may have customized it)
- Always show node count + confidence breakdown in output
- If graphify errors on a file → skip that file, log warning, continue
- graph.json and GRAPH_REPORT.md go to git; graph.html is optional (can be large)
