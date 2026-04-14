# Guía de Colaborador — [Nombre del Proyecto]

> Tiempo estimado para estar listo: ~20 minutos

---

## Lo que necesitas antes de empezar

* [ ] Acceso al repo en GitHub (pedirlo al dueño)
* [ ] Credenciales del proyecto (`.env.local`) — pedirlas por canal seguro (nunca GitHub)
* [ ] Claude Code instalado (https://claude.ai/code)
* [ ] Git instalado
* [ ] Node.js (si aplica)

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

Abrir:
http://localhost:3000

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

## Fuente de verdad del proyecto

Claude SIEMPRE trabaja basado en:

1. Código del proyecto
2. docs/PROJECT_STATE.md

Esto define:

* Qué se está haciendo
* Qué sigue
* Qué NO hacer

Otros docs son apoyo.

---

## Flujo de trabajo diario

### 🔹 Al iniciar

```bash
git pull
```

En Claude:

```
/new-session
```

Claude:

* Lee PROJECT_STATE.md
* Detecta estado actual
* Te dice:

  * next steps
  * blockers

---

### 🔹 Durante el trabajo

* Trabaja en tareas pequeñas
* Sigue Next Steps
* No improvises fuera del scope

---

### 🔹 Al terminar

```bash
git add .
git commit -m "tipo(módulo): descripción"
git push
```

Luego en Claude:

```
/progress
```

Claude:

* Actualiza PROJECT_STATE.md
* Evalúa progreso
* Deja listo siguiente estado

---

## Reglas de trabajo

### Branches (obligatorio)

```bash
git checkout -b work/lo-que-vas-a-hacer
```

Nunca trabajar en main.

---

### Commits

```
feat(módulo): nueva funcionalidad
fix(módulo): bug
docs: documentación
chore: setup/configuración
```

---

### Merge a main

Solo si:

1. `npm run build` funciona
2. Código revisado

---

## Uso de Claude (reglas clave)

* No necesitas explicar contexto
* Claude ya lo tiene
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
| `/new-session`    | Inicia sesión, lee estado, define próximos pasos | Siempre al iniciar       |
| `/progress`       | Cierra sesión, actualiza estado y sincroniza     | Siempre al terminar      |
| `/new-project`    | Inicializa proyecto desde docs                   | Una vez                  |
| `/update-context` | Alinea roadmap + arquitectura                    | Cuando cambia el sistema |

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
