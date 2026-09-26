#!/bin/sh
case "${CLAUDE_PLUGIN_OPTION_CONFIRM_DESTRUCTIVE:-true}" in
  false | FALSE | 0 | no) exit 0 ;;
esac

tool=$(cat 2>/dev/null | sed -n 's/.*"tool_name"[[:space:]]*:[[:space:]]*"mcp__.*__\(moveo_[a-z_]*\)".*/\1/p' | head -n 1)
[ -n "$tool" ] || tool="a Moveo.AI change"

printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"%s changes live Moveo.AI resources and cannot always be undone. Turn this check off with the confirm_destructive option of the moveo plugin."}}\n' "$tool"
