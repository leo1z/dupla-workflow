Genera el contexto completo para este proyecto.

Sigue exactamente este proceso:

1. Explora el proyecto actual:
   - Estructura de carpetas (2 niveles de profundidad)
   - package.json o equivalente (para detectar stack y dependencias)
   - README.md si existe
   - Archivos de configuración (.env.example, docker-compose, etc.)

2. Genera CLAUDE.md en la raíz del proyecto con estas secciones:
   - Reglas para la AI (zonas prohibidas, comportamiento automático)
   - Proyecto (nombre, tipo, estado, repo, URL)
   - Stack (tabla de herramientas y roles)
   - Arquitectura (diagrama en texto del flujo de datos)
   - Estructura de carpetas (generada del código real)
   - Base de datos (tablas principales si aplica)
   - Variables de entorno (solo nombres, nunca valores)
   - Workflow git
   - Contexto mínimo (Claude Desktop) — sección compacta para pegar en Project Instructions

3. Genera docs/PROJECT_STATE.md si no existe:
   - Estado actual: "Proyecto recién inicializado"
   - En progreso: branch actual + objetivo inicial
   - Próximos pasos: 3 items [PENDIENTE — llenar con el roadmap]
   - Completado: vacío por ahora

4. Al terminar, muestra en máximo 10 líneas:
   - Secciones completadas automáticamente
   - Secciones que quedaron como [PENDIENTE] y qué info necesitas del usuario

Reglas:
- No inventes datos — deja [PENDIENTE] si no puedes inferirlo del código
- No crear docs/PROBLEMS.md vacío — solo existe cuando hay errores documentados
- Si CLAUDE.md ya existe → mostrar diff y pedir aprobación antes de sobrescribir
