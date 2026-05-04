Inicia una investigación profunda usando sub-agentes exploradores en paralelo. Resume la información localmente sin saturar la memoria del chat.

**When to use:** When you need to explore a topic, compare libraries, or gather evidence before making a decision. Not for building — for knowing.
**See also:** `/knowledge-graph` (map doc relationships) · `/new-session mode:research` (full research session mode)

Usage:
  /research                → inicia una nueva investigación
  /research [topic]        → inicia investigación sobre un tema específico

---

## Execution

### Step 1 — Detect Topic and Goals

If topic is provided as an argument, use it.
If no topic provided, ask:
"¿Qué tema, mercado o problema quieres investigar profundamente?"

Ask follow-up:
"¿Cuáles son las 3 preguntas clave que quieres responder con esta investigación?"

### Step 2 — Parallel Exploration (Sub-agentes)

Una vez que tengas el tema y las preguntas:

**If subagents available (Claude Code / Antigravity con soporte multi-agente)**:
Lanza 2 o 3 sub-agentes en paralelo (usa la tool `Agent`). 
- Cada agente debe tener **Clean Windows** (solo la tarea específica y acceso a tools de navegación/lectura, sin contexto innecesario).
- Ejemplo: 
  - Agente 1 busca estado actual del mercado / tamaño.
  - Agente 2 busca competidores y alternativas.
  - Agente 3 busca opiniones de usuarios, discusiones en foros o papers técnicos.

**If subagents NOT available (Single-agent IDEs, Cursor, Chat)**:
Ejecuta la investigación de forma secuencial, paso a paso. Recuerda aplicar **Tool-Result Clearing** rigurosamente después de leer cada sitio o archivo grande para no saturar el contexto.

### Step 3 — Consolidate and Save

Cuando los agentes (o los pasos secuenciales) terminen, consolida los hallazgos.
**NO** imprimas todo el resultado gigante en el chat.
Genera un documento Markdown bien estructurado (apoyándote en el formato de `RESEARCH_PROMPT.md` si es útil) y guárdalo localmente:

- Si existe la carpeta `docs/`, guárdalo en `docs/RESEARCH_[tema_corto].md`.
- Si estás en un micro-proyecto (`QUICKSTATE.md`), guárdalo como un archivo `.md` adyacente o intégralo en la sección `## Notes`.

### Step 4 — Output (Resumen Ejecutivo)

Muestra un resumen ejecutivo corto en el chat (máximo 10 líneas):

```
✅ Investigación Completada — [Tema]

**Hallazgos Clave:**
- [Hallazgo 1 más importante]
- [Hallazgo 2 crítico]
- [Hallazgo 3 relevante]

📄 Documento detallado guardado en: [path/al/archivo.md]

Próximo paso: ¿Quieres usar esta información para actualizar tu ROADMAP o crear un nuevo proyecto (/new-project)?
```

---

## Rules

- **Context Engineering:** No pases tu historial de chat a los sub-agentes.
- **Tool-Result Clearing:** NUNCA mantengas múltiples sitios web o archivos grandes en tu memoria activa. Extrae el resumen (≤100 tokens) por cada fuente.
- **Spec-Driven:** El resultado principal de esta fase es el documento Markdown guardado, no el chorro de texto en el chat.
- Mantén la memoria limpia.
