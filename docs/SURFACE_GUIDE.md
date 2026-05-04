---
doc: SURFACE_GUIDE
type: Reference
updated: 2026-05-03
purpose: Qué puedes hacer en cada entorno — IDE, Terminal, Chat. Cómo se complementan.
---

# Dupla-Workflow: Guía por Entorno

> Lee esto antes de empezar, cambiar de herramienta, o hacer un handoff.

---

## La idea central

Dupla-Workflow es un **arnés de markdown** — el workflow vive en archivos `.md`, no en el LLM ni en el IDE. Eso significa que funciona en cualquier entorno. Lo que cambia es cuánta automatización tienes disponible.

```
Más automatización ──────────────────────────────────────── Más manual
Claude Code IDE/CLI  │  Antigravity/Gemini  │  Cursor  │  Chat/Web
  Skills + Hooks     │    Skills + Shell    │  Skills  │  Solo texto
```

---

## Tabla: qué funciona dónde

| Capacidad | Claude Code IDE/CLI | Antigravity/Gemini | Cursor | Windsurf | GPT/Web Chat |
|---|:---:|:---:|:---:|:---:|:---:|
| **Skills** (`/comando`) | ✅ nativo | ✅ workflows | ✅ `.cursor/commands/` | ⚠️ `@workflow` | ❌ pegar texto |
| **Hooks automáticos** | ✅ 4 tipos | ❌ | ❌ | ❌ | ❌ |
| **Checkpoint reminder** | ✅ automático | ❌ manual | ❌ manual | ❌ manual | ❌ manual |
| **Auto-snapshot docs/** | ✅ en cada Stop | ❌ | ❌ | ❌ | ❌ |
| **Leer archivos proyecto** | ✅ directo | ✅ run_command | ✅ Agent Mode | ✅ Cascade | ⚠️ adjuntar |
| **Ejecutar shell** | ✅ | ✅ run_command | ✅ | ✅ | ❌ |
| **Agentes paralelos** | ✅ nativo | ⚠️ run_command | ⚠️ múltiples tabs | ❌ | ❌ |
| **Handoff block** | ✅ | ✅ | ✅ | ✅ | ✅ pegar texto |
| **Identidad global** | Auto (CLAUDE.md) | Auto (GEMINI.md) | `.cursor/rules/` | `.windsurfrules` | Pegar al inicio |
| **MCP filesystem** | ✅ Node.js | ❌ | ❌ | ❌ | ❌ |
| **MCP fetch (internet)** | ✅ pip | ❌ | ❌ | ❌ | ❌ |
| **sync CLAUDE→GEMINI** | ✅ automático | — | ❌ manual | ❌ manual | ❌ |

---

## Por entorno: qué puedes hacer, qué no, cómo compensar

---

### Claude Code — IDE (VS Code) o Terminal CLI

**Nivel: Completo** — es el entorno de referencia del sistema.

**Puedes:**
- Todos los skills como `/comando` — `/new-session`, `/checkpoint`, `/new-project`, etc.
- Hooks automáticos activos en background:
  - `Stop` → checkpoint reminder si hay commits sin guardar
  - `Stop` → auto-snapshot de `docs/` en `_versions/`
  - `PreToolUse(Write)` → guard: bloquea writes si no hay `PROJECT_STATE.md`
  - `PostToolUse(Write)` → sync automático `CLAUDE.md` → `GEMINI.md`
  - `UserPromptSubmit` → avisa si el estado tiene >24h de antigüedad
- Subagentes paralelos nativos (Agent tool)
- MCP filesystem (leer archivos automáticamente sin Read tool)
- MCP fetch (acceso a internet para research)

**No puedes:**
- Nada relevante — capacidad plena.

**Para instalar:**
```bash
git clone https://github.com/leo1z/dupla-workflow.git ~/Projects/dupla-workflow
bash ~/Projects/dupla-workflow/bin/install.sh
```

**Handoff entrante:**
```
1. Abre VS Code + Claude Code extension, o terminal con claude
2. Navega al proyecto: cd ~/Projects/mi-proyecto
3. Nuevo chat → pega el <handoff> block
4. Escribe: /new-session
```

---

### Antigravity / Gemini CLI

**Nivel: Alto** — funciona sin hooks, todo lo demás disponible.

**Puedes:**
- Skills como workflows — escribes el nombre del skill o lo invocas (ej: `new-session`)
- `GEMINI.md` se carga automáticamente (equivalente de `CLAUDE.md`)
- `run_command` — Gemini puede ejecutar shell cuando se lo pides
- Leer archivos del proyecto vía `run_command cat docs/PROJECT_STATE.md`
- Handoff block funciona igual que en Claude Code

**No puedes:**
- Hooks automáticos (no existe equivalente)
- Auto-snapshot → hacer manual: `cp -r docs/ _versions/$(date +%F_%H-%M)/`
- sync-gemini automático → no aplica (Gemini es el destino)

**Compensación:** antes de cerrar sesión, ejecuta manualmente:
```bash
run_command: git add . && git commit -m "checkpoint: [descripción]"
```

**Handoff entrante:**
```
1. Abre Antigravity → selecciona Gemini
2. Nuevo chat → pega el <handoff> block
3. Escribe: "Ejecuta new-session" (o el nombre del skill directamente)
```

---

### Cursor

**Nivel: Medio** — skills disponibles, sin hooks automáticos.

**Puedes:**
- Skills como `/comando` en **Agent Mode** — requieren `.cursor/commands/*.md` instalado
- Rules en `.cursor/rules/*.mdc` — se cargan automáticamente en Agent Mode
- Leer archivos del proyecto en Agent Mode
- Ejecutar shell desde el IDE
- Handoff block funciona (pegar al inicio del chat)

**No puedes:**
- Hooks automáticos
- Auto-snapshot y sync-gemini → manuales
- **Chat Mode y Composer NO leen `.cursor/rules/`** — siempre usar Agent Mode

**Compensación:** usa `/checkpoint` manualmente al final de cada sesión. Configura un atajo de teclado si lo usas mucho.

**Para instalar:**
```bash
bash bin/install.sh   # detecta ~/.cursor automáticamente
```

**Handoff entrante:**
```
1. Abre Cursor + proyecto
2. Nuevo chat en AGENT MODE (crítico — no Chat Mode)
3. Pega el <handoff> block
4. Escribe: /new-session
```

---

### Windsurf

**Nivel: Medio** — reglas pasivas + workflows invocables.

**Puedes:**
- `.windsurfrules` o `.windsurf/rules/*.md` con `trigger: always_on` — Cascade los lee siempre
- Workflows en `.windsurf/workflows/` invocados con `@nombre-workflow`
- Leer archivos del proyecto en Cascade
- Ejecutar shell desde Cascade
- Handoff block funciona

**No puedes:**
- Slash commands nativos (`/comando`)
- Hooks automáticos
- Auto-snapshot, sync-gemini → manuales

**Para instalar reglas:**
```bash
cp global-templates/CLAUDE_GLOBAL_TEMPLATE.md .windsurfrules
```

**Handoff entrante:**
```
1. Abre Windsurf + proyecto → Cascade
2. Pega el <handoff> block
3. Escribe: "@new-session" o "ejecuta new-session"
```

---

### GPT-4 / OpenAI (API o ChatGPT)

**Nivel: Base** — funciona con texto plano y adjuntos.

**Puedes:**
- System prompt: pegar contenido de `CLAUDE_GLOBAL_TEMPLATE.md`
- Handoff block como primer mensaje
- Adjuntar `docs/PROJECT_STATE.md` + `claude-progress.txt` si el cliente lo permite
- Usar skills como texto: copiar el contenido del `.md` del skill y pegarlo como instrucción

**No puedes:**
- Slash commands, hooks, automatizaciones
- Leer archivos automáticamente

**Handoff entrante:**
```
1. Nuevo chat
2. SYSTEM PROMPT: contenido de ~/.claude/CLAUDE.md
3. PRIMER MENSAJE: <handoff> block + "Continúa desde Next:"
4. Adjunta: docs/PROJECT_STATE.md (si el cliente lo permite)
```

---

### Claude.ai Web / ChatGPT Web

**Nivel: Mínimo** — solo continuidad de contexto.

**Puedes:**
- Adjuntar `PROJECT_STATE.md` + `claude-progress.txt`
- Pegar `<handoff>` block como texto
- Consultas rápidas o revisión de documentos

**No puedes:**
- Skills, hooks, slash commands, automatizaciones
- Leer el proyecto automáticamente

**Handoff entrante:**
```
1. Nuevo chat
2. Adjunta: docs/PROJECT_STATE.md y claude-progress.txt
3. Pega: <handoff> block
4. Escribe: "Continúa desde el Next del handoff"
```

---

### Chat vía OpenClaw / WhatsApp / Slack / Telegram

**Nivel: Solo continuidad** — ideal para consultas rápidas o desbloquearse.

**Puedes:**
- Pegar `<handoff>` block como texto → el LLM retoma desde Next
- Pegar contenido de `claude-progress.txt` (~30 tokens — cabe en un mensaje)
- Consultas de decisión rápida ("¿qué hago con X?")

**No puedes:**
- Leer archivos del proyecto
- Hooks, skills, ejecutar código

**Handoff entrante:**
```
1. Mensaje nuevo
2. Pega: <handoff> block (texto plano)
3. Pega: contenido de claude-progress.txt
4. Escribe: "Continúa desde Next:"
```

---

## Cómo se complementan los entornos

El flujo típico de trabajo combina los entornos según la tarea:

```
┌─────────────────────────────────────────────────────────────┐
│                    FLUJO DE TRABAJO REAL                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  CONSTRUIR / DEBUGGEAR          → Claude Code IDE/CLI       │
│  (hooks automáticos, agentes,     capacidad completa        │
│   commits, lectura de archivos)                             │
│                                                             │
│  INVESTIGAR / ANALIZAR          → Antigravity/Gemini        │
│  (research de mercado, review      run_command disponible   │
│   de código, segunda opinión)                               │
│                                                             │
│  REVISAR / EDITAR               → Cursor o Windsurf         │
│  (Agent Mode, rules automáticas,   sin hooks pero skills OK │
│   refactoring con contexto)                                 │
│                                                             │
│  CONSULTAR / DESBLOQUEARSE      → Chat (web, móvil)         │
│  (pregunta rápida, handoff        solo texto + adjuntos     │
│   en movimiento)                                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Regla de oro:** el estado vive en `docs/PROJECT_STATE.md` y `git` — no en el LLM. Cambiar de herramienta no rompe nada si usas `/checkpoint` antes de salir.

---

## Regla universal de handoff

Funciona en **todos** los entornos:

```
1. En el entorno actual: /checkpoint → opción Handoff
2. Copiar el bloque <handoff> generado
3. En el nuevo entorno: pegar el bloque + escribir /new-session
4. El LLM leerá el bloque y retomará sin perder contexto
```

El `<handoff>` block contiene:
- Proyecto y path local
- Branch actual
- Qué se completó
- Cuál es el próximo paso exacto

---

## Trabajo Multi-Agente Paralelo

| Entorno | Cómo lanzar agentes paralelos |
|---|---|
| Claude Code | Agent tool nativa — `run_in_background: true` para tareas independientes |
| Antigravity | `run_command` múltiples — pedir a Gemini que los ejecute en el mismo turno |
| Cursor | Múltiples chats (tabs) en Agent Mode — cada uno en su rama/tarea |
| Web Chat | No soporta paralelismo — secuencial con handoff blocks |

**Patrón: Planificador → Implementadores → Evaluador**

```
1. Planificador: lee PROJECT_STATE + fase → divide trabajo en tareas independientes
2. Implementadores: cada subagente recibe tarea + rama + archivos a tocar
3. Evaluador: /health-check al final → verifica coherencia antes del merge
```

**Regla:** cada agente paralelo necesita su propio contexto completo. No asumas que un subagente sabe lo que hizo el otro.

---

## Lo que funciona en TODOS los entornos

Estas capacidades son del LLM, no del IDE — universales:

- Leer `PROJECT_STATE.md` cuando se pega o adjunta
- Seguir el workflow: `/new-session` → trabajo → `/checkpoint`
- Generar y consumir `<handoff>` blocks válidos
- Aplicar ZOHAR, SEEQ, MOSCOW, OODA para priorizar
- Seguir el flujo de roles: Planificador → Implementador → Evaluador
- Evaluar madurez de idea (IML) y recomendar stack
- Actualizar ROADMAP dinámicamente en `/checkpoint`
