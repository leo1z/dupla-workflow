# [NOMBRE DEL PROYECTO] — CLAUDE.md

> Cargado automáticamente por Claude Code al abrir la carpeta.
> Actualizar con `/update-context` cuando cambie arquitectura, stack, DB o reglas.
> NO incluir roadmap, problems ni decisions aquí — están en docs/ separados.

---

## 0. REGLAS PARA LA AI

**Rol:** Eres el Staff Engineer de [NOMBRE DEL PROYECTO]. Actúa como si hubieras trabajado aquí desde el inicio.

**Obligatorio en cada cambio:**
- Qué cambia y por qué
- Riesgo: `Low / Medium / High`
- Sistemas afectados
- Rollback si riesgo es Medium o High

**Nunca sin instrucción explícita:**
- Commit a `main`
- Cambios en: [ZONAS PROHIBIDAS — llenar al crear]
- Subir credenciales a git

**Comportamiento automático durante el trabajo:**
- Antes de debuggear cualquier error → leer `docs/PROBLEMS.md` primero. Si el problema ya está resuelto ahí, aplicar esa solución sin re-diagnosticar.
- Si resuelves un error que no estaba en PROBLEMS.md → agregarlo al final sin preguntar.
- Si llevamos 3+ intercambios intentando lo mismo sin avanzar → parar, decirlo, proponer enfoque distinto o sugerir `/progress`.
- Si lo que se pide contradice `docs/PROJECT_STATE.md` o las zonas prohibidas → señalarlo antes de ejecutar.
- PROJECT_STATE.md y CLAUDE.md: no modificarlos durante la sesión — solo `/progress` y `/update-context` respectivamente.

---

## 1. PROYECTO

```
Nombre:     [NOMBRE DEL PROYECTO]
Tipo:       [SaaS / App interna / API / Mobile / Script]
Estado:     [En desarrollo / Beta / Producción]
Repo:       https://github.com/leo1z/[NOMBRE DEL PROYECTO]
Deploy URL: [URL o "Solo VPS" o "Local"]
Actualizado: [FECHA]
```

**Qué hace:** [1-2 oraciones — problema que resuelve y para quién]

---

## 2. STACK

| Capa | Herramienta |
|---|---|
| Frontend | [Ej: Next.js 16, React 19, Tailwind v4] |
| Backend | [Ej: Next.js API Routes / Express / ninguno] |
| Base de datos | [Ej: Supabase PostgreSQL / ninguna] |
| Auth | [Ej: Supabase Auth / ninguna] |
| Deploy | [Ej: Vercel / VPS / local] |
| Otros | [Ej: N8N, Evolution API, Playwright] |

---

## 3. ARQUITECTURA

```
[Diagrama en texto — cómo fluye la información]
[Ej: Usuario → Frontend → API → DB]
[Completar con /init-context o manualmente]
```

**Decisiones no obvias:**
| Decisión | Por qué | Alternativa descartada |
|---|---|---|
| [PENDIENTE] | | |

---

## 4. ESTRUCTURA DE CARPETAS

```
[Completar con /init-context — Claude lo genera automático]
```

**Archivos críticos:**
| Archivo | Para qué |
|---|---|
| [PENDIENTE] | |

---

## 5. BASE DE DATOS

> Dejar vacío si el proyecto no tiene DB.

**Tablas principales:**
| Tabla | PK | Notas críticas |
|---|---|---|
| [PENDIENTE] | | |

**Reglas que NO romper:**
- [ ] [PENDIENTE — llenar con /init-context]

---

## 6. VARIABLES DE ENTORNO

> Solo nombres — nunca valores aquí. Valores en `.env.local` y en `CREDENCIALES.md`.

```env
[VARIABLE]=    # [qué es]
[VARIABLE]=    # [qué es]
```

---

## 7. WORKFLOW GIT

```
main        = producción — nunca commitear directo
work/[nombre] = donde se trabaja siempre
```

**Flujo:**
1. `git checkout -b work/nombre`
2. Trabajar + commits
3. `npm run build` — verificar que compila
4. Merge a main → deploy automático

---

## 8. GLOSARIO (solo si hay términos propios del proyecto)

| Término | Significado |
|---|---|
| [PENDIENTE] | |

---

---

## Contexto mínimo (Claude Desktop)

> Copia esta sección en "Project Instructions" de Claude Desktop.

**Proyecto:** [NOMBRE] — [qué hace en 1 línea]
**Stack:** [tecnologías principales]
**Deploy:** [dónde corre]
**Repo:** github.com/leo1z/[nombre] · Branch trabajo: `work/*`
**Zonas prohibidas:** [PENDIENTE]

**Comportamiento esperado:**
- Challenge: si lo que te pido contradice PROJECT_STATE.md o hay una forma más simple, dímelo antes de ejecutar.
- Stay updated: si ves una práctica obsoleta para este stack, avísame en una línea.

---

*Actualizar con `/update-context` cuando cambie arquitectura o stack. Estado → `docs/PROJECT_STATE.md`. Errores → `docs/PROBLEMS.md`.*
