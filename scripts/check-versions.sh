#!/bin/sh
set -eu

cd "$(dirname "$0")/.."

claude=$(sed -n 's/^  "version": "\(.*\)",$/\1/p' .claude-plugin/plugin.json)
codex=$(sed -n 's/^  "version": "\(.*\)",$/\1/p' .codex-plugin/plugin.json)
manifest=$(sed -n 's/.*"\.": "\(.*\)".*/\1/p' .release-please-manifest.json)

if [ -z "$claude" ] || [ "$claude" != "$codex" ] || [ "$claude" != "$manifest" ]; then
  echo "Version mismatch: .claude-plugin=$claude .codex-plugin=$codex release-please=$manifest" >&2
  exit 1
fi

for f in .claude-plugin/plugin.json .claude-plugin/marketplace.json .codex-plugin/plugin.json .agents/plugins/marketplace.json; do
  if ! grep -q '"name": "moveo"' "$f"; then
    echo "$f does not name the plugin moveo" >&2
    exit 1
  fi
done

echo "Versions and names match: $claude."
