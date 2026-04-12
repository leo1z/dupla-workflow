# Sistema de Trabajo V2 — Skills para Claude Code

Skills para trabajar con Claude Code de forma estructurada: inicio/cierre de sesión, contexto de proyecto cacheado, estado dinámico y detección de ciclos. Incluye flujo de planificación y setup automático de proyectos nuevos.

## Instalación

```bash
git clone https://github.com/leo1z/sistema-trabajo
cd sistema-trabajo
bash instalar.sh
```

Instala los skills en `~/.claude/commands/`, copia `nuevo-proyecto.sh` a `~/Projects/`, y los templates a `~/Projects/AI_CONTEXT_TEMPLATE/`.

---

## Los skills

| Comando | Qué hace | Cuándo |
|---|---|---|
| `/goal "objetivo"` | Lee PROJECT_STATE.md, da plan en 10 líneas | Al INICIAR sesión |
| `/progress` | Actualiza PROJECT_STATE.md con lo completado | Al CERRAR sesión |
| `/init-context` | Genera CLAUDE.md + PROJECT_STATE.md para proyecto nuevo | Una vez por proyecto |
| `/update-context` | Actualiza solo la sección afectada de CLAUDE.md | Cuando cambia arquitectura o stack |

---

## Crear un proyecto nuevo

### Flujo recomendado: planificar primero

**Paso 1 — Planificar en Claude o ChatGPT**

Abre `AI_CONTEXT_TEMPLATE/PLANNING_PROMPT.md`, copia el prompt y pégalo en Claude o ChatGPT. El AI te guía con preguntas y al final te entrega un bloque `proyecto.config`.

**Paso 2 — Guardar el config**

Guarda el bloque como `[nombre].config` en cualquier carpeta.

**Paso 3 — Correr el script**

```bash
bash ~/Projects/nuevo-proyecto.sh --config [nombre].config
```

### Flujo rápido: interactivo

```bash
bash ~/Projects/nuevo-proyecto.sh
```

El script te hace las preguntas directamente en la terminal.

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

## Configuración inicial

### 1. CLAUDE.md global

```bash
cp templates/CLAUDE.global.md ~/.claude/CLAUDE.md
```

Edita el archivo: quién eres, tus proyectos, tu stack base.

### 2. Credenciales

```bash
cp templates/CREDENCIALES.template.md ~/.claude/CREDENCIALES.md
```

Llena los valores. **Nunca subas este archivo a git.**

### 3. Verifica

Abre VS Code con cualquier proyecto y escribe:
```
/goal "test"
```

Si Claude responde con el estado del proyecto → todo funciona.

---

## Flujo de trabajo por sesión

```
Inicio:   git pull → /goal "objetivo del día"
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
sistema-trabajo/
├── commands/          ← skills de Claude Code (.md)
├── templates/         ← CLAUDE.global.md, PLANNING_PROMPT.md, otros templates
├── nuevo-proyecto.sh  ← script de setup (interactivo o --config)
└── instalar.sh        ← instala todo en la máquina local
```
