#!/bin/bash
# nuevo-proyecto.sh — Setup completo de proyecto nuevo con preguntas o config file
# Uso interactivo:  bash nuevo-proyecto.sh
# Uso con config:   bash nuevo-proyecto.sh --config mi-proyecto.config
# Requiere: git. gh.exe en C:/Program Files/GitHub CLI/

BASE_DIR="C:/Users/Leo Borjas/Projects"
TEMPLATE_DIR="$BASE_DIR/AI_CONTEXT_TEMPLATE"
GH="/c/Program Files/GitHub CLI/gh.exe"
CREDS="C:/Users/Leo Borjas/.claude/CREDENCIALES.md"

echo ""
echo "======================================"
echo "  NUEVO PROYECTO — Setup automático"
echo "======================================"
echo ""

# ── MODO CONFIG vs INTERACTIVO ──────────────────────────────

if [ "$1" = "--config" ]; then
  CONFIG_FILE="$2"
  if [ -z "$CONFIG_FILE" ] || [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: archivo de config no encontrado: $CONFIG_FILE"
    echo "Uso: bash nuevo-proyecto.sh --config mi-proyecto.config"
    exit 1
  fi
  echo "Leyendo config: $CONFIG_FILE"
  # Cargar variables del config (ignorar líneas de comentario y vacías)
  # Usa %% y ## para partir solo en el primer = y soportar valores con = (URLs, etc.)
  while IFS= read -r line; do
    [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
    key="${line%%=*}"
    value="${line#*=}"
    key=$(echo "$key" | xargs)
    export "$key=$value"
  done < "$CONFIG_FILE"
  echo ""

  # Validar campos obligatorios
  if [ -z "$PROJECT_NAME" ]; then echo "Error: PROJECT_NAME falta en el config."; exit 1; fi
  if [ -z "$PROJECT_DESC" ]; then echo "Error: PROJECT_DESC falta en el config."; exit 1; fi
  if [ -z "$PROJECT_TYPE" ]; then PROJECT_TYPE=1; fi

  # Asignar stack según tipo
  case $PROJECT_TYPE in
    1) STACK="Next.js 16, React 19, TypeScript, Tailwind v4, Supabase, Vercel"
       DEPLOY="Vercel"
       HAS_DB="sí" ;;
    2) STACK="Node.js, Express, PM2, VPS Hostinger"
       DEPLOY="VPS"
       HAS_DB="no" ;;
    3) STACK="Node.js / FastAPI"
       DEPLOY="VPS o Railway"
       HAS_DB="opcional" ;;
    *) STACK="${STACK:-[completar stack]}"
       DEPLOY="${DEPLOY:-[completar deploy]}"
       HAS_DB="opcional" ;;
  esac

  USE_SUPABASE="${USE_SUPABASE:-n}"
  USE_VERCEL="${USE_VERCEL:-n}"
  USE_VPS="${USE_VPS:-n}"
  USE_N8N="${USE_N8N:-n}"
  USE_EVOLUTION="${USE_EVOLUTION:-n}"

  echo "Proyecto:   $PROJECT_NAME"
  echo "Descripción: $PROJECT_DESC"
  echo "Tipo:       $PROJECT_TYPE — $STACK"
  echo "Prohibido:  ${FORBIDDEN:-ninguno}"
  echo ""

else
  # ── MODO INTERACTIVO ───────────────────────────────────────

  read -p "Nombre del proyecto (sin espacios, guiones OK): " PROJECT_NAME
  if [ -z "$PROJECT_NAME" ]; then echo "Error: falta el nombre."; exit 1; fi

  read -p "¿Qué hace? (1-2 oraciones): " PROJECT_DESC

  echo ""
  echo "Tipo de proyecto:"
  echo "  1) SaaS web (Next.js + Supabase + Vercel)"
  echo "  2) Script / Automatización (Node.js + VPS)"
  echo "  3) API backend"
  echo "  4) Otro (stack manual)"
  read -p "Elige [1-4]: " PROJECT_TYPE

  case $PROJECT_TYPE in
    1) STACK="Next.js 16, React 19, TypeScript, Tailwind v4, Supabase, Vercel"
       DEPLOY="Vercel"
       HAS_DB="sí" ;;
    2) STACK="Node.js, Express, PM2, VPS Hostinger"
       DEPLOY="VPS"
       HAS_DB="no" ;;
    3) STACK="Node.js / FastAPI"
       DEPLOY="VPS o Railway"
       HAS_DB="opcional" ;;
    *) read -p "Describe el stack: " STACK
       read -p "¿Dónde se despliega?: " DEPLOY
       HAS_DB="opcional" ;;
  esac

  read -p "¿Zonas prohibidas (qué no debe tocar la AI sin permiso)? [Enter para omitir]: " FORBIDDEN

  echo ""
  echo "¿Qué conexiones necesita este proyecto?"
  echo "(Marca las que aplican con s/n)"
  read -p "  ¿Usa Supabase? [s/n]: " USE_SUPABASE
  read -p "  ¿Usa Vercel? [s/n]: " USE_VERCEL
  read -p "  ¿Usa el VPS? [s/n]: " USE_VPS
  read -p "  ¿Usa N8N? [s/n]: " USE_N8N
  read -p "  ¿Usa Evolution API? [s/n]: " USE_EVOLUTION

fi

echo ""
echo "======================================"
echo "  Creando estructura..."
echo "======================================"

PROJECT_DIR="$BASE_DIR/$PROJECT_NAME"
TODAY=$(date +%Y-%m-%d)

# ── CREAR CARPETAS ──────────────────────────────────────────

mkdir -p "$PROJECT_DIR/docs"
cd "$PROJECT_DIR"

# ── GENERAR CLAUDE.md CON LAS RESPUESTAS ───────────────────

cat > "$PROJECT_DIR/CLAUDE.md" << CLAUDEEOF
# $PROJECT_NAME — CLAUDE.md

> Cargado automáticamente por Claude Code al abrir la carpeta.
> Actualizar con \`/update-context\` cuando cambie arquitectura, stack, DB o reglas.

---

## 0. REGLAS PARA LA AI

**Rol:** Eres el Staff Engineer de $PROJECT_NAME. Actúa como si hubieras trabajado aquí desde el inicio.

**Obligatorio en cada cambio:**
- Qué cambia y por qué
- Riesgo: \`Low / Medium / High\`
- Sistemas afectados
- Rollback si riesgo es Medium o High

**Nunca sin instrucción explícita:**
- Commit a \`main\`
- Cambios en: ${FORBIDDEN:-"[completar con /update-context]"}
- Subir credenciales a git

**Comportamiento automático durante el trabajo:**
- Antes de debuggear cualquier error → leer \`docs/PROBLEMS.md\` primero. Si ya está resuelto ahí, aplicar esa solución.
- Si llevamos 3+ intercambios intentando lo mismo sin avanzar → parar, decirlo, proponer enfoque distinto o sugerir nueva conversación.
- Si lo que se pide contradice el PROJECT_STATE o las zonas prohibidas → señalarlo antes de ejecutar.

---

## 1. PROYECTO

\`\`\`
Nombre:      $PROJECT_NAME
Tipo:        [completar con /init-context]
Estado:      En desarrollo
Repo:        https://github.com/leo1z/$PROJECT_NAME
Deploy URL:  [PENDIENTE]
Actualizado: $TODAY
\`\`\`

**Qué hace:** $PROJECT_DESC

---

## 2. STACK

$STACK

> Detalle completo → ejecutar \`/init-context\` para que Claude explore el código y llene esto.

---

## 3. ARQUITECTURA

> Ejecutar \`/init-context\` para generar el diagrama automáticamente.

\`\`\`
[PENDIENTE — /init-context lo genera]
\`\`\`

---

## 4. ESTRUCTURA DE CARPETAS

> Ejecutar \`/init-context\` para generar automáticamente.

---

## 5. BASE DE DATOS

${HAS_DB:+"> Ejecutar \`/init-context\` para documentar el schema."}

---

## 6. VARIABLES DE ENTORNO

> Solo nombres — nunca valores aquí. Valores en \`.env.local\` y en \`CREDENCIALES.md\`.

\`\`\`env
# Completar según el stack del proyecto
\`\`\`

---

## 7. WORKFLOW GIT

\`\`\`
main          = producción — nunca commitear directo
work/[nombre] = donde se trabaja siempre
\`\`\`

**Flujo:** checkout work/ → trabajar → commit → npm run build → merge a main → deploy

---

## 8. CONTEXTO MÍNIMO (Claude Desktop)

> Copia esta sección en "Project Instructions" de Claude Desktop. Actualízala cuando cambies el stack o la arquitectura.

**Proyecto:** $PROJECT_NAME — $PROJECT_DESC
**Stack:** $STACK
**Deploy:** $DEPLOY
**Repo:** github.com/leo1z/$PROJECT_NAME · Branch trabajo: \`work/*\`
**Zonas prohibidas:** ${FORBIDDEN:-"[completar]"}
**Estado actual:** ver docs/PROJECT_STATE.md

**Comportamiento esperado:**
- Challenge: si lo que te pido contradice PROJECT_STATE o hay una forma más simple, dímelo antes de ejecutar.
- Stay updated: si ves una práctica obsoleta para este stack, avísame en una línea.

---

*Completar secciones pendientes con \`/init-context\`. Estado del proyecto → \`docs/PROJECT_STATE.md\`.*
CLAUDEEOF

# ── GENERAR PROJECT_STATE.md ─────────────────────────────────

cat > "$PROJECT_DIR/docs/PROJECT_STATE.md" << STATEEOF
# PROJECT_STATE — $PROJECT_NAME
> Actualizado: $TODAY
> Este archivo lo actualiza /progress al cerrar sesión.

---

## Estado actual
En desarrollo. Configuración inicial completada.

## En progreso ahora
- Branch: \`work/setup\`
- Objetivo: Configurar el proyecto base

## Próximos pasos (en orden de prioridad)
- [ ] **Must:** [completar con el roadmap aprobado]
- [ ] **Must:** [completar con el roadmap aprobado]
- [ ] **Should:** [completar]

## Completado recientemente
- $TODAY — Estructura base creada (CLAUDE.md, docs/, .env.example, .gitignore)
STATEEOF

# ── COPIAR TEMPLATE DE PROBLEMS ──────────────────────────────

cp "$TEMPLATE_DIR/PROBLEMS_TEMPLATE.md" "$PROJECT_DIR/docs/PROBLEMS.md"
sed -i "s/\[NOMBRE DEL PROYECTO\]/$PROJECT_NAME/g" "$PROJECT_DIR/docs/PROBLEMS.md"

# ── GENERAR .env.example ────────────────────────────────────

cat > "$PROJECT_DIR/.env.example" << ENVEOF
# Variables de entorno de $PROJECT_NAME
# Copia este archivo como .env.local y llena los valores reales
# .env.local NUNCA va a git

ENVEOF

# Agregar variables según las conexiones elegidas
[ "$USE_SUPABASE" = "s" ] && cat >> "$PROJECT_DIR/.env.example" << 'EOF'
# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
EOF

[ "$USE_N8N" = "s" ] && cat >> "$PROJECT_DIR/.env.example" << 'EOF'
# N8N
N8N_WEBHOOK_URL=
EOF

[ "$USE_EVOLUTION" = "s" ] && cat >> "$PROJECT_DIR/.env.example" << 'EOF'
# Evolution API
EVOLUTION_API_URL=
EVOLUTION_API_KEY=
EOF

cat >> "$PROJECT_DIR/.env.example" << 'EOF'
# Agrega aquí otras variables del proyecto
EOF

# ── .gitignore ───────────────────────────────────────────────

cat > "$PROJECT_DIR/.gitignore" << 'EOF'
node_modules/
.env
.env.local
.next/
.DS_Store
*.log
EOF

# ── GIT INIT + BRANCHES ──────────────────────────────────────

echo ""
echo "[1/3] Inicializando git..."
git init -q
git checkout -q -b main
git add .
git commit -q -m "chore: init — estructura base de $PROJECT_NAME"
git checkout -q -b work/setup
echo "  ✓ Git listo — branches: main, work/setup (activo)"

# ── GITHUB ───────────────────────────────────────────────────

echo ""
echo "[2/3] Creando repo en GitHub..."
GH_TOKEN_LINE=$(grep -A2 "GitHub Personal Access Token" "$CREDS" 2>/dev/null | grep "ghp_" | head -1)
GH_TOKEN_VAL=$(echo "$GH_TOKEN_LINE" | grep -o 'ghp_[A-Za-z0-9]*')

if [ -f "$GH" ] && [ -n "$GH_TOKEN_VAL" ]; then
  GH_TOKEN="$GH_TOKEN_VAL" "$GH" repo create "leo1z/$PROJECT_NAME" \
    --private --source=. --remote=origin --push -q 2>/dev/null \
    && echo "  ✓ Repo creado: github.com/leo1z/$PROJECT_NAME" \
    || echo "  ⚠ GitHub falló — hazlo manual después (ver GUIAS_TRABAJO.md)"
else
  echo "  ⚠ Token no encontrado — hazlo manual: ver GUIAS_TRABAJO.md → Guía 1 → Paso 2"
fi

# ── RESUMEN DE CONEXIONES ────────────────────────────────────

echo ""
echo "[3/3] Conexiones requeridas por este proyecto:"
[ "$USE_SUPABASE" = "s" ] && echo "  • Supabase: crear proyecto en supabase.com → copiar URL y keys a .env.local"
[ "$USE_VERCEL"   = "s" ] && echo "  • Vercel: ir a vercel.com → New Project → importar github.com/leo1z/$PROJECT_NAME"
[ "$USE_VPS"      = "s" ] && echo "  • VPS: acceso listo — ssh root@72.60.126.84 (creds en CREDENCIALES.md)"
[ "$USE_N8N"      = "s" ] && echo "  • N8N: crear workflow en n8n.getdupla.com → copiar webhook a .env.local"
[ "$USE_EVOLUTION" = "s" ] && echo "  • Evolution API: corriendo en el VPS — API key en CREDENCIALES.md"

# ── RESULTADO FINAL ──────────────────────────────────────────

echo ""
echo "======================================"
echo "  ✓ Proyecto '$PROJECT_NAME' listo"
echo "======================================"
echo ""
echo "Carpeta:  $PROJECT_DIR"
echo "GitHub:   github.com/leo1z/$PROJECT_NAME"
echo "Branch:   work/setup (activo)"
echo ""
echo "Próximos pasos:"
echo "  1. Abre VS Code:  code \"$PROJECT_DIR\""
echo "  2. En Claude:     /init-context   (genera el CLAUDE.md completo)"
echo "  3. Crea:          .env.local con los valores de CREDENCIALES.md"
echo "  4. Inicia sesión: /goal \"configurar el proyecto\""
echo ""
echo "  Para Claude Desktop:"
echo "  → Nuevo Project → copia la sección '## Contexto mínimo (Claude Desktop)' del CLAUDE.md en Project Instructions"
echo "  → Sube docs/PROJECT_STATE.md y docs/PROBLEMS.md como Knowledge"
echo ""
echo "  Docs creados en docs/:"
echo "  → PROJECT_STATE.md  PROBLEMS.md"
echo ""
