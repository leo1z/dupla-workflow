# Guía de Colaborador — [Nombre del Proyecto]

> Tiempo estimado para estar listo: ~20 minutos

---

## Lo que necesitas antes de empezar

- [ ] Acceso al repo en GitHub (pedirlo al dueño)
- [ ] Credenciales del proyecto (`.env.local`) — pedirlas por un canal seguro, nunca por GitHub
- [ ] [Claude Code](https://claude.ai/code) instalado (necesitas cuenta de Claude)
- [ ] [git](https://git-scm.com/download/win) instalado
- [ ] Node.js instalado (si el proyecto usa Next.js / Node)

---

## Paso 1 — Clonar el proyecto

Abre la terminal y ejecuta (reemplaza el nombre del repo):

```bash
git clone https://github.com/leo1z/nombre-proyecto "C:/Users/TU_USUARIO/Projects/nombre-proyecto"
```

---

## Paso 2 — Abrir en VS Code

```bash
code "C:/Users/TU_USUARIO/Projects/nombre-proyecto"
```

> **IMPORTANTE:** Abre la CARPETA, no un archivo suelto. Claude Code carga el contexto del proyecto automáticamente al abrir la carpeta.

---

## Paso 3 — Instalar dependencias

Si el proyecto usa Next.js o Node:

```bash
npm install
```

---

## Paso 4 — Variables de entorno

1. En la carpeta del proyecto hay un archivo `.env.example` con los nombres de las variables
2. Crea un archivo `.env.local` en la misma carpeta
3. Pide los valores al dueño del proyecto (por WhatsApp, Slack, o donde corresponda — nunca por GitHub)
4. Copia los valores al `.env.local`

---

## Paso 5 — Verificar que funciona

```bash
npm run dev
```

Abre `http://localhost:3000` en el navegador. Si algo falla, copia el error y díselo al dueño.

---

## Paso 6 — Contexto del proyecto (Claude ya lo tiene)

Cuando abriste la carpeta en VS Code, Claude cargó automáticamente el `CLAUDE.md` del proyecto. Ya sabe:
- Qué hace el proyecto
- Cómo está estructurado
- Las reglas de trabajo

No necesitas explicarle nada. Puedes preguntar directamente:
```
¿Qué hace este proyecto y cómo está organizado?
```

Para ver el estado actual y próximos pasos:
```
/goal "ver estado del proyecto"
```

---

## Reglas de trabajo en equipo

### Branches — obligatorio
Nunca trabajes directo en `main`. Crea un branch para cada tarea:

```bash
git checkout -b work/lo-que-vas-a-hacer
```

Ejemplos:
```bash
git checkout -b work/fix-login-bug
git checkout -b work/agregar-filtro-fecha
```

### Commits — formato estándar

```
feat(módulo): descripción corta
fix(módulo): descripción corta
chore: configuración o setup
docs: solo documentación
wip: trabajo sin terminar (para guardar y retomar)
```

### Mergear a main
Solo mergea a `main` cuando:
1. El código compila sin errores (`npm run build`)
2. El dueño del proyecto lo revisó

---

## Flujo de trabajo diario

**Al iniciar:**
```bash
git pull
```
Luego en Claude:
```
/goal "qué quiero hacer hoy"
```

**Al terminar:**
```bash
git add .
git commit -m "tipo(módulo): descripción"
git push
```

---

## Si algo falla

1. Copia el error completo
2. En Claude escribe:
```
Error: [pega el error]
Estaba haciendo: [qué hacías]
Archivo: [nombre del archivo]
```

Si no se resuelve → avisa al dueño del proyecto con el error y lo que ya intentaste.

---

## Opcional pero recomendado — Instalar el sistema de trabajo

El proyecto usa un sistema de skills para gestionar sesiones, roadmap y contexto. Puedes instalarlo en menos de 5 minutos:

### Instalar

```bash
git clone https://github.com/leo1z/dupla-workflow
cd dupla-workflow
bash instalar.sh
```

Eso copia todos los skills a tu `~/.claude/commands/`.

### Configurar tu contexto global

```bash
cp templates/CLAUDE.global.md ~/.claude/CLAUDE.md
```

Abre `~/.claude/CLAUDE.md` y llena tu nombre, proyectos y stack.

### Verificar que funciona

Abre VS Code con este proyecto y escribe en Claude:
```
/goal "test"
```

Si Claude responde con el estado del proyecto → todo funciona.

### Skills disponibles

| Comando | Qué hace | Cuándo |
|---|---|---|
| `/goal "objetivo"` | Inicia sesión — lee PROJECT_STATE.md, da plan | Al empezar — obligatorio |
| `/progress` | Cierra sesión — actualiza PROJECT_STATE.md | Al terminar — obligatorio |
| `/init-context` | Genera CLAUDE.md + PROJECT_STATE.md | Solo en proyectos nuevos |
| `/update-context` | Actualiza CLAUDE.md cuando cambia el stack | Cuando cambia arquitectura |

Para más info y actualizaciones: [github.com/leo1z/dupla-workflow](https://github.com/leo1z/dupla-workflow)
