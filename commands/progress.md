Cierra la sesión de trabajo. Marca progreso y actualiza PROJECT_STATE.md.

El usuario escribió: /progress

Ejecuta en este orden:

1. Ejecuta en terminal: git log --oneline -10, git status
2. Lee docs/PROJECT_STATE.md (si no existe → leer docs/ROADMAP.md como fallback)

Luego actualiza docs/PROJECT_STATE.md de esta forma:
- En "En progreso ahora": reemplaza con el estado actual (branch + qué quedó pendiente)
- En "Completado recientemente": agrega al inicio lo que se hizo hoy según los commits (formato: "[fecha] — [descripción]")
- En "Próximos pasos": ajusta según lo que quedó pendiente

Después de actualizar, responde con este formato (máximo 10 líneas):

---
## Sesión cerrada — [fecha hoy]

**Commits de esta sesión:**
[lista los commits de hoy, o "ningún commit registrado"]

**Completado:**
- [lo que se hizo — basado en commits]

**Próximo paso:**
- [ ] [el primer Must de PROJECT_STATE.md]

---

Reglas de cierre:
- Si no hubo commits: "⚠️ No hay commits. Antes de cerrar: git add . && git commit -m 'wip: [descripción]' && git push"
- Si sí hubo commits pero no hay push: "Ejecuta: git push"
- Si detectas el mismo archivo o error 3+ veces en la conversación sin resolverse: "⚠️ Posible ciclo con [descripción]. Considera abrir nueva conversación."
- Sin reporte largo — solo actualiza PROJECT_STATE.md y muestra el resumen de 10 líneas
