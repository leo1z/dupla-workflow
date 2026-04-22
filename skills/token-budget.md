Token budget awareness for the current session. Warns before expensive actions and proposes lighter alternatives.

Usage: /token-budget [remaining%]
  - No argument → assume 100% budget (session start)
  - /token-budget 50 → you have ~50% left
  - /token-budget check → estimate current burn without changing budget

---

## Step 1 — Set budget context

If argument provided: set BUDGET = that value.
If no argument: set BUDGET = 100%.

Reference limits (Pro $20 plan — 5h window):
- Total: ~44,000 tokens per session
- 10–40 prompts depending on complexity
- Weekly cap: ~40–80 Sonnet-hours
- Heavy consumers: subagents, Opus, large parallel file reads

Compute estimated tokens remaining:
- 100% → ~44,000 tokens
- 75%  → ~33,000 tokens
- 50%  → ~22,000 tokens
- 25%  → ~11,000 tokens

---

## Step 2 — Read session goal

Read docs/PROJECT_STATE.md → extract Current Goal.
If no PROJECT_STATE → ask: "¿Cuál es el objetivo de esta sesión?" (ONE question)

Classify goal scope:
- **Focused** (fix bug, edit 1 file, short answer) → target <20% per action
- **Medium** (add feature, refactor module) → target <35% per action
- **Broad** (architecture review, multi-file refactor) → target <50% per action

---

## Step 3 — Classify action cost

Before executing any user request, classify it:

| Tier | Cost estimate | Examples |
|------|--------------|---------|
| Light (L) | ~500–2k tokens | Edit 1 file, short answer, git status |
| Medium (M) | ~2k–8k tokens | Read 3–5 files, write new file, run tests |
| Heavy (H) | ~8k–20k tokens | Subagent (Explore/Plan), read 10+ files, full refactor |
| Critical (C) | ~20k+ tokens | Multi-agent pipeline, whole-codebase scan, Opus model |

---

## Step 4 — Budget gate

Before executing:

1. Estimate action tier (L/M/H/C)
2. Compute % of remaining budget the action will consume
3. Apply rule:

```
IF action_cost_% > 40% of remaining budget:
  → WARN before executing
  → Show: estimated cost, remaining budget, % consumed
  → Propose 1–2 lighter alternatives
  → Ask: "¿Procedemos o usamos la alternativa?"

IF remaining budget < 25% AND action is H or C:
  → BLOCK + explain
  → Only propose Light alternatives
  → Suggest: save this for next session
```

---

## Step 5 — Output format

When warning:

---
⚠️ **Budget Warning**

**Acción solicitada:** [descripción]
**Costo estimado:** [L/M/H/C] — ~[X]% del presupuesto restante
**Presupuesto restante:** ~[X]% (~[tokens] tokens)
**Meta de sesión:** [Current Goal]

**Alternativa(s):**
- [Opción más ligera que logra el mismo objetivo]
- [Opción 2 si aplica]

**Para el resto de esta sesión — prompts que funcionan bien:**
[Lista de 2–3 tipos de prompts eficientes según el budget restante y la meta — ver tabla de Prompt Guide]

**Evitar hasta la próxima sesión:**
[Lista de 1–3 cosas concretas que no conviene hacer con el budget restante]

¿Procedemos con la original o usamos la alternativa? [original/alt1/alt2]
---

When budget is healthy (action < 25% of remaining):
→ Execute directly, no warning needed.

---

## Prompt Guide by budget level

Use this to fill "prompts que funcionan bien" and "evitar" in warnings.

### Budget 75–100% — Sin restricciones
**Prompts OK:**
- Cualquier tipo de tarea
- Subagents para exploración amplia
- Refactors grandes, lectura de muchos archivos
- "Explora el codebase y dime..."

**Evitar:** nada en particular

---

### Budget 50–74% — Uso consciente
**Prompts OK:**
- Tareas enfocadas en 1–3 archivos
- "Edita [archivo] para que..." (en lugar de "revisa todo el módulo")
- Preguntas directas con contexto ya cargado
- Fixes puntuales con archivo + línea especificados

**Evitar:**
- Subagents de exploración (Explore/Plan agents)
- "Revisa todo el proyecto y busca..."
- Cambiar de tema drásticamente (acumula contexto)

---

### Budget 25–49% — Modo conservador
**Prompts OK:**
- Un solo cambio por prompt ("cambia X en archivo Y")
- Preguntas que no requieren leer archivos nuevos
- Commits, git status, comandos cortos
- "En [archivo]:[línea], cambia [X] por [Y]"

**Evitar:**
- Cualquier subagent
- Leer archivos nuevos que no sean estrictamente necesarios
- Tareas con múltiples pasos encadenados en un solo prompt
- Preguntas abiertas ("¿cómo mejorarías...?")

**Diferir a próxima sesión:**
- Refactors
- Revisiones de arquitectura
- Cualquier tarea que requiera explorar código desconocido

---

### Budget < 25% — Solo cierre de sesión
**Prompts OK:**
- Commits y git push
- Actualizar PROJECT_STATE.md (para /progress)
- Preguntas de 1 línea con respuesta de 1 línea
- "¿Qué quedó pendiente para la próxima sesión?"

**Evitar todo lo demás.** Correr `/checkpoint close` y cerrar.

**Diferir a próxima sesión:** todo lo que no sea guardar estado.

---

## Rules

- This skill estimates — does NOT have access to real token counter
- When in doubt, classify UP (prefer conservative estimate)
- Never block Light actions regardless of budget
- If user says "ignore budget" → execute without warning for rest of session
- Subagents (Agent tool) always classify as H or C — always warn
- Reading files with Glob that returns 50+ results → classify as H
- Parallel tool calls count as sum of individual costs
- Prompt Guide se muestra SOLO en warnings — no en ejecución normal
