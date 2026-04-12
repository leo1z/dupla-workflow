# Sistema de Trabajo V2 — Skills para Claude Code

Skills para trabajar con Claude Code de forma estructurada: inicio/cierre de sesión, contexto de proyecto cacheado, estado dinámico y detección de ciclos.

## Instalación

```bash
git clone https://github.com/leo1z/sistema-trabajo
cd sistema-trabajo
bash instalar.sh
```

Copia los 4 skills a `~/.claude/commands/`. Funciona en Windows, Mac y Linux.

---

## Los 4 skills

| Comando | Qué hace | Cuándo |
|---|---|---|
| `/goal "objetivo"` | Lee PROJECT_STATE.md, da plan en 10 líneas | Al INICIAR sesión — obligatorio |
| `/progress` | Actualiza PROJECT_STATE.md con lo completado | Al CERRAR sesión — obligatorio |
| `/init-context` | Genera CLAUDE.md + PROJECT_STATE.md para proyecto nuevo | Una vez por proyecto |
| `/update-context` | Actualiza solo la sección afectada de CLAUDE.md | Cuando cambia arquitectura o stack |

---

## Configuración inicial

### 1. CLAUDE.md global

```bash
cp templates/CLAUDE.global.md ~/.claude/CLAUDE.md
```

Edita el archivo y completa: quién eres, tus proyectos, tu stack base.

### 2. Credenciales

```bash
cp templates/CREDENCIALES.template.md ~/.claude/CREDENCIALES.md
```

Llena los valores. **Nunca subas este archivo a git.**

### 3. Verifica

Abre VS Code con cualquier proyecto y escribe:
```
/goal "test"
```

Si Claude responde con el estado del proyecto → todo funciona.

---

## Estructura de documentos por proyecto

Cada proyecto necesita estos archivos:

```
mi-proyecto/
├── CLAUDE.md                  ← contexto completo (stack, arquitectura, reglas)
├── docs/
│   ├── PROJECT_STATE.md       ← estado dinámico: dónde estamos, qué sigue
│   └── PROBLEMS.md            ← errores ya resueltos (no repetir)
├── .env.local                 ← variables con valores — NUNCA a git
└── .env.example               ← variables sin valores — sí a git
```

Para generar esta estructura en un proyecto existente:
```
/init-context
```

---

## Flujo de trabajo

```
Inicio:   git pull → /goal "objetivo del día"
Trabajo:  commits frecuentes
Cierre:   git push → /progress
```

---

## Actualizaciones

```bash
cd sistema-trabajo
git pull
bash instalar.sh
```
