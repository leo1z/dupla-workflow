Genera el contexto completo para este proyecto.

## Paso 1 — Detectar modo: proyecto nuevo vs. existente

Primero revisa si el directorio actual tiene código real:
- ¿Existe package.json, requirements.txt, Cargo.toml, go.mod o equivalente?
- ¿Hay archivos de código fuente (.ts, .js, .py, .go, etc.)?

**Si NO hay código (proyecto nuevo):** ir al Paso 2A.
**Si HAY código (proyecto existente):** ir al Paso 2B.

---

## Paso 2A — Proyecto nuevo: preguntar antes de generar

Haz las siguientes preguntas en un solo mensaje (numeradas, sin preámbulo):

1. ¿Cuál es el nombre del proyecto?
2. ¿Qué tipo de producto es? (SaaS, herramienta interna, landing, API, bot, etc.)
3. ¿Cuál es el objetivo principal en una línea?
4. ¿Cuál es el stack que vas a usar? (o "usar stack base" para Next.js + Supabase + Vercel)
5. ¿Tienes repo en GitHub ya creado? Si sí, ¿cuál es la URL?
6. ¿Hay base de datos? Si sí, ¿cuáles son las tablas principales?
7. ¿Cuáles son las variables de entorno que ya sabes que necesitarás?
8. ¿Cuál es el primer objetivo de desarrollo (qué quieres construir primero)?

Espera la respuesta del usuario. Luego genera CLAUDE.md y docs/PROJECT_STATE.md con esa información. Salta al Paso 3.

---

## Paso 2B — Proyecto existente: explorar y extraer

Explora el proyecto actual:
- Estructura de carpetas (2 niveles de profundidad)
- package.json o equivalente (stack y dependencias)
- README.md si existe
- Archivos de configuración (.env.example, docker-compose, etc.)

Extrae del código real todo lo que puedas. Lo que no puedas inferir → dejarlo como [PENDIENTE].

---

## Paso 3 — Generar archivos

**CLAUDE.md** en la raíz del proyecto con estas secciones:
- Reglas para la AI (zonas prohibidas, comportamiento automático)
- Proyecto (nombre, tipo, estado, repo, URL)
- Stack (tabla de herramientas y roles)
- Arquitectura (diagrama en texto del flujo de datos)
- Estructura de carpetas (real o planificada)
- Base de datos (tablas principales si aplica)
- Variables de entorno (solo nombres, nunca valores)
- Workflow git
- Contexto mínimo (Claude Desktop) — sección compacta para pegar en Project Instructions

**docs/PROJECT_STATE.md** si no existe:
- Estado actual: "Proyecto recién inicializado"
- En progreso: branch actual + objetivo inicial
- Próximos pasos: 3 items concretos (del roadmap si lo dio el usuario)
- Completado: vacío por ahora

---

## Paso 4 — Reporte final (máximo 10 líneas)

- Secciones completadas automáticamente
- Secciones que quedaron como [PENDIENTE] y qué info necesitas del usuario

---

## Reglas generales

- No inventes datos — deja [PENDIENTE] si no puedes inferirlo
- No crear docs/PROBLEMS.md vacío — solo existe cuando hay errores documentados
- Si CLAUDE.md ya existe → mostrar diff y pedir aprobación antes de sobrescribir
- Stack base (si el usuario dice "usar stack base"): Next.js 16, React 19, TypeScript, Tailwind CSS v4, Shadcn/UI, Supabase, Vercel
