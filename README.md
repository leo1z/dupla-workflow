# Sistema de Trabajo V2 — Skills para Claude Code

Skills para trabajar con Claude Code de forma estructurada: inicio/cierre de sesión, contexto de proyecto cacheado, estado dinámico y detección de ciclos. Incluye flujo de planificación y setup automático de proyectos nuevos.

**Compatible con**: cualquier carpeta de proyectos (Projects, Dev, src, etc.) y cualquier usuario. Auto-detecta rutas y configuración.

## Instalación

```bash
git clone https://github.com/leo1z/sistema-trabajo
cd sistema-trabajo
bash instalar.sh
```

Instala los skills en `~/.claude/commands/` y los templates globales en `~/.claude/`.

### Para colaboradores

1. **Instala dependencias** (una sola vez):
   ```bash
   # Git y Claude Code ya deben estar instalados
   # Clona el repo en tu carpeta de proyectos (puede ser cualquier nombre)
   git clone https://github.com/leo1z/sistema-trabajo ~/MisProyectos/dupla-workflow
   cd ~/MisProyectos/dupla-workflow
   bash instalar.sh
   ```

2. **Setup inicial** (una sola vez):
   - Abre cualquier proyecto en VS Code + Claude Code
   - Escribe `/setup`
   - Responde las preguntas → genera `~/.claude/CLAUDE.md` personalizado

3. **Crea proyectos nuevos**:
   ```bash
   # Desde cualquier carpeta
   bash ~/MisProyectos/dupla-workflow/nuevo-proyecto.sh
   ```
   El script auto-detecta dónde está dupla-workflow y dónde guardar el proyecto.

---

## Los skills

| Comando | Qué hace | Cuándo |
|---|---|---|
| `/new-session [objetivo]` | Lee PROJECT_STATE, define próximos pasos | Al INICIAR sesión — siempre |
| `/progress` | Actualiza PROJECT_STATE con lo completado | Al CERRAR sesión — siempre |
| `/new-project` | Inicializa PROJECT_STATE desde docs del proyecto | Una vez por proyecto nuevo |
| `/update-context` | Actualiza solo la sección afectada de CLAUDE.md | Cuando cambia arquitectura o stack |
| `/health-check` | Auditoría: credenciales, skills, coherencia | Cada 2–4 semanas |
| `/setup` | Setup del sistema por primera vez en una máquina | Una vez por máquina |
| `/adopt` | Adopta proyecto existente al workflow | Una vez por proyecto existente |
| `/token-budget` | Conciencia de tokens + alertas de presupuesto | En sesiones largas |

---

## Crear un proyecto nuevo

### Flujo rápido: interactivo

```bash
bash /ruta/a/dupla-workflow/nuevo-proyecto.sh
```

El script te hace las preguntas directamente en la terminal y crea el proyecto en tu carpeta actual (o pregunta dónde).

### Flujo planificado: config file (opcional)

**Paso 1 — Planificar en Claude**

Usa el PLANNING_PROMPT.md para generar un bloque `proyecto.config`.

**Paso 2 — Correr con config**

```bash
bash /ruta/a/dupla-workflow/nuevo-proyecto.sh --config mi-proyecto.config
```

El script auto-detecta dónde guardar el proyecto sin preguntar rutas.

---

## Qué crea el script

```
mi-proyecto/
├── CLAUDE.md                  ← contexto para la AI (stack, arquitectura, reglas)
├── docs/
│   ├── PROJECT_STATE.md       ← estado dinámico: dónde estamos, qué sigue
│   └── PROBLEMS.md            ← errores ya resueltos (no repetir)
├── .env.example               ← variables sin valores — sí a git
└── .gitignore
```

Además: git init, branch `main` + `work/setup`, y repo privado en GitHub (requiere token en `~/.claude/CREDENCIALES.md`).

---

## Configuración inicial (una sola vez por usuario)

Después de instalar con `bash instalar.sh`:

### 1. Setup automático

Abre VS Code con cualquier proyecto y escribe:
```
/setup
```

Responde las preguntas y Claude genera automáticamente:
- `~/.claude/CLAUDE.md` — tu configuración global personalizada
- `~/.claude/CONTEXTO_[nombre].md` — perfil tuyo
- `~/.claude/STACK_GLOBAL.md` — tus herramientas y servicios
- `~/.claude/PROJECTS_SKILLS.md` — tus proyectos activos

### 2. Credenciales (opcional pero recomendado)

```bash
nano ~/.claude/CREDENCIALES.md
```

Llena tokens de GitHub, Supabase, etc. **Nunca subas este archivo a git.**

### 3. Verifica

Escribe `/health-check` en cualquier proyecto. Debe reportar: skills instalados, CLAUDE.md presente, etc.

---

## Flujo de trabajo por sesión

```
Inicio:   git pull → /new-session
Trabajo:  commits frecuentes en work/*
Cierre:   git push → /progress
```

---

## Actualizaciones

```bash
cd sistema-trabajo
git pull
bash instalar.sh
```

---

## Estructura del repo

```
dupla-workflow/
├── commands/          ← skills de Claude Code (.md)
├── templates/         ← PROJECT_STATE, GUIA_COLABORADOR, PLAN_PROMPT, otros templates
├── global-templates/  ← templates para setup inicial (~/.claude/)
├── docs/              ← guías del sistema (New_Project_Guide, WORKFLOW_IDEAL)
├── nuevo-proyecto.sh  ← script de setup (interactivo o --config)
└── instalar.sh        ← instala todo en la máquina local
```
