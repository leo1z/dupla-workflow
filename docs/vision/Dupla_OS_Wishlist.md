#Dupla OS
Un sistema que ayuda a las personas a desarrollar ideas, servicios o SaaS de forma fácil local y remota con AI



## Forma de usarlo:
- Chat (Slack, Whatsapp, Telegram)
- Computadora / IDE (VSCode, Antigravity, Jupyer, etc)
- Terminal (CLI)

## Objetivos: 
- Ser un sistema operativo que ayude a las personas o empresas a desarrollar ideas, servicios o SaaS de forma fácil local y remota con AI
- Poder funcionar también como segundo cerebro 


## Características Clave:  
- Ser lo más personalizado posible para el usuario 
- Ser open-source
- Facíl de Instalar Plug and Play 
- Agnóstico al IDE o Sistema Operativo
- Ser capaz de usar diferentes modelos de AI (OpenAI, Anthropic, Google, etc)  
- El sistema tiene que poder usarse para Investigación /Desarrollo/ Evaluador de Proyectos, Para uso normal pero con ahorro de tokens y para Second Brain


## Procesos Clave: 
- Poder iniciar sesión y retomar de donde nos quedamos
- Poder cerrar sesión y retomar en cualquier momento
- Poder añadir y quitar tools de forma fácil 
- Poder update el sistema de forma fácil
- Adaptarse fácil al modo colaborativo
- Poder tener acceso a internet local y remota para mejorar la calidad de las respuestas 
- Poder cambiar modos de trabajo:
a. Personal o Colaborativo:
i. Modo Research
ii.Modo desarrollo lite
iii. Modo desarrollo completo


## Parámetros de Efectividad y Eficiencia:
- Ingeniería de Contexto Nativa en Markdown 
- Spec-Driven Development
- Orquestación de 3 Agentes (Planificador, Generador y Evaluador/Debugger como Quality Gate)
- Tool-Result Clearing (Limpieza de resultados de tools)
- Memoria "Just-in-Time" (Evitar la sobrecarga de contexto)
- Compacting (Poder hacer un resume del proyecto cada cierto tiempo para ahorrar costos y mejorar el rendimiento)
- Usar MCP como USB universal de herramientas (Para que sea compatible con cualquier IDE o Tool)
- Skills en Markdown como estándar de las skills
- Hooks para automatizar tareas
- Risk Based Access Control (RBAC) 
- Sandboxing para evitar que las herramientas tengan acceso a información sensible
- Human in the Loop (Poder pedir confirmación antes de realizar una acción crítica)
- Testing Automatizado (Tipo Puppeteer o Playwright) 
- Archivos de aprednizaje contínuo
- Poder integrar segundo cerebro de forma natural como Notion, Obsidian, etc. 
- Poder integrar N8N para automatizaciones externas o para ahorrar tokens 
- Implementar seguridad como OWASP Top 10, etc
- Estructura de carpetas organizada y estandarizada para que sea fácil de usar
- Progressive Disclosure 
- Tool Search and Validation 
- Apoyarse en Herramientas Nativas Generales
- Trabajo en paralelo de subagentes
- Uso de Git como base para el control de versiones y colaboración
- Evitar Over-Engineering 
- Sistema de roles y permisos para el modo colaborativo 
- Economía Extrema de Tokens 
- Comunicación entre agentes eficiente
- Composición dinámica del sistema 
- Hooks de Ciclo de Vida
- Firewall de Prompts
- Pocos comandos para manejar todo el sistema 
- Poder adaptar cualquier skill para que funcione con cualquier LLM / MCP según los requerimientos o estándares que tenga el LLM o MCP


## Evitar: 
- Evitar Context Rotting (Para que la memoria no se degrade con el tiempo)
- Evitar LLM Hallucinations
- Evitar Context Bloat (Sobrecarga de contexto que hace que el LLM no sepa qué información usar)
- Evitar Feedback Loops (Cuando el LLM se contradice a sí mismo)
- Evitar Loss of Agency (Cuando el LLM toma decisiones sin consultar o sin seguir las instrucciones)
- Evitar Over-Reliance (Cuando el LLM depende demasiado de sus propias herramientas y no consulta a fuentes externas)
- Evitar Unconstrained Growth (Cuando el LLM crea archivos o carpetas sin permiso o sin seguir las instrucciones)
- Evitar Over-Extension (Cuando el LLM trata de hacer cosas que están fuera de su alcance o fuera de su conocimiento)
- Evitar Overengineering (Cuando el LLM trata de hacer cosas demasiado complejas o innecesarias)
- Evitar Over-Optimism (Cuando el LLM es demasiado optimista sobre sus capacidades o sobre el tiempo que tomará una tarea)
- Evitar Over-Planning (Cuando el LLM trata de planificar demasiado o de planificar cosas que no son necesarias)
- Evitar Loss of Context (Cuando el LLM pierde el contexto de la tarea que está realizando)
- Evitar Loss of Focus (Cuando el LLM pierde el enfoque de la tarea que está realizando)
- Evitar Loss of Attention (Cuando el LLM pierde la atención de la tarea que está realizando)
- Evitar Loss of State (Cuando el LLM pierde el estado de la tarea que está realizando)
- Evitar Complacence (Cuando el LLM se vuelve complaciente y deja de esforzarse)
- Evitar Síndrome de One-Shot y Fallos en Cascada 
- Evitar gastos innecesarios de tokens o falsa ilusión de ahorro 


## Frameworks Clave
- Identificación de Problemas Reales (First Principles)
- Identificación de Madurez de Idea para saber si se debe construir o no o en que etapa está (dentificar Gaps, Problemas, Soluciones, Personas, Sistemas, Fricciones, etc)
- Desarrollo par MVP cuando sea un proyecto, servicio o SaaS que se esté desarrollando 
- Roadmap dinámico con fases de ejecución (Spec-Driven Development) & Checkpoints para validar avances
- OODA Loop 
- MOSCOW Method (Kanban) para priorizar tareas Must, Could, Should, Won't/ Want (Este sistema es creado por mi)
- Project-State Management (Para mantener el estado del proyecto)
- Claude.md o Antigravity.md o similar para contexto global  
- SEEQ (Style, Effectiveness, Efficiency, and Quality of Life Implementations) para refinamiento de sistemas (Refinar el sistema de forma iterativa) (Este sistema es creado por mi)
- PARA Method (Projects, Areas, Resources, Archive) para organización de información y tareas para el second brain
- Extrapolar (Extrapolar ideas o soluciones de un dominio a otro para encontrar nuevas perspectivas, validando que tan ejeuctable, transferible y retorno da la extrapolación)
- ZOHAR Method sistema para evaluar y priorizar tareas rápidamente combinando Responsabilidad, Facilidad de Inicio, Tiempo y Retorno Emocional para ubicarlo en 4 zonas diferentes de acción: 
a. Propulsor (Alto impacto y fácil de empezar - Hacer ya)
b. Playground (Fácil y motivante - Usar para arrancar o en rachas)
c. Escalera (Importante pero cuesta - Agendar y avanzar por partes)
d. Plana (Bajo impacto y baja motivación - Delegar o posponer)
Se usa al Listar pendientes, Evaluar cada uno , Obtener Puntaje, Definir la zona de acción a realizar, Ayudar al usuario a definir que hacer con cada tarea según su zona de acción. 
 (Este sistema es creado por mi)
- P2B Method (Phase 2 Build) - Metodología ágil para desarrollo de software que se enfoca en la construcción rápida y eficiente de productos viables, priorizando la velocidad y la simplicidad sobre la perfección, y utilizando un enfoque de desarrollo iterativo y incremental para entregar valor al cliente de forma continua.

## Recursos a Evaluar para mejorar el OS
- https://roadto.pm/p/supercharge-claude-with-internet para dar acceso a internet a claude de forma controlada 
- https://github.com/HKUDS/OpenSpace para mejorar el sistema de organización y gestión de proyectos, tareas, información, etc
- https://github.com/opensesh/KARIMO como inspiración de Harness 
- https://github.com/HKUDS/CLI-Anything 
- https://graphify.net/ para mejorar la visualización del sistema de organización y gestión de proyectos, tareas, información, etc
-https://github.com/browser-use/browser-harness para mejorar el control de navegadores web 
- https://github.com/vercel-labs/agent-browser 
- https://github.com/czlonkowski/n8n-mcp para integrar n8n al sistema 
- https://github.com/cathrynlavery/diagram-design para mejorar la creación de diagramas 
- https://github.com/karpathy/autoresearch para mejorar la capacidad de investigación del sistema 
- https://github.com/meleantonio/ChernyCode para mejorar la interacción con el usuario 

## Requisitos de OS
- Sistema Modular y Extensible
- Sistema que se adapta a los nuevos cambios
- Sistema que pueda usarse para diferentes propósitos (Investigación / Desarrollo / Evaluación / Second Brain)
- Sistema que pueda usarse con diferentes modelos de AI (OpenAI, Anthropic, Google, etc) 
- Sistema que pueda usarse en diferentes IDEs o Sistemas Operativos
- Sistema que sea de bajo costo operativo
- Sistema que permita integrar herramientas externas de forma controlada (MCP / API / Tools, etc)
- Sistema que permita usar herramientas nativas o externa segun se requiera
- Sistema que permita el trabajo en paralelo de subagentes
- Sistema que permita la comunicación eficiente entre agentes
- Sistema que permita la composición dinámica del sistema
- Sistema que permita hooks de ciclo de vida
- Sistema que permita firewall de prompts
- Sistema que permita pocos comandos para manejar todo el sistema
- Sistema que permita adaptar cualquier skill para que funcione con cualquier LLM / MCP según los requerimientos o estándares que tenga el LLM o MCP
- Sistema que no dependa de la disciplina del usuario para usar comandos 
- Sistema con guías prácticas para poder usarlo 
- Sistema fácil de instalar y que provea las instrucciones para hacerlo
- El Sistema que sea Open-source y distribuido

## REGLAS EXTRA
- El sistema reconozca modos de trabajo, etapas de maduración de idea, etapas de proyecto y si es individual o en equipo, y se adapte a ello
- El sistema pueda leer documentos de forma eficiente
- El sistema se adapte facilmente a actualizaciones y cambios
- Se fácil de actualizar y adaptar los proyectos sin perder data o info valiosa 
- Poder usar y saltar de LLM en LLM sin afectar nada y con un handsoff correcto y automático 
- El sistema entienda las capacidades de las extensiones de los LLM en los IDE, Terminal y Chat y adapte su forma de trabajar a ello
- Que el sistema funcione como un arnés que solo es de conectarle cualquier cerebro y motor para que funcione pero el workflow y sistema de archivos markdown funcione siempre

## Validar Funcionamiento de Sistema
- Que no quedó ningun documento, comando o archivo que pueda confundir o desactualizado
- Hooks funcionales en cualquier OS
- Que la guía de uso sea clara y precisa
- Poder saltar de LLM a LLM con un handsoff efectivo automático sin romper nada
- Poder iniciar un nuevo proyecto o darle seguimiento
- Poder instalar el sistema y crear los docs y carpetas necesarios en ubicaciones recomnedadas, encontradas o sugeridas por el usuario 
- Poder actualizar el sistema sin romper nada 
- Que cree los skills y conexiones necesarias en el nuevo LLM o MCP o IDE seleccionado 
- Que el sistema reconozca cuando se está usando un MCP o una extensión de un LLM y se adapte a ello
- Que el sistema trabaje con git para guardar el estado del proyecto
- Que se pueda seleccionar o auto reconocer el modo de trabajo y si es individual o en equipo
- Que las entrevistas funcionen 
- Que realmente tenga la función de trabajar multi agente
- Que el agente Evaluador pueda ser objetivo y realista  
- Que pueda crear las actualizaciones a los documentos automáticamente
- Que el sistema entienda como funciona Claude / Gemini / ChatGPT / Perplexity / Cursor / OpposesiveAI / etc con respecto al manejo de contexto y agentes y se adapte a ello 
- Que el sistema funcione como un arnés que solo es de conectarle cualquier cerebro y motor para que funcione pero el workflow y sistema de archivos markdown funcione siempre
- Valida los flujos del usuario cuando instala o actualiza Dupla OS, comienza un nuevo proyecto pequeño o grande, inicia una sesión de trabajo, cambia de LLM, se le olvida usar checkpoint, tiene que actualizar DUpla OS y todos sus documentos relacionados en sus proyecto y globales pero de forma automática
- Que el usuario haga lo menos manual posible para que el sistema funcione 