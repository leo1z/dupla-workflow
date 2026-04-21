#!/bin/bash
# Generate code-review-graph.json for project structure analysis
# Usage: bash bin/generate-code-review-graph.sh [project-root]

PROJECT_ROOT="${1:-.}"
OUTPUT_FILE="${PROJECT_ROOT}/docs/code-review-graph.json"

if [ ! -d "$PROJECT_ROOT" ]; then
  echo "❌ Project root not found: $PROJECT_ROOT"
  exit 1
fi

# Get last commit hash + timestamp
LAST_COMMIT=$(git -C "$PROJECT_ROOT" rev-parse --short HEAD 2>/dev/null || echo "unknown")
GEN_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
PROJECT_NAME=$(basename "$PROJECT_ROOT")

# Count files by type
MD_FILES=$(find "$PROJECT_ROOT" -name "*.md" -type f | grep -v node_modules | wc -l)
TS_FILES=$(find "$PROJECT_ROOT" -name "*.ts" -o -name "*.tsx" | grep -v node_modules | wc -l)
JSON_FILES=$(find "$PROJECT_ROOT" -name "*.json" -type f | grep -v node_modules | wc -l)
SH_FILES=$(find "$PROJECT_ROOT" -name "*.sh" -type f | wc -l)

# Build JSON
cat > "$OUTPUT_FILE" << EOF
{
  "project": "$PROJECT_NAME",
  "generated": "$GEN_TIME",
  "lastCommit": "$LAST_COMMIT",
  "structure": {
    "root": "$PROJECT_ROOT",
    "folders": [
      {
        "path": "skills/",
        "files": $(find "$PROJECT_ROOT/skills" -maxdepth 1 -type f 2>/dev/null | wc -l),
        "purpose": "v2 workflow commands",
        "stability": "stable",
        "riskLevel": "low"
      },
      {
        "path": "templates/",
        "files": $(find "$PROJECT_ROOT/templates" -maxdepth 1 -type f 2>/dev/null | wc -l),
        "purpose": "project documentation templates",
        "stability": "stable",
        "riskLevel": "low"
      },
      {
        "path": "hooks/",
        "files": $(find "$PROJECT_ROOT/hooks" -maxdepth 1 -type f 2>/dev/null | wc -l),
        "purpose": "automation hooks (guard, checkpoint, session)",
        "stability": "new",
        "riskLevel": "medium"
      },
      {
        "path": "bin/",
        "files": $(find "$PROJECT_ROOT/bin" -maxdepth 1 -type f 2>/dev/null | wc -l),
        "purpose": "installation + utilities",
        "stability": "stable",
        "riskLevel": "medium"
      },
      {
        "path": "docs/",
        "files": $(find "$PROJECT_ROOT/docs" -maxdepth 1 -type f 2>/dev/null | wc -l),
        "purpose": "system documentation",
        "stability": "stable",
        "riskLevel": "low"
      }
    ],
    "fileCounts": {
      "markdown": $MD_FILES,
      "typescript": $TS_FILES,
      "json": $JSON_FILES,
      "shell": $SH_FILES
    }
  },
  "riskZones": [
    {
      "path": "bin/install.sh",
      "reason": "multi-IDE deployment (Claude Code + Antigravity)",
      "changeFrequency": "low",
      "riskLevel": "high",
      "impact": "breaks setup for all users"
    },
    {
      "path": "skills/setup-dupla.md",
      "reason": "first-time onboarding - sets up global config",
      "changeFrequency": "medium",
      "riskLevel": "high",
      "impact": "broken onboarding experience"
    },
    {
      "path": "skills/new-project.md",
      "reason": "project initialization with 7-question assessment",
      "changeFrequency": "medium",
      "riskLevel": "high",
      "impact": "broken project setup"
    },
    {
      "path": "skills/new-session.md",
      "reason": "SESSION block parsing - context reconstruction",
      "changeFrequency": "medium",
      "riskLevel": "medium",
      "impact": "context loss across sessions"
    },
    {
      "path": "hooks/guard-project-state.sh",
      "reason": "prevents accidental writes without PROJECT_STATE.md",
      "changeFrequency": "low",
      "riskLevel": "medium",
      "impact": "blocks legitimate workflow or allows unguarded changes"
    }
  ],
  "dependencies": {
    "install.sh": ["skills/", "hooks/", "templates/", "bin/", "CHANGELOG.md", "VERSION"],
    "setup-dupla.md": ["global-templates/CLAUDE_GLOBAL_TEMPLATE.md", "global-templates/SYSTEM_TEMPLATE.md", "bin/install.sh"],
    "new-project.md": ["templates/PROJECT_STATE_TEMPLATE.md", "templates/ROADMAP_TEMPLATE.md", "templates/ARCHITECTURE_TEMPLATE.md", "templates/PLAN_TEMPLATE.md", "templates/PROBLEMS_TEMPLATE.md"],
    "new-session.md": ["templates/PROJECT_STATE_TEMPLATE.md"],
    "checkpoint.md": ["skills/new-session.md"],
    "guard-project-state.sh": ["templates/PROJECT_STATE_TEMPLATE.md"],
    "README.md": ["QUICKSTART.html", "VERSION", "CHANGELOG.md"]
  },
  "metadata": {
    "system": "dupla-workflow v2",
    "purpose": "pre-compiled structure analysis for audits and refactoring impact",
    "regenerate": "after significant structural changes (new skills, hook changes, template updates)",
    "usage": "reference only - query via /project-audit or review manually for impact analysis"
  }
}
EOF

echo "✅ Generated: $OUTPUT_FILE"
echo "📊 Structure: $MD_FILES markdown, $TS_FILES typescript, $JSON_FILES json, $SH_FILES shell"
