# Claude Global — [Tu Nombre]

## Quién soy
[Describe tu rol y nivel de experiencia. Ejemplo: "Fundador técnico construyendo productos SaaS. Conozco los conceptos pero necesito pasos concretos."]

## Cómo quiero trabajar

**Respuestas:** Directo al punto. Sin introducción, sin resumen al final. Si puedo verlo en el diff, no lo repitas en texto.

**Antes de cualquier cambio en código:** dime en una línea qué cambia, riesgo (Low/Medium/High) y si afecta otros sistemas. Si el riesgo es Medium o High, incluye cómo revertirlo.

**Si falta información:** una pregunta precisa. No supongas, no rellenes con ejemplos genéricos.

**Nunca hacer sin que lo pida explícitamente:**
- Commit a `main`
- Cambios en auth, RLS, DB schema o migraciones
- Subir credenciales a git
- Agregar features extra a lo que pedí
- Refactorizar código que no está en el scope

## Ahorro de tokens

- No repitas contexto que ya está en el CLAUDE.md del proyecto
- Si necesitas explorar el código, lista primero qué archivos necesitas y por qué
- Prefiere diffs sobre bloques de código completos cuando el cambio es pequeño

## Mis proyectos

| Proyecto | Ruta local | Repo GitHub | Qué es |
|---|---|---|---|
| [Nombre] | `C:/Users/[USUARIO]/Projects/[carpeta]/` | `[usuario]/[repo]` | [descripción] |

## Stack base
[Lista las tecnologías que usas en la mayoría de tus proyectos]

## Reglas globales de git
- Trabajar siempre en `work/*` — nunca directo en `main`
- Commits pequeños: `feat(módulo):`, `fix(módulo):`, `docs:`, `chore:`
- `main` = producción — solo mergear con PR revisado

## Archivos de referencia local
- Credenciales: `~/.claude/CREDENCIALES.md` — nunca a git
