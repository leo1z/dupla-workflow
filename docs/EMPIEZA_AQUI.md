# EMPIEZA AQUÍ — Leo Borjas
> Si no sabes qué abrir, abre este. Última actualización: 2026-04-12

---

## ¿Qué quieres hacer?

| Quiero... | Ir a... |
|---|---|
| Iniciar un proyecto nuevo | GUIAS_TRABAJO.md → Sección 1 |
| Continuar un proyecto existente | GUIAS_TRABAJO.md → Sección 2 |
| Iniciar o cerrar sesión de trabajo | GUIAS_TRABAJO.md → Sección 3 |
| Entender cómo está organizado todo | GUIAS_TRABAJO.md → Sección 0 |
| Hacer deploy | GUIAS_TRABAJO.md → Sección 6 |
| Algo no funciona | GUIAS_TRABAJO.md → Sección 7 |
| Entender la arquitectura del sistema | SISTEMA.md |

---

## El sistema en 5 líneas

1. Cada proyecto vive en `Projects/[nombre]/` y tiene su propio `CLAUDE.md`
2. Empiezas cada sesión con `/goal "objetivo"` y la cierras con `/progress`
3. GitHub es la fuente de verdad — siempre `git push` antes de cerrar
4. Nunca trabajas en `main` — siempre en `work/nombre-de-lo-que-haces`
5. Claude en VS Code ya es un agente — pídele que *haga* las cosas, no que te *explique* cómo

---

## Los 4 skills (los únicos que existen)

| Comando | Cuándo usarlo |
|---|---|
| `/goal "objetivo"` | Al INICIAR sesión — obligatorio |
| `/progress` | Al CERRAR sesión — obligatorio |
| `/init-context` | Una vez al crear un proyecto nuevo |
| `/update-context` | Cuando cambia el stack o la arquitectura |
| `/health-check` | Auditoría del sistema — cada 2-4 semanas |

---

## Proyectos activos

| Proyecto | Carpeta local | GitHub | URL |
|---|---|---|---|
| Dupla Conecta | `Projects/dupla-conecta/` | leo1z/dupla-conecta | getdupla.com |
| Maratón | `Projects/maraton/` | leo1z/maraton | VPS solamente |
| Microdetective | `Projects/microdetective/` | leo1z/microdetective | [PENDIENTE — Vercel] |
