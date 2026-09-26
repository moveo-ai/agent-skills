#!/bin/sh
# Public surfaces use the product nouns: environment, agent, knowledge base, Moveo.AI.
set -eu

cd "$(dirname "$0")/.."

pattern='\b(desks?|brains?|collections?)\b|Môveo'
files="skills README.md .claude-plugin .codex-plugin .agents"

if grep -rniE "$pattern" $files; then
  echo "Found internal vocabulary. Use environment, agent, knowledge base and Moveo.AI." >&2
  exit 1
fi

echo "Vocabulary check passed."
