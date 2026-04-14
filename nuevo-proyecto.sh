#!/bin/bash
# nuevo-proyecto.sh — Setup completo de proyecto nuevo con preguntas o config file
# Uso interactivo:  bash nuevo-proyecto.sh
# Uso con config:   bash nuevo-proyecto.sh --config mi-proyecto.config
# Requiere: git. gh.exe en C:/Program Files/GitHub CLI/

BASE_DIR="C:/Users/Leo Borjas/Projects"
TEMPLATE_DIR="$BASE_DIR/dupla-workflow/templates"
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

  echo "Antes de continuar — verifica que completaste los pasos previos:"
  echo ""
  read -p "  ¿Tienes IDEA_DRAFT.md listo? (RESEARCH_PROMPT.md) [s/n]: " HAS_IDEA
  read -p "  ¿Tienes ROADMAP.md + ARCHITECTURE.md generados? (PLAN_PROMPT.md) [s/n]: " HAS_PLAN
  echo ""

  if [ "$HAS_IDEA" != "s" ] || [ "$HAS_PLAN" != "s" ]; then
    echo "⚠️  Pasos previos incompletos. Sigue el flujo primero:"
    echo ""
    echo "  Guía: $BASE_DIR/dupla-workflow/docs/New_Project_Guide.md"
    echo ""
    [ "$HAS_IDEA" != "s" ] && echo "  • Falta: IDEA_DRAFT.md — usa templates/RESEARCH_PROMPT.md"
    [ "$HAS_PLAN" != "s" ] && echo "  • Falta: ROADMAP.md + ARCHITECTURE.md — usa templates/PLAN_PROMPT.md"
    echo ""
    exit 0
  fi

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

# ── GENERAR CLAUDE.md (basado en CLAUDE_TEMPLATE) ──────────

cat > "$PROJECT_DIR/CLAUDE.md" << CLAUDEEOF
# Context — $PROJECT_NAME

> Type: Semi-static (update with /update-context when stack or architecture changes)
> Used: /new-session
> Last updated: $TODAY

---

## Project

$PROJECT_DESC
Repo: https://github.com/leo1z/$PROJECT_NAME

---

## Current Phase

Planning

---

## Stack

$(echo "$STACK" | tr ',' '\n' | sed 's/^ */- /')

---

## Constraints

- Do NOT modify: ${FORBIDDEN:-"[define after /new-project]"}
- No credentials in repo — use .env.local only
- Work in work/* branches only — never commit to main

---

## Workflow Rules

- PROJECT_STATE.md + code = source of truth
- Always read PROJECT_STATE.md first
- Follow roadmap phases (adapt to reality)
- Prototype first, then production
- Do NOT over-engineer

---

## Execution Rules

- Before debugging → check docs/PROBLEMS.md
- If fix exists → reuse it
- If new issue → document it
- If stuck after 3+ attempts → stop and rethink
- If request conflicts with PROJECT_STATE → flag it before executing

---

## Command Map

- /new-session → read PROJECT_STATE.md + start work
- /progress → update state + sync repo
- /update-context → align docs with current code
- /new-project → initialize from IDEA_DRAFT + ROADMAP

---

## Docs Map

- State → docs/PROJECT_STATE.md (always)
- Roadmap → docs/ROADMAP.md (direction)
- Architecture → docs/ARCHITECTURE.md (build)
- Problems → docs/PROBLEMS.md (debug only)
CLAUDEEOF

# ── GENERAR PROJECT_STATE.md (basado en PROJECT_STATE_TEMPLATE) ──

cat > "$PROJECT_DIR/docs/PROJECT_STATE.md" << STATEEOF
# Project State — $PROJECT_NAME

> Type: Dynamic (source of truth)
> Used: /new-session, /progress, /update-context
> Last updated: $TODAY

---

## Current Goal
Copy planning docs to docs/ and run /new-project to initialize

---

## Status
Project structure created. Awaiting planning docs + /new-project.

---

## In Progress
- Branch: \`work/setup\`
- Pending: Copy IDEA_DRAFT.md, ROADMAP.md, ARCHITECTURE.md to docs/

---

## Next Steps

- [ ] **Must:** Copy IDEA_DRAFT.md to docs/
- [ ] **Must:** Copy ROADMAP.md + ARCHITECTURE.md to docs/
- [ ] **Must:** Run /new-project to initialize from docs
- [ ] **Should:** Create .env.local with values from CREDENCIALES.md

---

## Blockers
- None

---

## Recent Changes (last 3–5)
- $TODAY — Project structure created via nuevo-proyecto.sh

---

## Sync Status

- Branch: work/setup
- Compared to main: ahead
- Ready to merge: NO

---

## Rules

- This + codebase = source of truth
- Updated on /progress
- Do NOT infer state from chat

---

## Priority Rule

1. PROJECT_STATE.md
2. Codebase
3. ROADMAP.md
4. ARCHITECTURE.md
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
    || echo "  ⚠ GitHub falló — hazlo manual después (ver New_Project_Guide.md)"
else
  echo "  ⚠ Token no encontrado — hazlo manual: ver docs/New_Project_Guide.md"
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
echo "  2. Copia tus docs de planning a docs/:"
echo "     cp [ruta]/IDEA_DRAFT.md    \"$PROJECT_DIR/docs/\""
echo "     cp [ruta]/ROADMAP.md       \"$PROJECT_DIR/docs/\""
echo "     cp [ruta]/ARCHITECTURE.md  \"$PROJECT_DIR/docs/\""
echo "  3. En Claude:     /new-project   (inicializa PROJECT_STATE.md)"
echo "  4. Crea:          .env.local con los valores de CREDENCIALES.md"
echo "  5. Inicia sesión: /new-session"
echo ""
echo "  Docs creados en docs/:"
echo "  → PROJECT_STATE.md  PROBLEMS.md  (+ los que copies: IDEA_DRAFT, ROADMAP, ARCHITECTURE)"
echo ""
