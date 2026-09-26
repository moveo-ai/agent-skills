#!/bin/sh
set -eu

cd "$(dirname "$0")/.."

node -e '
const fs = require("fs");
const read = (p) => JSON.parse(fs.readFileSync(p, "utf8"));
const claude = read(".claude-plugin/plugin.json");
const codex = read(".codex-plugin/plugin.json");
const release = read(".release-please-manifest.json")["."];
const names = [
  claude.name,
  codex.name,
  read(".claude-plugin/marketplace.json").plugins[0].name,
  read(".agents/plugins/marketplace.json").plugins[0].name,
];
if (claude.version !== codex.version || claude.version !== release) {
  console.error(`Version mismatch: .claude-plugin=${claude.version} .codex-plugin=${codex.version} release-please=${release}`);
  process.exit(1);
}
if (names.some((n) => n !== "moveo")) {
  console.error(`Plugin names differ: ${names.join(", ")}`);
  process.exit(1);
}
console.log(`Versions and names match: ${claude.version}.`);
'
