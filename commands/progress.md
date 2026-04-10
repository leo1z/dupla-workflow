Cierra la sesión de trabajo. Marca progreso, detecta ciclos, actualiza el roadmap.

El usuario escribió: /progress

Ejecuta en este orden:

1. Ejecuta en terminal: git log --oneline -10, git status, git diff --stat
2. Lee docs/ROADMAP.md

Luego responde con este formato exacto:

---
## Sesión cerrada — [fecha hoy]

**Commits de esta sesión:**
[lista los commits desde el /goal de hoy, o "ningún commit registrado"]

**Completado:**
- [lo que se hizo según commits — si no hay commits, decir "nada commiteado"]

**Detección de ciclos:**
[Revisa la conversación actual. Si el mismo error, archivo o pregunta aparece 3+ veces sin resolverse → "⚠️ CICLO DETECTADO: [descripción exacta]. Recomendación: cierra esta conversación, abre una nueva, describe el problema desde cero en máximo 3 líneas."]
[Si no hay ciclo → "Ninguno detectado"]

**Para mañana:**
- [ ] [próximo paso concreto del ROADMAP]

---

Después del resumen, sin esperar confirmación:
1. Actualiza docs/ROADMAP.md — mueve lo completado a ✅, actualiza lo pendiente
2. Muestra el diff exacto de ROADMAP.md
3. Si no hubo commits: escribe "⚠️ No hay commits. Antes de cerrar ejecuta: git add . && git commit -m 'wip: [descripción]' && git push"
4. Si sí hubo commits: escribe "Ejecuta: git push" si no se hizo push aún
