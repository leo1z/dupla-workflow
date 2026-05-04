---
doc: SURFACE_GUIDE
type: Reference
updated: 2026-05-03
purpose: What works in each environment — Terminal, IDE, Chat
---

# Dupla-Workflow: Capacidades por Entorno

> Consulta esta guía antes de un handoff para saber qué instrucciones dar al destino.

---

## Resumen rápido

| Capacidad | Claude Code IDE/CLI | Antigravity/Gemini | Cursor | Windsurf | GPT-4 API | Web Chat | Chat (OpenClaw) |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Skills (slash commands) | ✅ | ✅ (workflows) | ✅ | ⚠️ manual | ❌ | ❌ | ❌ |
| Hooks automáticos | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Leer archivos del proyecto | ✅ | ✅ (run_command) | ✅ | ✅ | ❌* | ❌* | ❌ |
| Handoff block | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Auto-snapshot docs/ | ✅ (hook) | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| sync-gemini automático | ✅ (hook) | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| MCP filesystem | ✅ (Node.js) | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| MCP fetch | ✅ (pip) | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Ejecutar shell | ✅ | ✅ (run_command) | ✅ | ✅ | ❌ | ❌ | ❌ |
| Identidad global (CLAUDE.md) | Auto | GEMINI.md auto | .cursor/rules/ | .windsurfrules | System prompt | Adjuntar | Pegar texto |

*Solo si el cliente permite adjuntar archivos.

---

## Claude Code — IDE Extension o CLI

**Capacidad: Completa**

Qué funciona:
- `/new-session`, `/checkpoint`, todos los 14+ skills como slash commands
- Hooks automáticos: Stop (checkpoint reminder, auto-snapshot), PreToolUse (guard), PostToolUse (sync-gemini), UserPromptSubmit (session reminder)
- Lectura de archivos del proyecto directamente
- MCP: filesystem (requiere Node.js) + fetch (requiere pip)
- Auto-snapshot de docs/ en cada Stop event
- Sync automático CLAUDE.md → GEMINI.md al escribir CLAUDE.md

Qué NO funciona:
- Nada relevante — capacidad plena

Para instalar:
```bash
bash bin/install.sh
```

Para usar handoff hacia aquí:
```
1. Nuevo chat en Claude Code (VS Code o terminal)
2. Pegar <handoff> block
3. Escribir: /new-session
```

---

## Antigravity / Gemini CLI

**Capacidad: Alta (sin hooks)**

Qué funciona:
- Skills como workflows en `~/.gemini/antigravity/global_workflows/` — escribir el nombre del skill
- `run_command`: Gemini puede ejecutar comandos de shell cuando se lo pides
- GEMINI.md se carga automáticamente (equivalente de CLAUDE.md)
- Handoff block: pegar al inicio del chat + "ejecuta new-session"
- Lectura de archivos vía run_command

Qué NO funciona:
- Hooks automáticos (ningún equivalente en Gemini CLI)
- Auto-snapshot → debe hacerse manual o via run_command
- sync-gemini → no aplica (Gemini es el destino, no la fuente)

Para usar handoff hacia aquí:
```
1. Abre Antigravity, selecciona Gemini
2. Nuevo chat
3. Pegar <handoff> block
4. Escribir: "Ejecuta new-session" (o simplemente el nombre del skill)
```

Nota: si el skill no se activa como slash command, Gemini lo lee como instrucción de texto — funciona igual.

---

## Cursor

**Capacidad: Media**

Qué funciona:
- Rules: `.cursor/rules/*.mdc` (Agent Mode) — cargadas automáticamente en cada chat
- Slash commands: archivos en `.cursor/commands/` invocados con `/comando` — requiere instalación via `install.sh`
- Lectura de archivos del proyecto en Agent Mode
- Ejecutar shell desde el IDE
- Handoff block: pegar al inicio del chat

Qué NO funciona:
- Hooks automáticos (no hay equivalente en Cursor)
- Auto-snapshot (manual — ejecutar `cp -r docs/ _versions/$(date +%F_%H-%M)/`)
- sync-gemini (manual — si cambias el archivo global, copiar manualmente)
- Chat Mode y Composer NO leen `.cursor/rules/` — usar Agent Mode

Para instalar skills en Cursor:
```bash
bash bin/install.sh   # detecta ~/.cursor automáticamente
```

Para usar handoff hacia aquí:
```
1. Abre Cursor + proyecto
2. Nuevo chat en AGENT MODE (importante)
3. Pegar <handoff> block
4. Escribir: /new-session
```

---

## Windsurf

**Capacidad: Media**

Qué funciona:
- `.windsurfrules` o `.windsurf/rules/*.md` con frontmatter `trigger: always_on` — reglas pasivas
- Workflows multi-step invocados con `@workflow-name` en Cascade
- Lectura de archivos del proyecto
- Ejecutar shell desde Cascade
- Handoff block funciona

Qué NO funciona:
- Hooks automáticos (no hay equivalente)
- Slash commands nativos como en Claude Code
- Auto-snapshot, sync-gemini (manual)

Para instalar reglas globales:
```bash
cp global-templates/CLAUDE_GLOBAL_TEMPLATE.md ~/.windsurfrules
# o bien en el proyecto:
cp global-templates/CLAUDE_GLOBAL_TEMPLATE.md .windsurfrules
```

Para usar handoff hacia aquí:
```
1. Abre Windsurf + proyecto
2. Nuevo chat en Cascade
3. Pegar <handoff> block + contenido de claude-progress.txt
4. Escribir: "@new-session" (si workflow instalado) o "ejecuta new-session"
```

---

## GPT-4 / OpenAI API

**Capacidad: Base**

Qué funciona:
- System prompt: pegar contenido de CLAUDE_GLOBAL_TEMPLATE.md como system prompt
- Handoff block: funciona como primer mensaje del usuario
- Adjuntar archivos: PROJECT_STATE.md + claude-progress.txt si el cliente lo permite

Qué NO funciona:
- Slash commands (ChatGPT Plus tiene Custom Instructions pero no es /comando estándar)
- Hooks automáticos
- Lectura automática de archivos del proyecto
- Auto-snapshot, sync

Para usar handoff hacia aquí:
```
1. Nuevo chat en ChatGPT o API playground
2. SYSTEM PROMPT: pegar contenido de ~/.claude/CLAUDE.md
3. PRIMER MENSAJE: pegar <handoff> block + "Continúa desde Next:"
4. Adjuntar docs/PROJECT_STATE.md si el cliente lo permite
5. Para skills: copiar el contenido del .md del skill y pegarlo como instrucción
```

---

## Claude.ai Web / ChatGPT Web

**Capacidad: Mínima**

Qué funciona:
- Adjuntar PROJECT_STATE.md + claude-progress.txt como archivos
- Pegar `<handoff>` block como texto
- Consultas rápidas o revisión de documentos

Qué NO funciona:
- Skills, hooks, slash commands
- Lectura automática del proyecto
- Cualquier automatización

Para usar handoff hacia aquí:
```
1. Nuevo chat
2. Adjuntar: docs/PROJECT_STATE.md y claude-progress.txt
3. Pegar: <handoff> block
4. Escribir: "Continúa desde el Next del handoff"
```

---

## Chat vía OpenClaw (WhatsApp / Slack / Telegram)

**Capacidad: Solo continuidad**

Qué funciona:
- Pegar `<handoff>` block como texto → el LLM retoma desde Next
- Pegar contenido de `claude-progress.txt` (cabe en un mensaje — ~30 tokens)
- Exportar el bloque `<session>` de PROJECT_STATE y pegarlo junto al handoff

Qué NO funciona:
- Leer archivos del proyecto automáticamente
- Hooks, slash commands, skills
- Ejecutar código

Para usar handoff hacia aquí:
```
1. Nuevo mensaje en el chat
2. Pegar: <handoff> block (texto plano)
3. Pegar: contenido de claude-progress.txt
4. Escribir: "Continúa desde Next:"
```

---

## Regla universal de handoff

Funciona en TODOS los entornos:

```
1. En el entorno actual: /checkpoint → opción Handoff
2. Copiar el bloque <handoff> generado
3. En el nuevo entorno: pegar el bloque + "continúa desde Next:"
4. El LLM leerá el bloque y retomará — sin perder contexto
```

El `<handoff>` block contiene todo lo necesario:
- Proyecto y path
- Branch actual
- Qué se completó
- Cuál es el próximo paso
- Instrucción de qué leer primero

---

## Lo que NUNCA requiere un entorno específico

Estas capacidades son universales porque son del LLM, no del entorno:

- Entender y seguir el sistema Dupla-Workflow
- Leer PROJECT_STATE.md cuando se pega como texto
- Aplicar ZOHAR, SEEQ, MOSCOW, OODA para priorizar
- Seguir el flujo de roles: Planificador → Implementador → Evaluador
- Generar handoff blocks válidos
- Adaptar respuestas según Mode (research / lite / full)
