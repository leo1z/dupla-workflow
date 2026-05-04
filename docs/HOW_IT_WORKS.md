# How Dupla OS Works

Dupla OS es un **Harness (Arnés) de Markdown** para trabajar con Agentes de Inteligencia Artificial (Claude, Gemini, Cursor). Su propósito es obligar a los LLMs a trabajar con economía de tokens, sin "Context Bloat" y con máxima seguridad.

## 1. Principios Fundamentales
- **Context Engineering (Clean Windows)**: Cada subtarea se hace en una nueva ventana con el mínimo contexto necesario.
- **Tool-Result Clearing**: Después de leer archivos grandes, el agente debe resumirlos y olvidar el texto gigante para no gastar tokens inútilmente.
- **Spec-Driven**: Nunca se escribe código sin haber documentado antes el plan en `ROADMAP.md` y `PROJECT_STATE.md`.
- **Zero-Complacency Quality Gate**: El Agente Evaluador no asume que el código funciona solo con leerlo; exige que pases un test o comando que confirme que la solución es exitosa.
- **Human-In-The-Loop (Seguridad)**: El sistema nunca ejecutará acciones destructivas (ej. git push a main, modificar bases de datos o borrar archivos) sin pausarse y pedir confirmación explícita al usuario.

## 2. Flujo Básico (Cómo usarlo)

El flujo diario consiste de muy pocos comandos que puedes escribir desde tu IDE o consola:

- `/new-project`: Empieza un proyecto desde cero. El sistema evalúa tu idea mediante la metodología **ZOHAR/P2B** y te hace 7 preguntas clave para generar el `ROADMAP.md`.
- `/adapt-project`: Toma un repositorio que ya existe y le agrega la inteligencia y estructura de Dupla.
- `/new-session`: Úsalo cada vez que empieces a trabajar. Lee el `PROJECT_STATE.md` para entender el contexto instantáneo sin tener que leer todo el código del proyecto.
- `/checkpoint`: Cuando terminas tu tarea, ejecuta esto para guardar el progreso, hacer un commit en git de tu estado y actualizar el ROADMAP.
- `/research`: Inicia una investigación profunda donde el Planificador lanza sub-agentes exploradores en paralelo, los cuales resumen la información en la base de datos local sin saturar la memoria del chat.

## 3. ¿Cómo actúan los Agentes?
Dupla OS coordina (conceptualmente) tres agentes, incluso si usas un solo chat:
1. **El Planificador**: Lee el estado, decide la siguiente jugada y asigna el trabajo.
2. **El Implementador**: Recibe una tarea atómica, la cual extrae específicamente de la hoja de ruta (ROADMAP), la ejecuta sin contexto adicional y devuelve el código o la solución.
3. **El Evaluador**: Trata de "romper" la solución. Exige pruebas y comandos deterministas para declarar la tarea como terminada.

## 4. ¿Dónde están los datos?
Todos los datos de tu sesión viven en el sistema de archivos (tus Markdown), **no en el chat**. Si cierras el chat, no pierdes nada. El comando `/new-session` y la actualización automática (hooks) mantienen la base documental en sincronía con tu código.

## 5. Knowledge Graph
El sistema auto-genera un grafo de conocimiento de tu proyecto, que puedes consultar en `docs/code-review-graph.json` o usando el skill `/knowledge-graph`. El grafo se actualiza automáticamente gracias a los hooks.
