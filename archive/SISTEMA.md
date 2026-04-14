# Sistema de Trabajo — Leo Borjas
> Arquitectura y referencia. Para el paso a paso operativo → GUIAS_TRABAJO.md
> Última actualización: 2026-04-12

---

## 1. QUÉ ES ESTE SISTEMA

`CLAUDE.md` por proyecto + 4 skills + flujo git estandarizado = contexto siempre disponible sin re-explicar nada.

**Qué es automático vs qué necesita un comando:**

| Comportamiento | Automático | Requiere comando |
|---|---|---|
| Claude conoce el proyecto completo | ✅ Al abrir carpeta en VS Code | — |
| Claude conoce reglas globales | ✅ Siempre | — |
| Claude revisa PROBLEMS.md antes de debuggear | ✅ Si está en CLAUDE.md del proyecto | — |
| Snapshot + plan del día | ❌ | `/goal "objetivo"` |
| Actualizar PROJECT_STATE.md | ❌ | `/progress` |

---

## 2. MAPA DE DOCUMENTOS

### Dos categorías: estable vs dinámico

**Contexto estable** (rara vez cambia — no actualizar sin razón)

| Archivo | Dónde | Para qué |
|---|---|---|
| `~/.claude/CLAUDE.md` | Global | Reglas globales — carga siempre automático |
| `~/.claude/CREDENCIALES.md` | Global | Todas las credenciales — nunca a git |
| `~/.claude/CONTEXTO_CHATGPT.md` | Global | Pegar al inicio de cada chat en ChatGPT |
| `Projects/[proyecto]/CLAUDE.md` | Por proyecto | Stack, arquitectura, reglas específicas |

**Estado dinámico** (cambia cada sesión — `/progress` lo actualiza)

| Archivo | Dónde | Para qué |
|---|---|---|
| `docs/PROJECT_STATE.md` | Por proyecto | Dónde estamos, qué sigue, qué se completó |
| `docs/PROBLEMS.md` | Por proyecto | Errores ya resueltos — no resolver dos veces |

**Referencia operativa** (leer cuando necesitas, no mantener)

| Archivo | Dónde | Para qué |
|---|---|---|
| `Projects/EMPIEZA_AQUI.md` | Global | Punto de entrada — qué hacer según tu situación |
| `Projects/GUIAS_TRABAJO.md` | Global | Paso a paso: proyectos, sesiones, deploy, git |
| `Projects/SISTEMA.md` | Global | Este archivo — arquitectura del sistema |

---

## 3. ARQUITECTURA — CÓMO SE CONECTA TODO

```
[ChatGPT]                    ← Validar ideas, viabilidad, brainstorm antes de comprometerte
     ↓ (contexto: CONTEXTO_CHATGPT.md — pegar manualmente)
[Claude Desktop / celular]   ← Preguntas sobre el proyecto sin tocar código
     ↓ (contexto: sección "Contexto mínimo" del CLAUDE.md del proyecto)
[Claude en VS Code]          ← Código, debug, implementar — uso principal
     ↓ (contexto: CLAUDE.md carga automático)
[GitHub]                     ← Fuente de verdad — todo el código vive aquí
     ↙                  ↘
[Vercel]               [VPS]
Frontend auto-deploy   Docker + PM2
```

**Regla de oro:** Si no está en GitHub, no existe.

---

## 4. CUÁNDO USAR CADA HERRAMIENTA

```
¿Vas a tocar código?                    → Claude en VS Code
¿Pregunta de arquitectura o decisión?   → Claude en VS Code (lee los archivos directamente)
¿Explorar una idea antes de empezar?    → ChatGPT (pega CONTEXTO_CHATGPT.md)
¿Revisión rápida desde el celular?      → Claude app → tu Project configurado
¿Se acabaron los tokens de Claude?      → /compact primero; si no alcanza → Antigravity
¿Estás en SSH o sin IDE?               → Claude Code en terminal (claude)
```

### Claude Desktop / app del celular

Configura un Project por proyecto así:
- **Project Instructions:** copia la sección `## Contexto mínimo (Claude Desktop)` del `CLAUDE.md` del proyecto
- **Project Knowledge:** sube `docs/PROJECT_STATE.md` y `docs/PROBLEMS.md`

Cuando actualices el CLAUDE.md → re-copia esa sección en Project Instructions.
Cuando haya cambios en PROJECT_STATE o PROBLEMS → re-sube esos archivos.

---

## 5. FLUJO GIT — SIEMPRE ESTE ORDEN

```bash
# 1. Crear branch de trabajo (nunca trabajar en main)
git checkout -b work/descripcion-corta

# 2. Trabajar y commitear frecuente
git add archivo(s)
git commit -m "tipo(módulo): descripción"

# 3. Verificar antes de mergear
npm run build          # Next.js — si falla, NO merges

# 4. Mergear a main
git checkout main
git merge work/descripcion-corta
git push origin main   # Vercel despliega automático
```

**Nunca commitear directo en main.** Si Claude lo sugiere → corrígelo.

---

## 6. CUÁNDO ACTUALIZAR CADA DOCUMENTO

| Documento | Actualizar cuando... | Cómo |
|---|---|---|
| `PROJECT_STATE.md` | Al cerrar sesión | `/progress` (automático) |
| `PROBLEMS.md` | Resolviste un error repetible | Claude lo agrega solo al resolver |
| `CLAUDE.md` proyecto | Cambió stack, arquitectura o carpetas | `/update-context` |
| `CLAUDE.md` global | Cambió el sistema de trabajo (skills, reglas, herramientas) | Editar directamente |
| `CREDENCIALES.md` | Cambió o expiró una credencial | Manual — nunca vía chat |

## Cuándo cambia el sistema — qué docs actualizar

Usa esta tabla cuando hagas mejoras al sistema (como hoy):

| Si cambias... | Archivos a actualizar | Cómo |
|---|---|---|
| Un skill (goal, progress, etc.) | `~/.claude/commands/[skill].md` + `dupla-workflow/commands/[skill].md` | Editar + `git push` en dupla-workflow |
| Reglas globales de Claude | `~/.claude/CLAUDE.md` | Editar directamente |
| El flujo de trabajo | `GUIAS_TRABAJO.md` | Editar directamente |
| La arquitectura del sistema | `SISTEMA.md` (este archivo) | Editar directamente |
| La lista de skills disponibles | `EMPIEZA_AQUI.md` + `~/.claude/CLAUDE.md` | Editar ambos |
| Los templates de proyectos nuevos | `dupla-workflow/templates/` | Es la fuente única — no hay duplicado |
| Las reglas dentro de un proyecto | `[proyecto]/CLAUDE.md` | `/update-context` |

**Regla de sincronización:** cuando editas un skill en `~/.claude/commands/`, copia el archivo a `dupla-workflow/commands/` y haz push. Son los únicos dos lugares donde viven los skills.

---

## 7. CICLOS — CÓMO SALIR

Señales de que estás en un ciclo:
- El mismo error aparece 3+ veces en la conversación
- Llevas 8+ mensajes sin un commit nuevo
- Claude sugiere alternativas que ya intentaste

Qué hacer:
```
1. Para. No mandes otro mensaje.
2. git stash
3. Cierra la conversación
4. Nueva conversación:
   "Problema: [1-3 líneas]
   Ya intenté: [bullets]
   Archivo: [ruta]
   Dame 1 sola hipótesis."
```

---

## 8. LOS 4 SKILLS

| Skill | Qué hace | Cuándo |
|---|---|---|
| `/goal "objetivo"` | Lee PROJECT_STATE.md, da plan en 10 líneas | Al iniciar — obligatorio |
| `/progress` | Actualiza PROJECT_STATE.md, para | Al cerrar — obligatorio |
| `/init-context` | Genera CLAUDE.md + PROJECT_STATE.md para proyecto nuevo | Una vez por proyecto |
| `/update-context` | Actualiza solo la sección afectada de CLAUDE.md | Cuando cambia arquitectura |
