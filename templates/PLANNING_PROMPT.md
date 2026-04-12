# Prompt: Planificación de Proyecto Nuevo

Pega la sección **"PROMPT A COPIAR"** en Claude o ChatGPT.
El AI te hará las preguntas una a una y al final te dará:
1. Un **plan del proyecto** (nombre, features MVP, riesgos)
2. Un bloque **`proyecto.config`** listo para correr el script de setup

Guarda el bloque `.config` como `[nombre].config` y luego:

```bash
bash nuevo-proyecto.sh --config [nombre].config
```

---

## PROMPT A COPIAR

```
Eres un Product Strategist técnico. Voy a crear un proyecto de software nuevo y necesito planificarlo antes de hacer el setup técnico.

Hazme estas preguntas UNA A LA VEZ — espera mi respuesta antes de continuar con la siguiente. No las hagas todas juntas.

PREGUNTAS:

1. ¿Qué problema resuelve este proyecto? (1-3 oraciones, sé específico)

2. ¿Quién lo usa? Describe el usuario principal y su contexto.

3. ¿Cuáles son las 3-5 features del MVP más importantes? (las mínimas para que sea útil)

4. ¿Hay algún deadline, constraint técnico o dependencia importante que deba considerar?

5. ¿Qué tipo de proyecto es?
   - (1) SaaS web — Next.js + Supabase + Vercel
   - (2) Script / Automatización — Node.js + VPS
   - (3) API backend — Node.js o FastAPI
   - (4) Otro — me describes el stack

6. ¿Qué servicios externos necesita? (responde s/n para cada uno)
   - Supabase (base de datos / auth)
   - Vercel (deploy web)
   - VPS Hostinger (servidor propio)
   - N8N (automatizaciones / workflows)
   - Evolution API (WhatsApp)

7. ¿Qué partes son CRÍTICAS y la AI NO debe modificar sin pedir permiso explícito?
   (Ejemplos: auth, schema de base de datos, lógica de pagos, integraciones de terceros)

---

Cuando tengas todas mis respuestas, genera esto:

### PLAN DEL PROYECTO

**Nombre sugerido:** [nombre-sin-espacios-guiones-ok]
**Qué hace:** [1-2 oraciones]
**Usuario:** [quién lo usa]

**Features MVP:**
- [ ] ...
- [ ] ...
- [ ] ...

**Riesgos / dependencias técnicas:**
- ...

**Stack recomendado:** [justifica brevemente si el tipo elegido es el correcto]

---

### CONFIGURACIÓN LISTA PARA EL SCRIPT

Guarda este bloque como `[nombre].config` y corre:
`bash nuevo-proyecto.sh --config [nombre].config`

\`\`\`ini
PROJECT_NAME=[nombre-sin-espacios]
PROJECT_DESC=[descripción en 1-2 oraciones]
PROJECT_TYPE=[1|2|3|4]
FORBIDDEN=[zonas prohibidas separadas por coma, o "ninguna"]
USE_SUPABASE=[s|n]
USE_VERCEL=[s|n]
USE_VPS=[s|n]
USE_N8N=[s|n]
USE_EVOLUTION=[s|n]
\`\`\`
```

---

## Ejemplo de output esperado

### PLAN DEL PROYECTO

**Nombre sugerido:** agenda-clientes
**Qué hace:** SaaS para que consultores gestionen su agenda de clientes con recordatorios automáticos por WhatsApp.
**Usuario:** Consultores independientes que manejan 10-50 clientes y quieren reducir no-shows.

**Features MVP:**
- [ ] CRUD de clientes con datos de contacto
- [ ] Calendario de citas
- [ ] Recordatorio automático por WhatsApp 24h antes
- [ ] Dashboard de asistencia

**Riesgos / dependencias técnicas:**
- Depende de Evolution API para WhatsApp — validar que la instancia esté activa antes de desarrollar la integración
- La lógica de recordatorios requiere un cron job — considerar si va en N8N o en el servidor

---

### CONFIGURACIÓN LISTA PARA EL SCRIPT

```ini
PROJECT_NAME=agenda-clientes
PROJECT_DESC=SaaS para que consultores gestionen su agenda con recordatorios automáticos por WhatsApp
PROJECT_TYPE=1
FORBIDDEN=auth, schema de DB, lógica de pagos
USE_SUPABASE=s
USE_VERCEL=s
USE_VPS=n
USE_N8N=s
USE_EVOLUTION=s
```
