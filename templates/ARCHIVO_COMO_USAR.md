# Cómo usar el Context Pack Template

## Opción A — Usarlo directamente (manual)

1. Copia `CONTEXT_PACK_TEMPLATE.md` a tu nuevo proyecto
2. Renómbralo a `CLAUDE.md` si vas a trabajar con Claude Code
3. Llena todas las secciones (deja `[PENDIENTE]` donde no tengas info aún)
4. Listo. Claude lo leerá automático en cada conversación

---

## Opción B — Convertirlo en Skill de Claude Code

Un **skill** es un comando `/algo` que puedes invocar dentro de Claude Code.
Cuando lo usas, Claude ejecuta un prompt predefinido — en este caso, generaría
el Context Pack de un proyecto nuevo automáticamente.

### Paso 1 — Crear la carpeta de skills

Los skills se guardan en:
```
C:/Users/Leo Borjas/.claude/commands/
```

Si no existe, créala manualmente o con Claude Code.

### Paso 2 — Crear el archivo del skill

Crea el archivo:
```
C:/Users/Leo Borjas/.claude/commands/init-context.md
```

Con este contenido:

```markdown
Genera un Context Pack completo para este proyecto siguiendo el template en:
C:/Users/Leo Borjas/Projects/AI_CONTEXT_TEMPLATE/CONTEXT_PACK_TEMPLATE.md

Pasos:
1. Lee el template completo
2. Explora el proyecto actual (estructura de carpetas, package.json, README si existe)
3. Genera un CLAUDE.md en la raíz del proyecto con todas las secciones del template
   llenadas con la información real del proyecto
4. Para secciones que no puedas inferir del código, deja [PENDIENTE] y lista
   al final qué información me falta para completarlas
5. No inventes credenciales ni URLs — usa [PENDIENTE] para esas secciones

El archivo generado debe estar listo para usarse como contexto con cualquier AI.
```

### Paso 3 — Usarlo

En cualquier proyecto nuevo, abre Claude Code y escribe:
```
/init-context
```

Claude explorará el proyecto y generará el `CLAUDE.md` llenado automáticamente.

---

## Cuándo actualizar el Context Pack

| Evento | Qué actualizar |
|---|---|
| Nueva feature completada | Sección 8 (Roadmap) |
| Bug importante resuelto | Sección 9 (Log de problemas) |
| Cambio de arquitectura | Secciones 3, 4, 5 según corresponda |
| Nueva variable de entorno | Sección 6 (Credenciales) |
| Decisión técnica tomada | Sección 3 (decisiones) o 10 (pendientes) |
| Nuevo colaborador | Revisar todo, especialmente secciones 0 y 7 |

**Regla simple:** Si en 3 meses alguien nuevo (o tú mismo) lee el Context Pack
y puede entender el proyecto sin preguntar nada — está bien mantenido.
