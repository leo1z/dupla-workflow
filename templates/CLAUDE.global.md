# Claude Global — Leo Borjas

## Quién soy
Fundador técnico construyendo productos SaaS. Relativamente nuevo en desarrollo — entiendo los conceptos pero necesito pasos concretos y claros. No necesito que me expliques por qué existe JavaScript.

## Cómo quiero trabajar

**Respuestas:** Directo al punto. Sin introducción, sin resumen al final, sin "¡Claro!", sin "Excelente pregunta". Si puedo verlo en el diff, no lo repitas en texto.

**Antes de cualquier cambio en código:** dime en una línea qué cambia, riesgo (Low/Medium/High) y si afecta otros sistemas. Si el riesgo es Medium o High, incluye cómo revertirlo.

**Si falta información:** una pregunta precisa. No supongas, no rellenes con ejemplos genéricos.

**Nunca hacer sin que lo pida explícitamente:**
- Commit a `main`
- Cambios en auth, RLS, DB schema o migraciones
- Subir credenciales a git
- Agregar features extra a lo que pedí
- Refactorizar código que no está en el scope

## Modo mínimo (cuando el usuario está cansado o quiere ir directo)

Si el usuario escribe algo como "quiero hacer X" o "estamos en Y, necesito hacer X" **sin usar /goal** → no pidas el comando. Infiere el contexto y trabaja directamente.

Si el usuario cierra sesión solo con `git push` sin /progress → no lo interrumpas. El sistema es tolerante: el próximo /goal leerá git log para inferir el estado.

**Flujo mínimo válido:**
- Inicio: "[descripción de lo que quiero hacer]" → Claude trabaja
- Cierre: `git push` → listo

El sistema sigue funcionando. PROJECT_STATE.md quedará ligeramente desactualizado hasta el próximo /progress, lo cual es aceptable.

## Ahorro de tokens

- No repitas contexto que ya está en el CLAUDE.md del proyecto
- Si necesitas explorar el código, lista primero qué archivos necesitas y por qué — no leas todo el repo
- Prefiere diffs sobre bloques de código completos cuando el cambio es pequeño
- Si algo ya está documentado en los archivos de contexto, referencia la sección en vez de repetirlo
- Respuestas cortas por defecto — si el usuario necesita más detalle, lo pide
- `/compact` está disponible si la sesión supera 25 mensajes — sugerirlo si la conversación se pone lenta

## Mis proyectos

| Proyecto | Ruta local | Repo GitHub | Qué es |
|---|---|---|---|
| Dupla Conecta | `C:/Users/Leo Borjas/Projects/dupla-conecta/` | `leo1z/dupla-conecta` | SaaS WhatsApp marketing multi-tenant |
| Maratón | `C:/Users/Leo Borjas/Projects/maraton/` | `leo1z/maraton` | Sistema de cambios de participantes (Node + Playwright + VPS) |
| Microdetective | `C:/Users/Leo Borjas/Projects/microdetective/` | `leo1z/microdetective` | Juego web tipo NYT Games — investigación interactiva con mapas y deducción |

Cada proyecto tiene su propio `CLAUDE.md` con stack, arquitectura y reglas específicas. Léelo antes de tocar cualquier cosa del proyecto.

## Stack base (aplica a todos mis proyectos salvo que el CLAUDE.md del proyecto diga lo contrario)
Next.js 16, React 19, TypeScript, Tailwind CSS v4, Shadcn/UI, Supabase, Vercel

## Reglas globales de git
- Trabajar siempre en `work/*` — nunca directo en `main`
- Commits pequeños: `feat(módulo):`, `fix(módulo):`, `docs:`, `chore:`
- `main` = producción — solo mergear con PR revisado

## gh CLI — ruta en esta máquina
`C:\Program Files\GitHub CLI\gh.exe`
En terminal bash: `"/c/Program Files/GitHub CLI/gh.exe"`

## Archivos de referencia local
- Punto de entrada: `C:/Users/Leo Borjas/Projects/EMPIEZA_AQUI.md`
- Guías operativas: `C:/Users/Leo Borjas/Projects/GUIAS_TRABAJO.md`
- Arquitectura del sistema: `C:/Users/Leo Borjas/Projects/SISTEMA.md`
- Credenciales: `C:/Users/Leo Borjas/.claude/CREDENCIALES.md` — nunca a git
- Contexto ChatGPT: `C:/Users/Leo Borjas/.claude/CONTEXTO_CHATGPT.md`
- Templates proyectos nuevos: `C:/Users/Leo Borjas/Projects/AI_CONTEXT_TEMPLATE/`

## Estructura de cada proyecto
Cada proyecto en `Projects/[nombre]/` tiene:
- `CLAUDE.md` — contexto estable (stack, arquitectura, reglas)
- `docs/PROJECT_STATE.md` — estado dinámico: dónde estamos, qué sigue (lo actualiza `/progress`)
- `docs/PROBLEMS.md` — errores ya resueltos (no resolver dos veces)

## Skills disponibles (los únicos 4)

| Comando | Para qué | Cuándo |
|---|---|---|
| `/goal "objetivo"` | Lee PROJECT_STATE.md, da plan en 10 líneas | Al INICIAR — obligatorio |
| `/progress` | Actualiza PROJECT_STATE.md con lo completado | Al CERRAR — obligatorio |
| `/init-context` | Genera CLAUDE.md + PROJECT_STATE.md para proyecto nuevo | Una vez por proyecto |
| `/update-context` | Actualiza solo la sección afectada de CLAUDE.md | Cuando cambia arquitectura o stack |
| `/health-check` | Auditoría: credenciales, skills, coherencia, stack | Cada 2-4 semanas |

## Sincronización automática del sistema

Cuando Claude modifica un archivo del sistema, debe sincronizar los siguientes pares **en la misma operación, sin preguntar**:

| Si se modifica... | También actualizar... |
|---|---|
| `~/.claude/commands/[skill].md` | `Projects/sistema-trabajo/commands/[skill].md` |
| `Projects/AI_CONTEXT_TEMPLATE/[template]` | `Projects/sistema-trabajo/templates/[template]` |
| Lista de skills en `EMPIEZA_AQUI.md` | Tabla de skills en `~/.claude/CLAUDE.md` (este archivo) |
| Flujo de trabajo en `GUIAS_TRABAJO.md` | Sección correspondiente en `SISTEMA.md` si aplica |

Después de sincronizar → ejecutar en `Projects/sistema-trabajo/`:
```
git add . && git commit -m "chore: sync [descripción del cambio]" && git push origin master
```

**Si el usuario hizo un cambio manual al sistema** y escribe algo como "cambié X manualmente" o "actualiza lo que sea necesario" → leer la tabla anterior, identificar qué pares aplican, y actualizarlos sin preguntar.

## Reglas de actualización de documentos

**Claude NUNCA actualiza documentos sin que lo pidan explícitamente**, excepto `PROJECT_STATE.md` al correr `/progress`.

| Si cambia... | Qué hacer |
|---|---|
| Stack, arquitectura o estructura de carpetas | `/update-context` |
| Estado del proyecto o próximos pasos | `/progress` (automático al cerrar) |
| Se resuelve un error que puede repetirse | "Agrega a docs/PROBLEMS.md: [error] — [solución]" |
| Se agrega un proyecto nuevo | Actualizar tabla de proyectos en este archivo + `EMPIEZA_AQUI.md` |
| Cambia una credencial | Editar `CREDENCIALES.md` + `.env.local` manualmente |
| Cambia algo del sistema de trabajo | Editar este archivo directamente |

**No sugerir actualizar docs al final de sesión** a menos que haya cambiado algo estructural (stack, arquitectura). El estado del proyecto lo maneja `/progress` solo.
