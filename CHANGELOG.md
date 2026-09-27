# Changelog

## [0.2.0](https://github.com/moveo-ai/agent-skills/compare/v0.1.1...v0.2.0) (2026-09-27)


### Features

* one MCP server per region, directory listing URLs, and no confirmation hook ([#5](https://github.com/moveo-ai/agent-skills/issues/5)) ([6e6c650](https://github.com/moveo-ai/agent-skills/commit/6e6c6504867af1667316b351ec21f0cafc3b9b47))


### Bug Fixes

* **skills:** same behavior in Claude Code and Codex, confirm destructive changes, and tag plugin sessions ([#7](https://github.com/moveo-ai/agent-skills/issues/7)) ([7831c80](https://github.com/moveo-ai/agent-skills/commit/7831c80bb52e2baed6f940702b970d299ec9d34e))

## [0.1.1](https://github.com/moveo-ai/agent-skills/compare/v0.1.0...v0.1.1) (2026-09-26)


### Bug Fixes

* pass the Claude directory validation ([fb5d430](https://github.com/moveo-ai/agent-skills/commit/fb5d430cb7e4cf325f3041226f34fb340a92c8ef))
* pass the Claude directory validation ([e9762c4](https://github.com/moveo-ai/agent-skills/commit/e9762c42724fb264f0373fb2082a1ab3c50ba0b0))

## 0.1.0 (2026-09-26)

### Features

* Moveo.AI MCP server with browser sign-in and a region option for the main, US Central and Brazil regions.
* Skills: `get-started`, `build-agent`, `knowledge-base` and `test-agent`.
* Hook that asks before a publish, rollback or delete.
