Dame un resumen ejecutivo del estado actual del proyecto. Sin preguntas — solo analiza y reporta.

1. Lee: CLAUDE.md del proyecto, ESTADO_PROYECTO.md si existe, git log --oneline -10
2. Genera un reporte con exactamente estas secciones (corto, sin relleno):

---
## Estado del proyecto: [nombre] — [fecha hoy]

**Rama actual:** [branch]
**Último commit:** [mensaje y fecha]

**Qué está funcionando en producción:**
[lista bullet — solo lo confirmado]

**En qué estamos trabajando:**
[branch activo y qué hace]

**Próximos 3 pasos:**
1. [el más urgente]
2.
3.

**Riesgos activos:**
[solo los que aparecen en los docs — si no hay, decir "ninguno documentado"]

**Credenciales pendientes de completar:**
[revisar ~/.claude/CREDENCIALES.md y listar las que tienen ⚠️]
---

No agregues secciones extra. No especules sobre lo que no está documentado.
