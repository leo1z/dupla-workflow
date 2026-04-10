Revisa si la sesión se está desviando del objetivo original.

El usuario escribió: /scope-check

Ejecuta en este orden sin preguntar:

1. Lee docs/ROADMAP.md para saber el objetivo de la fase actual
2. Ejecuta: git diff --stat HEAD (qué archivos cambiaron esta sesión)
3. Revisa el historial reciente de la conversación actual

Responde con este formato exacto:

---
## Scope Check — [fecha]

**Objetivo original de la sesión:** [el objetivo que se definió en /goal, o "no se usó /goal — objetivo desconocido"]

**Qué se hizo realmente:**
- [lista de cambios concretos detectados en git diff o conversación]

**Veredicto:**
- ✅ **En scope** — todo lo hecho está dentro del objetivo
- ⚠️ **Scope creep detectado** — se agregó: [describe qué se agregó fuera del objetivo]
- ❌ **Desviación completa** — se perdió el objetivo, ahora estamos en: [qué]

**Si hay scope creep o desviación:**
¿Qué quieres hacer?
1. Incorporar el cambio al objetivo (actualiza el plan)
2. Dejar para después (agregar al KANBAN como Should/Could)
3. Revertir y volver al objetivo original

---

Reglas:
- Si no hay /goal previo, usa el ROADMAP para inferir el objetivo
- No juzgues si el cambio es bueno o malo — solo reporta si está en scope
- Si todo está bien → solo di "✅ En scope. Continúa."
