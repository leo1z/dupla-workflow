# Guías de Trabajo — Leo Borjas
> Paso a paso operativo. Si alguien nuevo lee esto, puede trabajar sin preguntar nada.
> Última actualización: 2026-04-12

---

# SECCIÓN 0 — CÓMO ESTÁ ORGANIZADO TODO

## Estructura local (tu PC)

```
C:/Users/Leo Borjas/
├── .claude/
│   ├── CLAUDE.md              ← Reglas globales — Claude las carga siempre
│   ├── CREDENCIALES.md        ← Todas las credenciales — nunca a git
│   ├── CONTEXTO_CHATGPT.md    ← Pegar al inicio de cada chat en ChatGPT
│   ├── commands/              ← Los 4 skills (/goal, /progress, /init-context, /update-context)
│   └── memory/                ← Memoria persistente de Claude entre sesiones
│
└── Projects/
    ├── EMPIEZA_AQUI.md        ← Punto de entrada
    ├── SISTEMA.md             ← Arquitectura del sistema
    ├── GUIAS_TRABAJO.md       ← Este archivo
    ├── AI_CONTEXT_TEMPLATE/   ← Templates para proyectos nuevos
    ├── dupla-conecta/         ← Proyecto 1
    └── maraton/               ← Proyecto 2
```

**Cada proyecto tiene esta estructura interna:**
```
[proyecto]/
├── CLAUDE.md              ← Contexto completo para Claude (stack, arquitectura, reglas)
├── .env.local             ← Variables de entorno con valores — NUNCA a git
├── .env.example           ← Variables sin valores — sí va a git
└── docs/
    ├── PROJECT_STATE.md   ← Estado dinámico: dónde estamos, qué sigue
    └── PROBLEMS.md        ← Errores ya resueltos
```

---

## Estructura online

| Servicio | URL | Para qué |
|---|---|---|
| GitHub | github.com/leo1z | Fuente de verdad — todo el código |
| Vercel | vercel.com/dashboard | Deploy automático del frontend al hacer push a main |
| VPS | 72.60.126.84 | Servidor: Docker (n8n, nginx, postgres, redis, evolution_api) + PM2 (maratón) |
| Supabase | supabase.com | Base de datos + auth + storage para Dupla Conecta |

**Proyectos activos:**

| Proyecto | GitHub | Despliega en | Qué es |
|---|---|---|---|
| Dupla Conecta | leo1z/dupla-conecta | Vercel + VPS | SaaS WhatsApp marketing multi-tenant |
| Maratón | leo1z/maraton | VPS (PM2) | Sistema de cambios de participantes |

---

## Stack base

| Capa | Tecnología |
|---|---|
| Framework | Next.js + React |
| Lenguaje | TypeScript |
| Estilos | Tailwind CSS v4 + Shadcn/UI |
| Base de datos | Supabase (PostgreSQL + Auth + Storage) |
| Deploy frontend | Vercel |
| Deploy backend/servicios | VPS con Docker |
| Control de versiones | Git + GitHub |
| AI principal | Claude en VS Code (modo agente) |

Cada proyecto puede tener variaciones — lee el `CLAUDE.md` del proyecto antes de tocar cualquier cosa.

---

## Herramientas que necesitas tener instaladas

- **VS Code** — editor principal
- **Git** — control de versiones
- **Node.js + npm** — para proyectos Next.js
- **Claude Code** — extensión de VS Code o CLI (`npm install -g @anthropic-ai/claude-code`)
- **GitHub CLI** — en `C:\Program Files\GitHub CLI\gh.exe` (en bash: `"/c/Program Files/GitHub CLI/gh.exe"`)

---

---

## Cuándo usar cada herramienta de AI

| Situación | Herramienta | Cómo |
|---|---|---|
| Vas a tocar código | **Claude en VS Code** | Abre la carpeta → Claude lee CLAUDE.md automático |
| Pregunta sobre el proyecto sin tocar código | **Claude Desktop o app del celular** | Abre el Project configurado |
| Explorar una idea antes de comprometerte | **ChatGPT** | Pega CONTEXTO_CHATGPT.md al inicio |
| Se te acabaron los tokens de Claude | **Antigravity (Gemini)** | Ver Sección 5 — Cambio de chat |
| Estás en SSH o sin IDE | **Claude Code en terminal** | `claude` en la terminal del VPS |

### Configurar Claude Desktop para un proyecto (hacerlo una vez)

1. Abre Claude Desktop → crea un nuevo Project con el nombre del proyecto
2. En **Project Instructions** → pega la sección `## Contexto mínimo (Claude Desktop)` del `CLAUDE.md` del proyecto
3. En **Project Knowledge** → sube `docs/PROJECT_STATE.md` y `docs/PROBLEMS.md`

Cuando actualices CLAUDE.md → re-pega esa sección en Project Instructions.
Cuando haya cambios en PROJECT_STATE o PROBLEMS → re-sube esos archivos.

> Los Projects de Claude Desktop sincronizan con la app del celular — configúralo una vez en Desktop y lo tienes en el teléfono.

### Desde el celular

Abre Claude app → ve a Projects → selecciona el proyecto → tienes el contexto cargado.

Sirve para: revisar PROJECT_STATE, hacer preguntas de arquitectura, planificar la próxima sesión.
No sirve para: ejecutar skills, editar archivos, correr comandos.

---

# SECCIÓN 1 — INICIAR UN PROYECTO NUEVO

**Tiempo total: ~30 minutos**

> Para el workflow completo por fases (Discovery → Planning → Design → Development → Validation) → ver [`docs/WORKFLOW_IDEAL.md`](WORKFLOW_IDEAL.md)

## Paso 1 — Valida la idea (5 min) — en ChatGPT

1. Abre ChatGPT
2. Pega el contenido de `C:\Users\Leo Borjas\.claude\CONTEXTO_CHATGPT.md`
3. Escribe:
```
Quiero construir: [describe el proyecto en 2-3 oraciones]
¿Es viable dado mi stack y nivel actual?
¿Cuáles son los riesgos principales?
¿Qué debería construir primero para validar más rápido?
Dame un roadmap de 4 fases con entregables concretos.
```
4. Si los riesgos superan los beneficios → no sigas hasta resolverlos.

**No pases al Paso 2 sin un roadmap aprobado.**

---

## Paso 2 — Crea la estructura (3 min)

En la terminal de VS Code:
```bash
bash "C:/Users/Leo Borjas/Projects/nuevo-proyecto.sh" nombre-del-proyecto
```
Reglas para el nombre: solo minúsculas, sin espacios, usa guiones. Ej: `mi-app`, `sistema-pagos`

El script crea: carpeta del proyecto + documentos estándar + repo GitHub + branches `main` y `work/setup`.

---

## Paso 3 — Abre el proyecto en VS Code

```bash
code "C:/Users/Leo Borjas/Projects/nombre-del-proyecto"
```

---

## Paso 4 — Genera el contexto (2 min) — en Claude

```
/init-context
```

Claude explora el proyecto y genera `CLAUDE.md` + `docs/PROJECT_STATE.md`. Revísalos y dile si falta algo.

---

## Paso 5 — Carga el roadmap (2 min) — en Claude

```
Llena docs/PROJECT_STATE.md con este roadmap.
Fase 1 como "En progreso", el resto como "Próximos pasos".

[pega el roadmap de ChatGPT]
```

---

## Paso 6 — Variables de entorno (5 min)

1. Crea `.env.local` en la raíz del proyecto
2. Abre `CREDENCIALES.md`
3. Copia las variables que el proyecto necesita a `.env.local`
4. El `.env.example` ya tiene los nombres vacíos — no lo toques

---

## Paso 7 — Primer commit

```bash
git add CLAUDE.md docs/ .env.example .gitignore
git commit -m "chore: init — estructura y contexto base"
git push
```

---

## Paso 8 — Configura Claude Desktop (opcional, 2 min)

1. Abre Claude Desktop → crea un nuevo Project con el nombre del proyecto
2. En "Project Instructions" pega la sección `## Contexto mínimo (Claude Desktop)` del `CLAUDE.md`
3. En "Project Knowledge" sube `docs/PROJECT_STATE.md` y `docs/PROBLEMS.md`

---

---

# SECCIÓN 2 — CONTINUAR UN PROYECTO EXISTENTE

## Si es la primera vez en esta PC (git clone)

```bash
git clone https://github.com/leo1z/nombre-proyecto "C:/Users/Leo Borjas/Projects/nombre-proyecto"
code "C:/Users/Leo Borjas/Projects/nombre-proyecto"
```

Después del clone:
1. Crea `.env.local` con los valores de `CREDENCIALES.md`
2. En la terminal: `npm install` (solo para proyectos Next.js/Node)

> `git clone` = descargar por primera vez. `git pull` = actualizar lo que ya tienes. No los confundas.

---

## Si ya tienes el proyecto en esta PC

1. Abre VS Code → `File` → `Open Folder` → carpeta del proyecto
2. En la terminal:
```bash
git pull
```
3. En Claude:
```
/goal "qué quieres lograr hoy"
```

Claude lee `PROJECT_STATE.md` y te da el estado actual + plan en menos de 10 líneas.

---

---

# SECCIÓN 3 — SESIÓN DE TRABAJO: INICIO Y CIERRE

## Inicio de sesión (<30 segundos)

```bash
# 1. Abre VS Code con la carpeta del proyecto
# 2. En la terminal:
git pull

# 3. En Claude:
/goal "lo que quieres lograr hoy"
```

Claude responde con:
- Estado actual del proyecto (lee PROJECT_STATE.md)
- Alerta si estás en main en vez de un branch de trabajo
- Plan de 3 pasos máximo para tu objetivo

**Eso es todo. Trabajas.**

---

## Cierre de sesión (<1 minuto)

```bash
# 1. En la terminal:
git add .
git commit -m "tipo: descripción de lo que hiciste"
git push

# 2. En Claude:
/progress
```

`/progress` actualiza `docs/PROJECT_STATE.md` con lo que completaste y el próximo paso. Para ahí.

**Si estás muy cansado y no puedes ni con eso:**
```bash
git push
```
Solo eso. El código está guardado. La próxima sesión `/goal` detecta la diferencia y te pregunta qué pasó.

---

## Al día siguiente — retomar sin perder nada

```bash
git pull
/goal "continuar donde lo dejé"
```

Claude lee `PROJECT_STATE.md` y te dice exactamente dónde estabas. No necesitas recordar nada.

---

---

# SECCIÓN 4 — TRABAJAR DURANTE LA SESIÓN

## Cómo comunicarte con Claude de forma eficiente

**Modo ineficiente (chat):**
> "¿Cómo agrego un filtro a la tabla de campañas?"

Claude te explica cómo hacerlo. Tú tienes que implementarlo.

**Modo eficiente (agente):**
> "Agrega un filtro por fecha en components/campaigns/CampaignTable.tsx"

Claude lee el archivo, lo edita, muestra el resultado.

**Regla:** Si tu mensaje termina en "¿cómo hago X?" → estás en modo chat. Cámbialo a "haz X en [archivo]".

---

## Cuándo hacer commit

- Cada vez que algo funciona — no esperes a terminar todo
- Antes de hacer un cambio grande o arriesgado
- Antes de cerrar la sesión (obligatorio)

Mensaje de commit:
```
feat(módulo): descripción corta    ← agregué algo nuevo
fix(módulo): descripción corta     ← arreglé un bug
chore: descripción                 ← configuración, no afecta al usuario
docs: descripción                  ← solo documentación
wip: descripción                   ← sin terminar, para cambiar de PC
```

---

## Cuando Claude pierde el hilo

Si las respuestas se vuelven genéricas o Claude empieza a repetirse:

```
REFOCO:
Proyecto: [nombre]
Objetivo: [1 línea]
Estado actual: [1 línea]
Necesito específicamente: [1 línea]
No repitas contexto — ve directo al cambio.
```

Si eso no funciona → nueva conversación (ver Sección 5).

---

## Cuando la sesión se alarga mucho

Si llevas 25+ mensajes en la misma conversación:
```
/compact
```
Comprime el contexto y continúas desde un estado limpio. No es un skill tuyo — es nativo de Claude Code.

---

## Scope creep — si empiezas a tocar cosas que no eran el objetivo

Detectas que modificaste un archivo que no tiene nada que ver con el objetivo del día.

Opciones:
1. **Dejar para después** — dile a Claude "agrega esto a PROJECT_STATE.md como próximo paso" y vuelve al objetivo
2. **Incorporar al objetivo** — solo si es pequeño y está relacionado
3. **Revertir** — `git checkout -- archivo` para descartar el cambio

---

---

# SECCIÓN 5 — CAMBIAR DE CHAT SIN PERDER CONTEXTO

## Cuándo cambiar de conversación

| Señal | Acción |
|---|---|
| 25+ mensajes y Claude se pone lento | `/compact` primero; si sigue → nueva conversación |
| El mismo error aparece por tercera vez | Nueva conversación inmediato |
| Claude sugiere algo que ya intentaste | Nueva conversación + reformula el problema |
| Cambiaste de objetivo completamente | Nueva conversación |

---

## Cómo cambiar sin perder contexto (3 pasos)

**Paso 1 — En la conversación actual, pide el resumen:**
```
Dame en 3 líneas: qué hicimos, qué no funcionó, cuál es el próximo paso exacto.
```

**Paso 2 — Guarda el código:**
```bash
git push
```

**Paso 3 — Abre nueva conversación con este template:**
```
Continúo desde: [las 3 líneas del resumen]
Archivo que estaba tocando: [ruta/archivo.tsx]
Necesito específicamente: [1 línea — qué hacer ahora]
```

No necesitas pegar CLAUDE.md — Claude lo lee automáticamente al abrir la carpeta del proyecto en VS Code.

---

## Cuando se te acaban los tokens de Claude → Antigravity

1. Antes de que se corten, pide: "Dame el resumen de 3 líneas"
2. Copia el resumen
3. Abre Antigravity con la misma carpeta
4. Al inicio del chat pega:
```
Contexto del proyecto:
[contenido de CLAUDE.md del proyecto — sección principal]

Estado actual:
[las 3 líneas del resumen]

Continúa desde: [próximo paso exacto]
```

Lo que Antigravity hace bien: cambios simples, debugging con contexto que tú le das.
Lo que NO hace: skills, actualizar PROJECT_STATE.md, leer PROBLEMS.md automáticamente.

Al volver a Claude: `git pull` → `/goal "continuar donde lo dejé"`.

---

---

# SECCIÓN 6 — DEPLOY

## Antes de cualquier deploy — verificar que compila

```bash
npm run build
```
Si sale error → corrígelo antes de continuar. Nunca hagas deploy de algo que no compila.

---

## Frontend → Vercel (automático)

```bash
git checkout main
git merge work/tu-branch-actual
git push origin main
```

Vercel detecta el push y despliega solo. Ve el progreso en `vercel.com/dashboard`.
Tiempo: 2-3 minutos.

---

## Backend/servicios → VPS con Docker (Dupla Conecta)

Solo cuando cambia la configuración de Docker:

```bash
ssh root@72.60.126.84
cd /opt/dupla
docker compose up -d
docker ps
```

Si algo falla:
```bash
docker logs nombre-del-servicio --tail=50
```

---

## VPS con PM2 (Maratón)

```bash
# Subir el archivo al VPS
scp "C:/Users/Leo Borjas/Projects/maraton/server.js" root@72.60.126.84:/root/cambios-maraton/server.js

# Conectarse y reiniciar
ssh root@72.60.126.84
pm2 restart cambios-maraton
pm2 status
pm2 logs cambios-maraton --lines 20
```

Antes de subir a producción, siempre haz backup en el VPS:
```bash
cp server.js server.js.backup
```

Si necesitas revertir:
```bash
cp server.js.backup server.js
pm2 restart cambios-maraton
```

---

---

# SECCIÓN 7 — RESOLVER UN PROBLEMA

**No entres en pánico. Sigue este orden exacto:**

1. Lee el error completo — copia todo el texto rojo
2. En Claude:
```
Error: [pega el error completo]
Estaba haciendo: [qué estabas haciendo]
Archivo: [nombre del archivo si lo sabes]
```
3. Claude revisa `PROBLEMS.md` automáticamente — si el error ya fue resuelto antes, te da la solución directa.
4. Cuando se resuelva:
```
Agrega esto a docs/PROBLEMS.md:
Problema: [descripción]
Causa: [qué lo causó]
Solución: [cómo se resolvió]
```

---

## Si llevas 3 intentos y no avanza

Es un problema de comprensión del problema, no de la solución. Para. Reformula:

```
Nueva conversación:
"Problema: [describe desde cero en máximo 3 líneas]
Ya intenté: [bullets de lo que no funcionó]
Archivo: [ruta]
Dame 1 sola hipótesis, no alternativas."
```

---

---

# SECCIÓN 8 — CHEAT SHEET: TERMINAL Y GIT

## Git — comandos del día a día

```bash
# Sincronizar con GitHub
git pull                          # Traer cambios remotos a tu PC
git push                          # Subir tus cambios a GitHub
git push origin main              # Subir explícitamente a main

# Ver estado
git status                        # Qué cambié
git log --oneline -10             # Últimos 10 commits
git diff                          # Ver los cambios exactos

# Branches
git branch                        # Ver branches existentes
git checkout -b work/nombre       # Crear branch nuevo y cambiarte a él
git checkout nombre-branch        # Cambiarte a un branch existente
git checkout main                 # Volver a main

# Guardar cambios
git add .                         # Preparar todos los cambios
git add ruta/archivo.tsx          # Preparar un archivo específico
git commit -m "tipo: descripción" # Guardar con mensaje
git merge work/nombre             # Mergear un branch en el branch actual

# Deshacer cosas
git stash                         # Guardar cambios sin commitear (para cambiar de branch)
git stash pop                     # Recuperar lo que guardaste con stash
git checkout -- archivo.tsx       # Descartar cambios en un archivo (irreversible)
git reset --soft HEAD~1           # Deshacer el último commit (mantiene los cambios)
```

## Git — flujo completo para un feature

```bash
git checkout -b work/nombre-del-feature   # 1. Crear branch
# ... trabajar, editar archivos ...
git add .                                  # 2. Preparar
git commit -m "feat(módulo): descripción" # 3. Commitear
npm run build                              # 4. Verificar que compila
git checkout main                          # 5. Ir a main
git merge work/nombre-del-feature         # 6. Mergear
git push origin main                       # 7. Subir (Vercel despliega automático)
```

---

## npm — proyectos Next.js / Node

```bash
npm install          # Instalar dependencias (después de clonar o cuando hay cambios en package.json)
npm run dev          # Correr localmente → http://localhost:3000
npm run build        # Verificar que compila sin errores — SIEMPRE antes de deploy
npm run lint         # Verificar errores de código
```

---

## SSH — acceso al VPS

```bash
ssh root@72.60.126.84      # Conectarse al VPS (contraseña en CREDENCIALES.md)

# Una vez dentro del VPS:
docker ps                   # Ver contenedores corriendo
docker logs nombre --tail=50  # Ver logs de un contenedor
pm2 status                  # Ver procesos PM2
pm2 logs nombre --lines 20  # Ver logs de un proceso PM2
pm2 restart nombre          # Reiniciar un proceso

# Salir del VPS:
exit
```

---

## VS Code — shortcuts más usados

| Acción | Tecla |
|---|---|
| Abrir/cerrar terminal | `Ctrl + Ñ` |
| Buscar un archivo | `Ctrl + P` |
| Buscar texto en todo el proyecto | `Ctrl + Shift + F` |
| Formatear el código | `Shift + Alt + F` |
| Comentar/descomentar una línea | `Ctrl + /` |
| Abrir paleta de comandos | `Ctrl + Shift + P` |
| Dividir el editor | `Ctrl + \` |
| Ir a una línea específica | `Ctrl + G` |

---

## GitHub CLI — comandos útiles

```bash
# Usar el gh CLI (en bash de Windows):
"/c/Program Files/GitHub CLI/gh.exe" [comando]

# Comandos frecuentes:
gh pr create                          # Crear un Pull Request
gh pr list                            # Ver PRs abiertos
gh repo view --web                    # Abrir el repo en el browser
gh issue list                         # Ver issues abiertos
```

---

## Tipos de mensaje de commit (referencia)

| Prefijo | Cuándo usarlo | Ejemplo |
|---|---|---|
| `feat(módulo):` | Agregué algo nuevo | `feat(campañas): agregar filtro por fecha` |
| `fix(módulo):` | Arreglé un bug | `fix(auth): corregir redirect post-login` |
| `chore:` | Configuración, no afecta al usuario | `chore: actualizar dependencias` |
| `docs:` | Solo documentación | `docs: actualizar PROJECT_STATE` |
| `wip:` | Sin terminar — para cambiar de PC | `wip: a medias con el filtro` |

---

---

# SECCIÓN 9 — EVALUAR E INSTALAR UNA HERRAMIENTA NUEVA (skill, MCP, CLI, plugin)

## Antes de instalar cualquier cosa — 4 preguntas

Respóndelas en orden. Si 2+ son NO → no instales ahora.

| Pregunta | Si es NO |
|---|---|
| ¿Resuelve un problema que tengo HOY, no hipotético? | Descártala |
| ¿Puedo configurarla en menos de 30 minutos? | Déjala para después |
| ¿Conflicta con mis 4 skills existentes o duplica algo que ya tengo? | No instalar |
| ¿Tiene más de 6 meses, buena documentación, o viene de una fuente confiable? | Riesgo alto |

## Evaluación rápida — pega esto en Claude

```
Quiero instalar: [nombre de la herramienta]
Tipo: [skill / MCP / CLI / plugin]
Problema que resuelve: [1 línea]

Evalúa:
1. ¿Conflicta con mis skills actuales (/goal, /progress, /init-context, /update-context)?
2. ¿Funciona en VS Code con Claude Code? ¿Y en terminal?
3. ¿Ahorra o gasta tokens comparado con hacer lo mismo manualmente?
4. ¿Cómo se instala en mi sistema? (Windows, ~/.claude/)
Dame veredicto: instalar / no instalar / esperar. Máximo 10 líneas.
```

---

## Cómo instalar según el tipo

### Skill propio (comando /)
El más simple. Crea un archivo `.md` en `~/.claude/commands/`:

```bash
# Crear el skill
code "C:/Users/Leo Borjas/.claude/commands/nombre-skill.md"
```

Contenido mínimo del archivo:
```markdown
Descripción de lo que hace.

El usuario escribió: /nombre-skill "$ARGUMENTS"

[instrucciones para Claude]
```

Listo. Sin reiniciar nada. Funciona de inmediato en VS Code.

**También agrégalo al repo sistema-trabajo** para tenerlo en otras PCs:
```bash
cp "C:/Users/Leo Borjas/.claude/commands/nombre-skill.md" \
   "C:/Users/Leo Borjas/Projects/sistema-trabajo/commands/"
```

---

### Plugin de terceros (GitHub)
```
/install-plugin github:usuario/nombre-repo
```
Claude lo descarga e instala. Verifica que no rompe nada:
```
/goal "test — verificar que los skills siguen funcionando"
```

---

### MCP Server (conecta Claude a herramientas externas: Notion, Slack, DBs, APIs)

Los MCPs que ya tienes activos: Notion, Gmail, Google Calendar, Canva.

Para agregar uno nuevo:
1. Busca en `github.com/modelcontextprotocol/servers`
2. Sigue el README del MCP específico
3. La configuración va en `~/.claude/settings.json`
4. Reinicia Claude Code para que tome efecto
5. Verifica con `/goal "test"` que todo sigue funcionando

> Los MCPs aparecen en el chat como `mcp__nombre__acción`. Si ves errores de MCP al iniciar → revisa `settings.json`.

---

### CLI (herramienta de línea de comandos)

```bash
npm install -g nombre-herramienta    # para herramientas Node
# o el método de instalación específico de la herramienta
```

Verifica que no interfiere con `claude` CLI:
```bash
claude --version    # debe seguir funcionando
```

---

## Cuándo actualizar el sistema después de instalar

| Si instalaste... | Qué actualizar |
|---|---|
| Skill nuevo propio | Copiarlo a `sistema-trabajo/commands/` + agregar fila en EMPIEZA_AQUI.md |
| Plugin o MCP | Nada — Claude los detecta automáticamente |
| CLI que usarás frecuentemente | Agregar a Sección 8 (Cheat Sheet) de esta guía |

---

---

# SECCIÓN 10 — TRABAJAR DESDE CUALQUIER SUPERFICIE

## VS Code (superficie principal)

**Setup — solo la primera vez:**
1. Instala la extensión "Claude Code" en VS Code (`Ctrl+Shift+X` → busca Claude Code)
2. Autentícate con tu cuenta de Anthropic

**Uso diario:**
- Abre la carpeta del proyecto → CLAUDE.md carga automático
- El chat de Claude está en el panel lateral
- Todos los skills `/` funcionan
- Claude puede leer archivos, editarlos y ejecutar comandos en la terminal integrada

**Shortcut para abrir Claude:** `Ctrl+Shift+P` → "Claude"

---

## Terminal / SSH (cuando no tienes IDE)

**Setup — solo la primera vez en cada máquina:**
```bash
npm install -g @anthropic-ai/claude-code
export ANTHROPIC_API_KEY=tu_key_aqui    # o agrégalo a ~/.bashrc
```

**Verificar que funciona:**
```bash
claude --version
```

**Uso:**
```bash
cd C:/Users/Leo Borjas/Projects/nombre-proyecto
claude                    # inicia Claude en modo agente
```

Una vez dentro de `claude`:
- Todos los skills `/` funcionan igual que en VS Code
- Claude lee CLAUDE.md automático
- Puede editar archivos y ejecutar comandos
- Para salir: `Ctrl+C` o escribe `exit`

**Para tener los skills en terminal:**
Los skills viven en `~/.claude/commands/` — si instalaste el sistema con `instalar.sh`, ya están ahí. Si estás en una PC nueva o en el VPS → ver Sección 11.

**Desde el VPS:**
```bash
ssh root@72.60.126.84
npm install -g @anthropic-ai/claude-code    # solo primera vez
export ANTHROPIC_API_KEY=tu_key
cd /opt/dupla    # o /root/cambios-maraton
claude
```

---

## Claude Desktop (para preguntas sin tocar código)

**Setup por proyecto — hacerlo una vez:**
1. Abre Claude Desktop → crea un nuevo Project con el nombre del proyecto
2. **Project Instructions** → pega la sección `## Contexto mínimo (Claude Desktop)` del `CLAUDE.md` del proyecto
3. **Project Knowledge** → sube `docs/PROJECT_STATE.md` y `docs/PROBLEMS.md`

**Qué puedes hacer:**
- Preguntas de arquitectura, decisiones, planificación
- Revisar PROJECT_STATE.md ("¿cuál es el próximo paso?")
- Dictar ideas y que Claude las organice
- Preguntar sobre errores con contexto del proyecto

**Qué NO puedes hacer:**
- Ejecutar skills (`/goal`, `/progress`, etc.)
- Editar archivos del proyecto
- Correr comandos de terminal

**Cuándo actualizar el Project:**
- Si cambió el stack o arquitectura → re-pega la sección `## Contexto mínimo` del CLAUDE.md
- Si hay cambios en PROJECT_STATE o PROBLEMS → re-sube esos archivos

---

## Resumen: qué funciona en cada superficie

| Capacidad | VS Code | Terminal | Claude Desktop |
|---|---|---|---|
| Skills `/goal`, `/progress` | ✅ | ✅ | ❌ |
| CLAUDE.md carga automático | ✅ | ✅ | Solo si lo configuraste |
| Editar archivos | ✅ | ✅ | ❌ |
| Ejecutar comandos | ✅ | ✅ | ❌ |
| Preguntas sobre el proyecto | ✅ | ✅ | ✅ |
| Funciona sin proyecto abierto | ❌ | ✅ | ✅ |
| Funciona desde el celular | ❌ | ❌ | ✅ (app Claude) |

---

---

# SECCIÓN 11 — TRABAJO REMOTO (celular y otra PC)

## Desde el celular

**Setup — solo una vez:**
1. Descarga la app **Claude** (claude.ai)
2. Inicia sesión con tu cuenta de Anthropic
3. Los Projects que configuraste en Claude Desktop aparecen automáticamente en la app

**Lo que puedes hacer desde el celular:**
- Abrir tu Project → preguntar "¿cuál es el próximo paso según el PROJECT_STATE?"
- Revisar el estado del proyecto
- Planificar la próxima sesión antes de llegar a la PC
- Dictar notas largas y que Claude las organice

**Lo que NO puedes hacer:**
- Skills, editar archivos, terminal

**Flujo útil:**
```
Celular (trayecto) → Claude app → Project del proyecto
→ "¿Cuál es el próximo paso?"
→ "Voy a trabajar en X, ¿qué debo tener en cuenta?"
→ Llegas a la PC con el plan claro → /goal "lo que planeaste"
```

---

## Desde otra PC (primera vez)

Checklist completo — sigue este orden:

**1. Instala las herramientas base**
```bash
# Verifica que tienes instalado:
git --version        # si no: https://git-scm.com/download/win
node --version       # si no: https://nodejs.org
npm --version
```

**2. Instala Claude Code**
```bash
npm install -g @anthropic-ai/claude-code
```

**3. Instala los skills del sistema**
```bash
git clone https://github.com/leo1z/sistema-trabajo "C:/Users/[TU_USUARIO]/sistema-trabajo"
cd sistema-trabajo
bash instalar.sh
```

**4. Configura tu CLAUDE.md global**
```bash
# Copia el template y edítalo con tu info
cp templates/CLAUDE.global.md ~/.claude/CLAUDE.md
```
> O copia directamente desde tu PC principal el `~/.claude/CLAUDE.md` que ya tienes.

**5. Crea tu CREDENCIALES.md**
```bash
cp templates/CREDENCIALES.template.md ~/.claude/CREDENCIALES.md
```
Llena los valores desde tu PC principal (tienes el archivo en `C:/Users/Leo Borjas/.claude/CREDENCIALES.md`).

**6. Clona los proyectos que necesitas**
```bash
git clone https://github.com/leo1z/dupla-conecta "C:/[ruta]/dupla-conecta"
git clone https://github.com/leo1z/maraton "C:/[ruta]/maraton"
```

**7. Crea el .env.local en cada proyecto**
Copia los valores desde `CREDENCIALES.md` al `.env.local` de cada proyecto.

**8. Instala dependencias (solo proyectos Next.js/Node)**
```bash
cd dupla-conecta
npm install
```

**9. Verifica que todo funciona**
```bash
cd dupla-conecta
claude
# dentro de claude:
/goal "test desde PC nueva"
```
Si Claude responde con el estado del proyecto → todo funciona.

---

## Sincronización entre máquinas

**Antes de salir de cualquier PC — siempre:**
```bash
git add .
git commit -m "wip: [qué estabas haciendo]"
git push
```

**Al llegar a otra PC — siempre:**
```bash
git pull
/goal "continuar donde lo dejé"
```

**Si olvidaste hacer push antes de salir:**
```
Dile a Claude: "Tengo cambios en la otra PC sin push. ¿Cómo los recupero?"
```
No entres en pánico — git tiene solución para casi todo.

---

---

# SECCIÓN 12 — EJEMPLO DE SESIÓN REAL COMPLETA

> Escenario: inicio un proyecto nuevo, instalo una herramienta, cierro sesión.

---

```
[Abres VS Code — no importa qué carpeta tengas]

─── PARTE 1: PROYECTO NUEVO ───────────────────────────────────────

Tú (terminal):
  bash "C:/Users/Leo Borjas/Projects/nuevo-proyecto.sh"

Script pregunta:
  Nombre: sistema-pagos
  ¿Qué hace?: Gestión de pagos recurrentes para clientes SaaS
  Tipo: 1 (Next.js + Supabase + Vercel)
  Zonas prohibidas: auth, schema de DB
  ¿Usa Supabase? s  ¿Vercel? s  ¿VPS? n  ¿N8N? n  ¿Evolution? n

Script crea:
  ✓ Projects/sistema-pagos/ con CLAUDE.md, docs/, .env.example, .gitignore
  ✓ Git init + branches main y work/setup
  ✓ Repo github.com/leo1z/sistema-pagos (privado)

Tú (terminal):
  code "C:/Users/Leo Borjas/Projects/sistema-pagos"

[VS Code abre la carpeta — CLAUDE.md carga automático]

Tú (Claude):
  /init-context

Claude:
  Explora el proyecto y llena CLAUDE.md con stack real,
  estructura de carpetas y sección "Contexto mínimo para Desktop"

Tú (Claude):
  Llena docs/PROJECT_STATE.md con este roadmap:
  Fase 1 — Setup base + auth
  Fase 2 — Gestión de planes y pagos
  Fase 3 — Dashboard de clientes

Tú (terminal):
  git add CLAUDE.md docs/ .env.example .gitignore
  git commit -m "chore: init — estructura y contexto base"
  git push

Tú (Claude):
  /goal "configurar Supabase y crear la estructura de tablas base"

Claude:
  ## Sesión — 2026-04-12
  Objetivo: configurar Supabase y crear estructura de tablas base
  Branch actual: work/setup
  Estado: proyecto recién creado, sin tablas aún
  Plan:
  1. Crear proyecto en supabase.com → copiar URL y keys a .env.local
  2. Crear tablas: customers, subscriptions, payments
  3. Habilitar RLS en las 3 tablas
  4. Testear conexión con npm run dev

─── PARTE 2: INSTALAR UNA HERRAMIENTA ────────────────────────────

[A mitad de la sesión ves que necesitas una herramienta para validar
 esquemas de Supabase automáticamente]

Tú (Claude):
  Quiero instalar: supabase-schema-validator
  Tipo: CLI
  Problema que resuelve: validar que el schema local coincide con producción

  Evalúa:
  1. ¿Conflicta con mis skills actuales?
  2. ¿Funciona en VS Code con Claude Code?
  3. ¿Ahorra tokens?
  4. ¿Cómo se instala?
  Dame veredicto en máximo 10 líneas.

Claude:
  1. No conflicta — es un CLI independiente, no un skill de Claude
  2. Funciona en terminal de VS Code normalmente
  3. Sí ahorra tokens: en vez de pedirme que compare schemas,
     lo corres tú y me pegas el output
  4. npm install -g supabase  (ya incluido en Supabase CLI)
  Veredicto: instalar — ya lo tienes si usas Supabase CLI

[Instalas y verificas que funciona]

─── PARTE 3: CIERRE DE SESIÓN ────────────────────────────────────

[Terminaste de crear las tablas y testear la conexión]

Tú (terminal):
  git add .
  git commit -m "feat(db): tablas base customers/subscriptions/payments con RLS"
  git push

Tú (Claude):
  /progress

Claude:
  [actualiza docs/PROJECT_STATE.md]

  ## Sesión cerrada — 2026-04-12
  Commits: feat(db): tablas base customers/subscriptions/payments con RLS
  Completado: tablas creadas, RLS habilitado, conexión verificada
  Próximo paso: Fase 2 — Gestión de planes y pagos

[Listo. Cierras VS Code.]
```

---

**Lo que hizo el sistema por ti sin que lo pidieras:**
- CLAUDE.md cargó automático → Claude sabía el stack desde el primer mensaje
- `/goal` leyó PROJECT_STATE.md → plan concreto en segundos
- `/progress` actualizó PROJECT_STATE.md → mañana arrancas sabiendo dónde quedaste
- PROBLEMS.md estaba disponible → si hubiera aparecido un error conocido, Claude lo habría detectado

---

---

# SECCIÓN 13 — QUÉ PUEDE HACER CLAUDE AUTOMÁTICAMENTE

## De las secciones nuevas (9, 10, 11)

### Sección 9 — Evaluar herramientas
Claude puede hacer todo esto por ti con un solo mensaje:

**Evaluación:** pega el template de la Sección 9 y Claude da veredicto en 10 líneas.

**Crear un skill nuevo:** en vez de crear el archivo manualmente, dile:
```
Crea un skill llamado /nombre que haga: [descripción]
Guárdalo en C:/Users/Leo Borjas/.claude/commands/nombre.md
Y cópialo también a C:/Users/Leo Borjas/Projects/sistema-trabajo/commands/
```
Claude crea el archivo con el formato correcto listo para usar.

**Configurar un MCP:** dile el nombre del MCP y Claude escribe la entrada en `settings.json`:
```
Agrega el MCP [nombre] a mi configuración.
El settings.json está en C:/Users/Leo Borjas/.claude/settings.json
```

**Instalar un plugin de terceros:** un comando y listo:
```
/install-plugin github:usuario/nombre-repo
```

### Sección 10 — Superficies
Lo que NO puede automatizar Claude (requiere UI manual):
- Instalar VS Code, Node, git — instaladores manuales
- Configurar un Project en Claude Desktop — interfaz gráfica

Lo que SÍ puede hacer:
```
# Verificar que todo funciona después del setup:
/goal "verificar que el sistema está configurado correctamente"
```
Claude revisa git, CLAUDE.md, skills y te dice si algo falta.

### Sección 11 — PC nueva
Claude puede generar el `.env.local` a partir del `.env.example` si le das los valores:
```
Lee el .env.example del proyecto y crea el .env.local
con estos valores: [pega los valores de CREDENCIALES.md]
```

También puede verificar que el setup completo está correcto:
```
Verifica que esta PC está correctamente configurada para trabajar:
- git funcionando: git --version
- node: node --version
- claude CLI: claude --version
- skills instalados: ls ~/.claude/commands/
- proyecto clonado: ls Projects/
```

---

*Si algo de esta guía no funciona como dice → dile a Claude el error y lo corregimos.*
