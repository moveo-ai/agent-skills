#!/bin/sh
set -eu

cd "$(dirname "$0")/.."

out=$(echo '{"tool_name":"mcp__plugin_moveo_moveo__moveo_publish_agent","tool_input":{}}' | sh scripts/confirm-destructive.sh)
echo "$out" | grep -q '"permissionDecision":"ask"'
echo "$out" | grep -q 'moveo_publish_agent'

out=$(echo '{"tool_name":"mcp__plugin_moveo_moveo__moveo_publish_agent"}' | CLAUDE_PLUGIN_OPTION_CONFIRM_DESTRUCTIVE=false sh scripts/confirm-destructive.sh)
test -z "$out"

out=$(printf 'not json' | sh scripts/confirm-destructive.sh)
echo "$out" | grep -q '"permissionDecision":"ask"'

out=$(echo '{"tool_name":"mcp__moveo-sa-east__moveo_delete_rule"}' | sh scripts/confirm-destructive.sh)
echo "$out" | grep -q 'moveo_delete_rule changes'

echo "Hook tests passed."
