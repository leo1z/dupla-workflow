Ejecuta una auditoría completa de coherencia del proyecto. Sin preguntas — solo analiza y reporta.

1. Lee: CLAUDE.md del proyecto, docs/ROADMAP.md, docs/PROBLEMS.md, docs/DECISIONS.md, ~/.claude/CREDENCIALES.md
2. Ejecuta: git branch, git log --oneline -20, git status

Genera este reporte:

---
## Auditoría de coherencia — [proyecto] — [fecha]

### Documentos
| Doc | Estado | Problema detectado |
|---|---|---|
| CLAUDE.md | ✅ Actualizado / ⚠️ Desactualizado | [qué falta o está mal] |
| ROADMAP.md | ✅ / ⚠️ | [descripción] |
| PROBLEMS.md | ✅ / ⚠️ | [descripción] |
| DECISIONS.md | ✅ / ⚠️ | [descripción] |

### Credenciales
| Credencial | Estado |
|---|---|
| GitHub Token | ✅ Activo / ⚠️ Revisar — creado hace [X días] |
| [otras credenciales encontradas en CREDENCIALES.md] | [estado] |

### Git
- Branch actual: [nombre]
- Branches sin mergear hace 2+ semanas: [lista o "ninguno"]
- Cambios sin commit: [sí/no]

### Discrepancias detectadas
[Lista de cosas que no coinciden entre docs y realidad del código]

### Acciones recomendadas (en orden de prioridad)
1. [la más urgente]
2. [siguiente]
3. [siguiente]

---

Sé específico. No pongas "parece estar bien" — verifica contra el código real.
Si no puedes verificar algo, dilo claramente: "No pude verificar [X] — requiere acceso a [sistema]."
