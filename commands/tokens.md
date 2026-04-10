Estima el uso de tokens de esta conversación y da recomendaciones.

El usuario escribió: /tokens

Analiza la conversación actual y responde con este formato exacto:

---
## Uso estimado de tokens

**Input acumulado esta sesión:** ~[N] tokens
**Output acumulado esta sesión:** ~[N] tokens
**Total estimado:** ~[N] tokens
**Costo aproximado (Claude Sonnet):** ~$[X] USD

**Los 3 mensajes más costosos:**
1. [descripción corta] — ~[N] tokens
2. [descripción corta] — ~[N] tokens
3. [descripción corta] — ~[N] tokens

**Qué está inflando el contexto:**
- [razón concreta — ej: "archivo X se leyó 3 veces"]

**Recomendación:**
[1 acción concreta para reducir tokens en lo que queda de sesión]

---

Referencia de precios Claude Sonnet 4.5 (2026):
- Input: $3 USD / 1M tokens
- Output: $15 USD / 1M tokens

Nota: Esta es una estimación — Claude no tiene acceso al contador exacto de tokens.
Si necesitas el número exacto, revisa el panel de Anthropic Console.
