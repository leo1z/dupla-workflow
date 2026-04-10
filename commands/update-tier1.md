Actualiza el docs/tier1.md del proyecto actual para que refleje el estado real.

El tier1.md es el contexto mínimo (~300 tokens) para Claude Desktop. Debe ser preciso y compacto.

Ejecuta en orden:

1. Lee docs/tier1.md actual
2. Lee CLAUDE.md del proyecto
3. Ejecuta: git log --oneline -10

Identifica qué cambió:
- ¿El stack es el mismo?
- ¿Cambió la arquitectura clave o el schema?
- ¿Cambió el estado del proyecto (desarrollo/producción)?
- ¿Hay zonas prohibidas nuevas?

Muéstrame el diff de lo que cambiaría en tier1.md.
Espera mi aprobación antes de editar el archivo.

El tier1.md debe mantenerse en máximo 300 tokens (aproximadamente 250 palabras).
Si hay que elegir qué incluir: prioriza arquitectura crítica y zonas prohibidas sobre URLs y estado.
