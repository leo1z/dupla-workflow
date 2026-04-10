# Sistema de Trabajo — Skills para Claude Code

Skills y templates para trabajar con Claude Code de forma estructurada.
Incluye gestión de sesiones, roadmap vivo, detección de ciclos y contexto de proyecto.

## ¿Qué es esto?

Un conjunto de skills (comandos) para Claude Code que implementan una metodología de trabajo:
- Inicio y cierre de sesión con contexto
- Roadmap actualizado automáticamente
- Detección de ciclos sin avance
- Contexto de proyecto cacheado
- Kanban integrado

## Instalación

### En Windows (con bash / Git Bash)

```bash
git clone https://github.com/leo1z/sistema-trabajo
cd sistema-trabajo
bash instalar.sh
```

### Manual (cualquier OS)

Copia todos los archivos de `commands/` a tu carpeta `~/.claude/commands/`:

**Windows:**
```
C:\Users\TU_USUARIO\.claude\commands\
```

**Mac/Linux:**
```
~/.claude/commands/
```

Si la carpeta no existe, créala primero.

---

## Skills incluidos

### Sesión de trabajo
| Comando | Qué hace |
|---|---|
| `/goal "objetivo"` | Inicia la sesión — snapshot del proyecto + plan para el día |
| `/progress` | Cierra la sesión — marca completado, detecta ciclos, actualiza ROADMAP |
| `/project-status` | Snapshot rápido: dónde estás, qué sigue, riesgos activos |
| `/scope-check` | Revisa si la sesión se desvió del objetivo original |

### Kanban del proyecto
| Comando | Qué hace |
|---|---|
| `/kanban` | Muestra el estado del Kanban (Must/Should/Could/Won't) |

### Mantener documentos actualizados
| Comando | Qué hace |
|---|---|
| `/init-context` | Genera CLAUDE.md para un proyecto explorando su código |
| `/update-context` | Actualiza CLAUDE.md cuando algo cambió |
| `/update-roadmap` | Actualiza ROADMAP.md |
| `/update-tier1` | Actualiza tier1.md (versión liviana para Claude Desktop) |

### Optimización
| Comando | Qué hace |
|---|---|
| `/tokens` | Estima tokens usados y costo en la sesión actual |
| `/reprompt "texto"` | Reformula un mensaje largo para ahorrar tokens |
| `/coherencia` | Auditoría mensual: docs + conexiones + estado |
| `/evaluar-tool nombre` | Evalúa si vale la pena instalar una herramienta |

---

## Configuración inicial (después de instalar)

### 1. Configura tu CLAUDE.md global

El archivo `templates/CLAUDE.global.md` es una plantilla base. Cópiala y edítala:

```bash
cp templates/CLAUDE.global.md ~/.claude/CLAUDE.md
```

Edita el archivo y completa:
- **Quién sos** — tu rol y nivel de experiencia
- **Tus proyectos** — rutas locales y repos de GitHub
- **Stack base** — las tecnologías que usas

### 2. Crea tu archivo de credenciales

```bash
cp templates/CREDENCIALES.template.md ~/.claude/CREDENCIALES.md
```

Llena los valores. **Nunca subas este archivo a git.**

### 3. Verifica que los skills funcionan

Abre VS Code con cualquier proyecto y escribe en Claude:
```
/project-status
```

Si Claude responde con un análisis del proyecto → todo funciona.

---

## Estructura de documentos por proyecto

Cada proyecto debería tener estos archivos para que el sistema funcione:

```
mi-proyecto/
├── CLAUDE.md               ← contexto completo para VS Code
├── docs/
│   ├── ROADMAP.md          ← estado actual y próximos pasos
│   ├── KANBAN.md           ← tareas priorizadas
│   ├── PROBLEMS.md         ← errores resueltos (no repetir)
│   ├── DECISIONS.md        ← por qué está construido así
│   └── tier1.md            ← resumen para Claude Desktop
└── GUIA_COLABORADOR.md     ← onboarding para nuevos colaboradores
```

Para generar esta estructura en un proyecto existente:
```
/init-context
```

---

## Uso diario

```
Al iniciar:   git pull → /goal "qué quiero hacer hoy"
Al terminar:  git push → /progress
Si hay error: copia el error → díselo a Claude con contexto
```

---

## Actualizaciones

Cuando haya nuevos skills o mejoras:

```bash
cd sistema-trabajo
git pull
bash instalar.sh
```

---

## Créditos

Desarrollado por [@leo1z](https://github.com/leo1z) con Claude Code.
