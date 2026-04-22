# Guía de Colaborador — [Nombre del Proyecto]

> Tiempo estimado para estar listo: ~15 minutos

---

## Lo que necesitas antes de empezar

- [ ] Acceso al repo en GitHub (pedirlo al Lead)
- [ ] Variables de entorno del proyecto (`.env.local`) — pedirlas por canal seguro, nunca GitHub
- [ ] [Claude Code](https://claude.ai/code) instalado
- [ ] Git instalado

---

## ¿Primera vez usando Dupla-Workflow en esta máquina?

Instala el sistema una vez:

```bash
git clone https://github.com/leo1z/dupla-workflow
cd dupla-workflow
bash bin/install.sh
```

Luego configura tu perfil en Claude Code:

```
/setup-dupla
```

Claude te hace una entrevista rápida (nombre, stack, proyectos). Una sola vez por máquina.

Si ya tienes el sistema instalado → salta directo al Paso 1.

---

## Paso 1 — Clonar el proyecto

```bash
git clone https://github.com/[org]/[nombre-proyecto]
cd [nombre-proyecto]
```

---

## Paso 2 — Abrir en Claude Code (VS Code)

Abre la carpeta completa del proyecto. Claude carga el contexto automáticamente al leer `CLAUDE.md`.

---

## Paso 3 — Instalar dependencias (si aplica)

```bash
npm install        # JavaScript / Node
pip install -r requirements.txt   # Python
```

---

## Paso 4 — Variables de entorno

1. Revisa `.env.example` si existe
2. Crea `.env.local`
3. Pide los valores al Lead (WhatsApp, Slack, Signal — nunca GitHub)

---

## Paso 5 — Primera sesión de trabajo

```
/new-session
```

Claude lee el estado del proyecto y te dice exactamente en qué fase están, qué está pendiente y cuál es tu próximo paso.

---

## Flujo de trabajo diario

```
git pull                  ← antes de empezar
/new-session              ← leer estado + plan del día
[trabajar]
git add . && git commit   ← guardar trabajo en git
/checkpoint               ← cerrar sesión + actualizar estado
git push
```

---

## Comandos del sistema

| Comando | Cuándo |
|---|---|
| `/new-session` | Al iniciar cada sesión de trabajo |
| `/checkpoint` | Al terminar (guarda estado, actualiza roadmap) |
| `/checkpoint handoff` | Para pasar trabajo a otro modelo o dev |
| `/health-check` | Si algo no funciona o cada 2-3 semanas |
| `/restore` | Para ver puntos de guardado anteriores |
| `/quick-start` | Para sesiones pequeñas sin proyecto completo |

---

## Reglas del proyecto

- Nunca trabajar directo en `main`
- Nunca subir credenciales al repo
- Siempre con `git commit` antes de cerrar (el sistema necesita commits para reconstruir estado)
- Si algo va mal → pega el error completo en Claude con contexto

---

## Si eres nuevo en el equipo (proyecto tipo Team)

El Lead ya creó tu branch. Verifica cuál es:

```
git fetch --all
git branch -r
git checkout work/[tu-branch]
```

Luego:
```
/new-session
```

Claude detectará tu sección en `PROJECT_STATE.md` y te mostrará tu estado, dependencias y próximo paso.

---

## Fuente de verdad

Claude trabaja siempre desde:
1. Código del proyecto (git)
2. `docs/PROJECT_STATE.md` (estado actual)

No necesitas explicar contexto manualmente — el sistema ya lo tiene.
