# Moveo.AI plugin for Claude Code and Codex

Build, test and operate [Moveo.AI](https://moveo.ai) conversational AI agents from Claude Code or OpenAI Codex. The plugin connects your coding agent to the hosted Moveo.AI MCP server and adds workflows for the tasks that take the most steps: building an agent, grounding it in a knowledge base, and testing it before it goes live.

Ask things like:

```text
Build a support agent for our online store from this brief: returns within 30 days, hand over to a human for damaged items.
```

```text
Make the "Store support" agent answer from https://help.example.com and publish it when the answers look right.
```

```text
Session 5b0e7c1a-9d2f-4c3e-8a61-2f4d7e9b1c30 went wrong yesterday. Find out why and fix it.
```

## Install in Claude Code

You need Claude Code v2.1.275 or later and a Moveo.AI login.

1. In Claude Code, run:

   ```text
   /plugin install moveo --marketplace moveo-ai/agent-skills
   ```

   On an older Claude Code, run the two steps separately:

   ```text
   /plugin marketplace add moveo-ai/agent-skills
   /plugin install moveo@moveo
   ```

2. Claude Code asks for your region. Keep `mcp.moveo.ai`, unless your account is on US Central (`mcp.us-central.moveo.ai`) or in Brazil (`mcp.sa-east.moveo.ai`).
3. Run `/reload-plugins`.
4. Run `/mcp`, select `plugin:moveo:moveo`, and sign in with your Moveo.AI login in the browser.
5. Ask Claude "what can I do with Moveo?" to confirm the connection.

There is no API key to create or paste. Claude Code stores the sign-in token in your system keychain and refreshes it.

## Install in Codex

You need a Moveo.AI login.

1. In your shell, run:

   ```bash
   codex plugin marketplace add moveo-ai/agent-skills
   codex plugin add moveo@moveo
   ```

2. Sign in with your Moveo.AI login in the browser:

   ```bash
   codex mcp login moveo
   ```

3. Start Codex and ask "what can I do with Moveo?" to confirm the connection.

The Codex plugin connects to the main region, `mcp.moveo.ai`. If your account is on US Central or in Brazil, add the server of your region and sign in to it:

```bash
codex mcp add moveo-us --url https://mcp.us-central.moveo.ai/mcp
codex mcp login moveo-us
```

For Brazil, use `https://mcp.sa-east.moveo.ai/mcp`. The confirmation hook and the region option are available only in Claude Code.

## What is inside

| Part | What it does |
|---|---|
| Moveo MCP server | About 100 tools over agents, guidelines, workflows, knowledge bases, simulations, environments, channels and routing rules, plus 10 guided prompts |
| `get-started` skill | Confirms the sign-in, the region and the account, then routes you to the right workflow |
| `build-agent` skill | Creates and changes agents: guidelines, workflows, training, publish and rollback |
| `knowledge-base` skill | Builds knowledge bases from websites, FAQs and files, and fixes wrong answers |
| `test-agent` skill | Runs quick tests and simulations, and debugs customer conversations |
| Confirmation hook | Asks you to approve each publish, rollback or delete, also for Moveo tools that you allowed |

Every change goes to a draft first. Customers see nothing until you publish.

## Settings

Change these in `/plugin` under the moveo plugin, then run `/reload-plugins`.

| Setting | Default | Meaning |
|---|---|---|
| `region_host` | `mcp.moveo.ai` | The Moveo.AI region of your account |
| `confirm_destructive` | `true` | Ask before a publish, rollback or delete |

## Update

Claude Code does not update plugins from this marketplace on its own. To get a new version, run:

```text
/plugin marketplace update moveo
```

To update on every session start instead, open `/plugin`, go to Marketplaces, select `moveo`, and select Enable auto-update. The [changelog](CHANGELOG.md) lists every release.

## Troubleshooting

| Symptom | Fix |
|---|---|
| Moveo tools are missing | Run `/reload-plugins`, then `/mcp` and sign in |
| `/mcp` shows your own `moveo` server but not `plugin:moveo:moveo` | You added the same Moveo server by hand before. Claude Code keeps your server and hides the plugin copy. The plugin works with either. To use the plugin copy, run `claude mcp remove moveo` |
| Sign-in works but no account or the wrong account appears | Your account is in another region. Change `region_host` and sign in again |
| "needs authentication" after some days | Run `/mcp`, select `plugin:moveo:moveo`, and select Re-authenticate |
| A channel type or an external knowledge source cannot be created | Some features are available only in the Moveo.AI dashboard. Claude tells you which ones |

<details>
<summary>Connect without the plugin</summary>

```bash
claude mcp add --transport http moveo https://mcp.moveo.ai/mcp
```

Then run `/mcp` and sign in. Use the host of your region in place of `mcp.moveo.ai`.

</details>

## Develop

1. Load your checkout for one session: `claude --plugin-dir .`
2. Validate the manifests: `claude plugin validate . --strict`
3. Run the local checks: `./scripts/check-vocabulary.sh` and `./scripts/test-hook.sh`
4. Run the eval suite against mock Moveo tools: `claude plugin eval .`

The eval suite calls the model with your credentials, so it costs money. A full run costs about 3 USD. Each case runs with the plugin and without it, and the report shows what the plugin adds.

Commit messages follow Conventional Commits. release-please opens the release pull request, sets `version` in `plugin.json`, and writes the changelog.

## Security

The plugin contains no credentials. It connects only to the Moveo.AI host of the region you choose, and it acts with the permissions of the Moveo.AI user who signs in. The skills tell Claude to treat transcripts, documents and knowledge base content as untrusted data.

To report a security problem, open a private security advisory on this repository.

## License

[MIT](LICENSE)
