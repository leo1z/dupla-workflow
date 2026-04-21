Cierra la sesión de trabajo. Actualiza PROJECT_STATE.md con el estado real.

El usuario escribió: /progress

Ejecuta en este orden:

1. Ejecuta: git log --oneline -10, git status --short
2. Lee docs/PROJECT_STATE.md
3. Revisa la conversación actual para extraer:
   - Errores que aparecieron (aunque no estén en commits)
   - Decisiones tomadas ("vamos a usar X", "descartamos Y")
   - Trabajo a medias o bloqueadores detectados
   - Cualquier contexto que importa para la próxima sesión

4. Haz UNA sola pregunta antes de actualizar:
   "¿Hay algo que no quedó en los commits que deba recordar para la próxima sesión? (Enter para omitir)"

5. Con todo eso, actualiza docs/PROJECT_STATE.md (usar estructura del template):
   - "Current Goal": objetivo actual de la sesión
   - "Status": estado en 1-2 líneas
   - "In Progress": branch actual + qué quedó pendiente REAL
   - "Next Steps": Must/Should/Could — ajusta con pendientes, errores sin resolver, bloqueadores
   - "Blockers": bloqueos reales
   - "Recent Changes": agrega lo completado hoy (últimos 3-5)
   - "Sync Status": branch, comparado con main, ready to merge
   - Si hubo errores resueltos que no están en PROBLEMS.md → agregarlos automáticamente

Responde con máximo 10 líneas:

---
## Sesión cerrada — [fecha]

**Completado hoy:**
- [basado en commits + conversación]

**Quedó pendiente:**
- [trabajo a medias, errores sin resolver, bloqueadores]

**Próxima sesión arranca en:**
- [el paso concreto más inmediato]

---

Reglas:
- Sin push → "⚠️ Ejecuta: git add . && git commit -m 'wip: [descripción]' && git push"
- Con push pendiente → "Ejecuta: git push"
- Ciclo detectado (mismo error/archivo 3+ veces sin resolver) → mencionarlo explícitamente en "Quedó pendiente"
- PROJECT_STATE.md debe quedar útil para alguien que nunca vio la sesión — no solo para ti
