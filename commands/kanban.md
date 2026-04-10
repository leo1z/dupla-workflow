Muestra o actualiza el Kanban del proyecto actual.

El usuario escribió: /kanban "$ARGUMENTS"

Si no hay argumento → muestra el kanban actual (lee docs/KANBAN.md)

Si hay argumento → interpreta la instrucción y actualiza el kanban:
- "agrega [tarea] como Must/Should/Could/Won't" → agrega en la columna correcta
- "mueve [tarea] a Should" → mueve la tarea
- "marca [tarea] como completada" → mueve a ✅ Completado con fecha de hoy
- "¿qué hay en el kanban?" → muestra resumen por columna

Si docs/KANBAN.md no existe → créalo desde el template con las tareas que encuentres en ROADMAP.md como punto de partida, organízalas en Must/Should/Could según urgencia, y muéstrame el resultado antes de guardar.

Siempre muestra el estado actual del kanban después de cualquier cambio.
Formato de respuesta: solo el kanban actualizado + "Guardado en docs/KANBAN.md"
