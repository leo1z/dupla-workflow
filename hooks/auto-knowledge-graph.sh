#!/bin/bash
# Hook: Stop — auto-update of knowledge graph
# Generates the knowledge graph json in docs/

if [ -f "bin/generate-code-review-graph.sh" ]; then
  bash bin/generate-code-review-graph.sh . > /dev/null 2>&1
fi

exit 0
