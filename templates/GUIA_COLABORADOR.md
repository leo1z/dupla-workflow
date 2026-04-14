# Guía de Colaborador — [Nombre del Proyecto]

> Tiempo estimado para estar listo: ~20 minutos

---

## Lo que necesitas antes de empezar

* [ ] Acceso al repo en GitHub (pedirlo al dueño)
* [ ] Credenciales del proyecto (`.env.local`) — pedirlas por canal seguro (nunca GitHub)
* [ ] Claude Code instalado (https://claude.ai/code)
* [ ] Git instalado

---

## ¿Primera vez en esta máquina?

Si nunca has usado dupla-workflow en esta máquina, instala el sistema primero:

```bash
git clone https://github.com/leo1z/dupla-workflow "C:/Users/TU_USUARIO/Projects/dupla-workflow"
cd "C:/Users/TU_USUARIO/Projects/dupla-workflow"
bash instalar.sh
```

Luego abre cualquier proyecto en VS Code y corre `/setup` — Claude te hará una entrevista para configurar tu perfil.

Si el sistema ya está instalado, salta directamente al Paso 1.

---

## Paso 1 — Clonar el proyecto

```bash
git clone https://github.com/leo1z/nombre-proyecto "C:/Users/TU_USUARIO/Projects/nombre-proyecto"
```

---

## Paso 2 — Abrir en VS Code

```bash
code "C:/Users/TU_USUARIO/Projects/nombre-proyecto"
```

IMPORTANTE:

* Abre la carpeta completa
* Claude carga el contexto automáticamente

---

## Paso 3 — Instalar dependencias

```bash
npm install
```

---

## Paso 4 — Variables de entorno

1. Revisa `.env.example`
2. Crea `.env.local`
3. Pide credenciales al dueño (WhatsApp/Slack)
4. Copia valores

---

## Paso 5 — Verificar que funciona

```bash
npm run dev
```

Abrir: http://localhost:3000

Si falla → copiar error completo

---

## Paso 6 — Contexto del proyecto

Claude ya cargó automáticamente:

* CLAUDE.md (reglas)
* PROJECT_STATE.md (estado)
* ARCHITECTURE.md (estructura)
* ROADMAP.md (dirección)

No necesitas explicar nada manualmente.

---

## ¿Tienes un proyecto existente que no usa dupla-workflow?

Si el proyecto no tiene `CLAUDE.md` ni `docs/PROJECT_STATE.md`, puedes adoptarlo al sistema:

1. Abre el proyecto en VS Code con Claude Code
2. Escribe: `/adopt`

Claude va a:
- Leer el estado real del repo (git log, README, package.json)
- Reportar qué docs faltan
- Generar los docs faltantes desde el código real (no templates vacíos)
- Registrar el proyecto en `~/.claude/PROJECTS_SKILLS.md`

No sobrescribe nada sin mostrarte el diff primero.

---

## Fuente de verdad del proyecto

Claude SIEMPRE trabaja basado en:

1. Código del proyecto
2. `docs/PROJECT_STATE.md`

Esto define qué se está haciendo, qué sigue, y qué NO hacer. Otros docs son apoyo.

---

## Flujo de trabajo diario

### Al iniciar

```bash
git pull
```

En Claude:

```
/new-session
```

Claude lee PROJECT_STATE.md, detecta el estado actual y te dice los próximos pasos y bloqueadores.

---

### Durante el trabajo

* Trabaja en tareas pequeñas
* Sigue Next Steps del PROJECT_STATE
* No improvises fuera del scope

---

### Al terminar

```bash
git add .
git commit -m "tipo(módulo): descripción"
git push
```

Luego en Claude:

```
/progress
```

Claude actualiza PROJECT_STATE.md, evalúa el progreso, y deja listo el siguiente estado.

---

## Reglas de trabajo

### Branches (obligatorio)

```bash
git checkout -b work/lo-que-vas-a-hacer
```

Nunca trabajar en main.

### Commits

```
feat(módulo): nueva funcionalidad
fix(módulo): bug
docs: documentación
chore: setup/configuración
```

### Merge a main

Solo si:

1. `npm run build` funciona
2. Código revisado

---

## Uso de Claude (reglas clave)

* No necesitas explicar contexto — Claude ya lo tiene
* Siempre trabaja desde PROJECT_STATE.md
* Si algo contradice el estado → se debe señalar

---

## Si algo falla

En Claude:

```
Error: [pegar error]
Estaba haciendo: [acción]
Archivo: [archivo]
```

Claude:
1. Revisa PROBLEMS.md
2. Si no está → diagnostica
3. Aplica fix
4. Si es reusable → documenta

---

## Sistema de comandos

| Comando           | Qué hace                                         | Cuándo                   |
| ----------------- | ------------------------------------------------ | ------------------------ |
| `/setup`          | Configura el sistema por primera vez             | Una vez por máquina      |
| `/adopt`          | Adopta proyecto existente al workflow            | Una vez por proyecto     |
| `/new-session`    | Inicia sesión, lee estado, define próximos pasos | Siempre al iniciar       |
| `/progress`       | Cierra sesión, actualiza estado y sincroniza     | Siempre al terminar      |
| `/new-project`    | Inicializa proyecto desde docs                   | Una vez por proyecto nuevo |
| `/update-context` | Alinea docs con el estado real del código        | Cuando cambia el sistema |
| `/health-check`   | Auditoría: credenciales, skills, coherencia      | Cada 2-4 semanas         |

---

## Reglas importantes

* PROJECT_STATE.md manda sobre todo
* No improvisar fuera del flujo
* No agregar features fuera de scope
* No subir credenciales
* No trabajar en main

---

## Flujo del sistema

Idea → Roadmap → Architecture → Setup → Execution → Progress → Iteration

---

## Resultado esperado

Si sigues este flujo:

* Siempre sabes qué hacer
* No pierdes contexto
* No repites errores
* Avanzas de forma consistente
