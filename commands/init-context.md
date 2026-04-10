Genera un Context Pack completo para este proyecto.

Sigue exactamente este proceso:

1. Lee el template en: C:/Users/Leo Borjas/Projects/AI_CONTEXT_TEMPLATE/CONTEXT_PACK_TEMPLATE.md

2. Explora el proyecto actual:
   - Estructura de carpetas (1 nivel de profundidad)
   - package.json o equivalente (para detectar stack)
   - README.md si existe
   - Archivos de configuración relevantes (.env.example, docker-compose, etc.)

3. Genera un archivo CLAUDE.md en la raíz del proyecto con todas las secciones
   del template llenadas con información real del proyecto.

4. Para cada sección:
   - Si puedes inferirla del código → llénala
   - Si requiere info que solo el usuario sabe (credenciales, URLs, decisiones) → deja [PENDIENTE]

5. Al terminar, lista en un mensaje corto:
   - Secciones completadas automáticamente
   - Secciones que quedaron como [PENDIENTE] y qué información necesitas para completarlas

El archivo final debe funcionar como contexto completo para cualquier AI.
No inventes datos — es mejor dejar [PENDIENTE] que poner información incorrecta.
