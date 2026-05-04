# Dupla OS — Guía Completa: Instalar, Usar y Cómo Funciona

Dupla OS es un **arnés de Markdown para agentes de IA** (Claude, Gemini, Cursor). El workflow vive en archivos `.md`, no en el chat. Si cierras el chat, no pierdes nada.

---

## 1. User Journey — Del Zero al Sistema Funcionando

### Paso 1 — Primera instalación (una vez por máquina)

**Requisitos:** Claude Code instalado + Git + Python3 (requerido en Windows para hooks)

```bash
git clone https://github.com/leo1z/dupla-workflow.git ~/Projects/dupla-workflow
bash ~/Projects/dupla-workflow/bin/install.sh
```

El script hace:
- Detecta IDEs instalados (Claude Code, Antigravity, Cursor) — si no hay ninguno, para con error
- Despliega 15 skills a `~/.claude/skills/` y `~/.claude/commands/`
- Registra 6 hooks en `~/.claude/settings.json`
- Muestra al final si `CLAUDE.md` falta → indica el siguiente paso obligatorio

**Si `CLAUDE.md` no existe o está vacío → el sistema no funciona aún. Ir al Paso 2.**

---

### Paso 2 — Configurar identidad global (una vez, en Claude Code)

```
/setup-dupla
```

Hace una entrevista de 10 preguntas en un solo mensaje (nombre, stack, proyectos, plugins). Genera:
- `~/.claude/CLAUDE.md` — identidad y reglas del agente
- `~/.claude/SYSTEM.md` — stack y proyectos
- `~/.claude/MEMORY_GLOBAL.md` — aprendizajes cross-proyecto
- Sincroniza a `~/.gemini/GEMINI.md` si Antigravity está instalado

**Si Python3 no está instalado en Windows → `/setup-dupla` lo detecta y para. Los hooks requieren Python3.**

---

### Paso 3 — Inicializar un proyecto

**Proyecto nuevo:**
```
/new-project
```
Genera `docs/ROADMAP.md`, `docs/PROJECT_STATE.md`, `docs/ARCHITECTURE.md` con assessment IML.

**Proyecto existente:**
```
/adapt-project
```
Onboarding de repo existente. Preserva lo que tienes, agrega estructura Dupla.

**Sesión rápida / sin proyecto:**
```
/quick-start
```
Crea `QUICKSTATE.md` (~80 tokens). Para scripts, experimentos, tareas no-código.

---

### Paso 4 — Flujo diario

```
/new-session  →  TRABAJO  →  /checkpoint
```

Eso es todo. El resto es opcional.

**Context Reset — regla física:** al cerrar una sesión, cierra el chat completamente y abre uno nuevo. No comprimas en la misma ventana indefinidamente. `/compact` ayuda, pero no reemplaza un reset completo. Chats frescos = contexto limpio = menos tokens = menos errores de "ansiedad de contexto".

---

### Paso 5 — Verificar que todo funciona

```
/health-check
```

Verifica: tools, skills, hooks, CLAUDE.md con contenido real, GEMINI.md sincronizado, PROJECT_STATE actualizado. Muestra exactamente qué está roto y cómo arreglarlo.

---

## 2. ¿Cuándo usar qué skill?

| Situación | Skill |
|---|---|
| Empezar a trabajar | `/new-session` |
| Terminar sesión o cambiar de modelo | `/checkpoint` |
| Primer install en una máquina | `/setup-dupla` |
| Verificar que el sistema está OK | `/health-check` |
| Proyecto nuevo desde cero | `/new-project` |
| Repo existente, agregar Dupla | `/adapt-project` |
| Proyecto pequeño / sin docs | `/quick-start` |
| Docs desactualizados, sincronizar | `/check-project` |
| Sesión pesada (>10 sesiones) | `/compact` |
| Investigar un tema antes de decidir | `/research` |
| Revertir a un punto anterior | `/restore` |
| Actualizar Dupla a nueva versión | `/update-dupla` |
| Proyecto con varios devs | `/adapt-to-team` + `/add-team-member` |
| Ver grafo de dependencias de docs | `/knowledge-graph` |

---

## 3. Principios de Ingeniería de Contexto

- **Clean Windows** — cada subagente arranca con contexto mínimo: tarea + archivos exactos + herramientas permitidas. Sin historial, sin ruido.
- **Tool-Result Clearing** — después de leer un archivo grande (>500 tokens), se retiene solo el resumen. El texto original se descarta.
- **Spec-Driven** — nada se implementa sin estar en `ROADMAP.md` primero.
- **Zero-Complacency** — el Evaluador exige un comando o test que confirme que la solución funciona. Leer el código no cuenta.
- **Human-in-the-Loop** — el sistema se pausa ante cualquier acción destructiva: `git push` a main, `rm -rf`, escribir en `~/.claude/`. Pide `[Y/N]` explícito.

---

## 4. Cómo Funciona el Loop de Sesión

```
/new-session                        /checkpoint
     │                                   │
     ▼                                   ▼
Lee <session> (~60 tokens)     Actualiza <session>
     │                                   │
     ▼                                   ▼
Carga condicional:             Commit → push → handoff
  plan/decide → ROADMAP
  build/code  → ARCHITECTURE
  fix/error   → PROBLEMS
  (nada más)  → solo session
     │
     ▼
  TRABAJO
(skills on-demand, hooks en background)
```

**Sin Dupla:** un LLM típico lee 3-5 docs por sesión = 2000-5000 tokens solo para entender contexto.
**Con Dupla:** ~1260 tokens de arranque (CLAUDE.md global + project + session block). El resto es condicional.

---

## 5. Los Tres Agentes (Conceptuales)

Dupla OS coordina tres roles, aunque uses un solo chat:

1. **Planificador** — lee el estado, decide la siguiente jugada, asigna trabajo atómico
2. **Implementador** — recibe tarea atómica, la ejecuta sin contexto adicional, devuelve solución
3. **Evaluador** — trata de romper la solución. Exige prueba determinista antes de declarar done

---

## 6. Hooks Automáticos — Lo que Corre en Background

Los hooks corren fuera del contexto — no consumen tokens del chat, no aparecen como respuestas.

| Hook | Trigger | Qué hace |
|---|---|---|
| `suggest-checkpoint.sh` | Stop (fin de respuesta) | Avisa si hay cambios sin commit |
| `auto-snapshot.sh` | Stop | Backup de `docs/` en `_versions/<timestamp>/` |
| `auto-knowledge-graph.sh` | Stop | Regenera `docs/code-review-graph.json` |
| `guard-project-state.sh` | PreToolUse(Write) | Bloquea escrituras si no hay `PROJECT_STATE.md` |
| `hitl-guard.sh` | PreToolUse(Bash) | Para y pide `[Y/N]` ante comandos destructivos |
| `session-reminder.sh` | UserPromptSubmit | Avisa si el estado tiene >24h de antigüedad |
| `sync-gemini.sh` | PostToolUse(Write) | Sincroniza `~/.claude/CLAUDE.md` → `~/.gemini/GEMINI.md` |

**Tipos de hook por comportamiento:**
- `suggest-checkpoint` y `session-reminder` son **advisory** (exit 0) — imprimen recordatorios, no bloquean. Si cierras el chat sin hacer commit, pierdes el trabajo no guardado.
- `guard-project-state.sh` y `hitl-guard.sh` son **blocking** (exit 1) — detienen la ejecución. Son las guardas reales.
- `sync-gemini.sh` solo sincroniza cuando Claude usa el Write tool — ediciones externas a `CLAUDE.md` no disparan el sync. Usa `/health-check` para detectar drift.

**Política fail-closed (v2.5.0+):**
`hitl-guard.sh` y `guard-project-state.sh` ahora son **fail-closed**: si Python3 y jq no están instalados, bloquean con error en lugar de permitir la acción. Esto protege la política Zero-Trust incluso cuando falta la dependencia de parseo JSON.

---

## 7. Dónde Viven los Datos

```
~/.claude/
  CLAUDE.md               ← identidad global (siempre en contexto, ~1000 tokens/turno)
  SYSTEM.md               ← stack y proyectos (solo si lo pides)
  MEMORY_GLOBAL.md        ← aprendizajes cross-proyecto (solo si debugging)
  skills/*.md             ← 15 slash commands (0 tokens hasta invocar)
  hooks/*.sh              ← 7 automaciones (corren fuera del contexto)
  settings.json           ← hooks registrados
  DUPLA_VERSION           ← versión instalada

docs/ (dentro de tu proyecto)
  PROJECT_STATE.md ⭐     ← fuente de verdad. <session> block: ~60 tokens
  ROADMAP.md              ← plan por fases con outcomes y GO/NO-GO
  ARCHITECTURE.md         ← decisiones técnicas (solo si aplica)
  PROBLEMS.md             ← bugs conocidos (solo si aplica)
  HOW_IT_WORKS.md         ← esta guía (solo dupla-workflow)
  SURFACE_GUIDE.md        ← qué funciona en cada entorno
  code-review-graph.json  ← grafo de dependencias (auto-generado por hook)

_versions/                ← snapshots automáticos de docs/ (por hook)
claude-progress.txt       ← lista de tareas [ ] [>] [x] de la sesión

.agents/rules/claude.md   ← reglas del proyecto para Gemini (trigger: always_on)
```

`PROJECT_STATE.md` es compartido entre Claude y Gemini — ambos leen el mismo archivo. No se duplica.

---

## 8. Antigravity (Gemini) — Diferencias Clave

Si usas Antigravity/Gemini CLI como entorno principal, el flujo es diferente:

**Los skills NO son slash commands.** Escribe el nombre del skill como texto:
- ❌ `/new-session` → no funciona como comando en Antigravity
- ✅ `Ejecuta new-session` o `Haz el skill new-session` → Gemini lo invoca

**Gemini lee el proyecto automáticamente** vía `.agents/rules/claude.md` (`trigger: always_on`). No necesitas adjuntar PROJECT_STATE.md manualmente.

**No hay hooks.** Sin auto-snapshot, sin suggest-checkpoint, sin guard, sin HITL. Aplican reglas obligatorias de compensación:

- **HITL manual** — antes de cualquier `git push`, `rm -rf`, `DROP TABLE` o `sudo`, Gemini debe detenerse y pedir confirmación explícita [Y/N] del usuario. No lo asumes como aprobado.
- **Checkpoint obligatorio antes de DONE** — no marques ninguna tarea como completada sin que el usuario haya ejecutado las pruebas Y hecho commit.
- Antes de cerrar Antigravity, corre en terminal:
```bash
git add . && git commit -m "checkpoint: [descripción]"
```

**Handoff de Claude → Gemini:** usa `/checkpoint` → opción Handoff → selecciona Gemini. Sigue las instrucciones paso a paso que genera.

**Actualizar Dupla en Antigravity:** requiere terminal (no hay `/update-dupla` dentro de Gemini). Corre `bash ~/Projects/dupla-workflow/bin/install.sh` desde terminal.

---

## 9. Multi-Surface — Tabla Comparativa

```
Más automatización ──────────────────────────── Más manual
Claude Code IDE/CLI  │  Antigravity  │  Cursor  │  Chat/Web
  Skills + Hooks     │  Skills only  │  Skills  │  Solo texto
```

| Capacidad | Claude Code | Antigravity | Cursor | Chat/Web |
|---|:---:|:---:|:---:|:---:|
| Skills (`/comando`) | ✅ | ✅ workflows | ✅ Agent Mode | ❌ pegar texto |
| Hooks automáticos | ✅ 6 hooks | ❌ manual | ❌ manual | ❌ |
| Agentes paralelos | ✅ nativo | ⚠️ run_command | ⚠️ múltiples tabs | ❌ |
| Handoff block | ✅ | ✅ | ✅ | ✅ pegar texto |
| Leer archivos proyecto | ✅ | ✅ run_command | ✅ Agent Mode | ⚠️ adjuntar |

**Claude Code es el entorno de referencia.** En Cursor o Chat, `/checkpoint` debe correrse manualmente al final de cada sesión.

Para detalles por entorno (Windsurf, GPT, WhatsApp): ver [docs/SURFACE_GUIDE.md](SURFACE_GUIDE.md).

---

## 10. Handoff entre LLMs o Sesiones

```
1. /checkpoint → opción Handoff
2. Copia el bloque <handoff> generado
3. En el nuevo entorno: pega el bloque + /new-session
```

El bloque contiene: proyecto, branch, qué se completó, cuál es el próximo paso exacto. Funciona en todos los entornos — en Chat lo pegas como texto plano.

---

## 11. Trabajo en Equipo

```
/adapt-to-team     ← convierte proyecto individual a modo equipo
/add-team-member   ← agrega un dev con su sección y branch
/new-session standup  ← vista consolidada del equipo (solo Lead)
```

Cada dev tiene su sección en `PROJECT_STATE.md` y su branch `work/phase[N]-[role]`. El Lead usa `/new-session standup` para ver el estado de todos en <15 líneas.

**Gestión de concurrencia — cómo se evitan conflictos:**
- Cada dev edita SOLO su sección (`### [Su Nombre]`) — nunca toca las secciones de otros.
- Los subagentes paralelos escriben sus hallazgos en archivos temporales independientes (`/progress/agent-[nombre].md`) y el Planificador/Lead los consolida secuencialmente en `PROJECT_STATE.md`.
- `code-review-graph.json` es generado por hook al final de cada respuesta — si dos devs generan simultáneamente, el último commit gana (el archivo es regenerable, no es fuente de verdad).
- Conflictos de merge en `PROJECT_STATE.md`: resolver siempre a favor de ambas secciones (keep both) — nunca hacer "theirs" o "ours" que borre el trabajo de otro dev.

---

## 12. Knowledge Graph

`docs/code-review-graph.json` — se auto-genera via hook después de cada respuesta. Nunca se edita manualmente. Se consulta con `/knowledge-graph` para ver relaciones entre docs, o para análisis de impacto antes de refactors grandes.
