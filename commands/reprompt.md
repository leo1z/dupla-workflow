Ayuda a reformular el mensaje anterior para que sea más claro, corto y ahorre tokens.

El usuario escribió: /reprompt "$ARGUMENTS"

Si hay argumento → reformula ese texto.
Si no hay argumento → reformula el último mensaje del usuario en esta conversación.

Reglas del reprompt:
1. Máximo 3 líneas
2. Formato: Contexto (1 línea) + Necesito (1 línea) + Restricción (1 línea si aplica)
3. Elimina todo lo que Claude ya sabe por el CLAUDE.md del proyecto
4. Elimina saludos, disculpas, explicaciones de por qué
5. Deja solo lo que Claude NO puede inferir solo

Muestra:
- El reprompt optimizado listo para copiar
- Estimado de tokens ahorrados vs el original
- Una línea de qué eliminaste y por qué

No expliques qué es un buen prompt. Solo entrega el resultado.
