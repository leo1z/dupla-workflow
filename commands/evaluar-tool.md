Evalúa si vale la pena instalar la herramienta solicitada.

El usuario escribió: /evaluar-tool "$ARGUMENTS"

Ejecuta este análisis sin preguntar:

1. Identifica qué herramienta se está evaluando del argumento
2. Revisa el stack actual en CLAUDE.md del proyecto
3. Revisa ~/.claude/CLAUDE.md para ver qué tools ya están instaladas

Responde con este formato exacto:

---
## Evaluación: [nombre de la herramienta]

**Qué hace:** [1-2 líneas — qué resuelve]

**Veredicto:** ✅ INSTALAR / ⚠️ ESPERAR / ❌ NO INSTALAR

**Filtro aplicado:**
| Criterio | Resultado |
|---|---|
| ¿Resuelve problema real y actual? | Sí / No — [razón] |
| ¿Configurable en <30 min? | Sí / No — [razón] |
| ¿Reemplaza algo existente? | Sí ([qué reemplaza]) / No |
| ¿Tiene 6+ meses y buena doc? | Sí / No — [razón] |

**Si es un skill de Claude:**
- ¿Duplica un skill ya instalado? [Sí/No — cuál]
- ¿Lo usarías 3+ veces por semana? [Sí/No]

**Alternativa más simple si existe:** [nombre o "ninguna"]

**Próximo paso si decides instalar:** [instrucción concreta]

---

Sé directo. Si no debes instalarla, dilo claramente y da la razón principal.
