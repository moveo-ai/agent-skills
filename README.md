# Moveo.AI plugin for Claude Code and Codex

Build, test and operate [Moveo.AI](https://moveo.ai) conversational AI agents from Claude Code or OpenAI Codex. The plugin connects your coding agent to the hosted Moveo.AI MCP servers and adds workflows for the tasks that take the most steps: building an agent, grounding it in a knowledge base, and testing it before it goes live.

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

2. Run `/reload-plugins`.
3. Run `/mcp`, select the server of your region, and sign in with your Moveo.AI login in the browser. Sign in to one server only:

   | Server | Region |
   |---|---|
   | `plugin:moveo:moveo` | Europe, `mcp.moveo.ai` |
   | `plugin:moveo:moveo-us` | US Central, `mcp.us-central.moveo.ai` |
   | `plugin:moveo:moveo-br` | Brazil, `mcp.sa-east.moveo.ai` |

4. Ask Claude "what can I do with Moveo?" to confirm the connection.

The two other servers stay at "needs authentication". That is normal, and it does not affect the server you use. There is no API key to create or paste. Claude Code stores the sign-in token securely and refreshes it.

## Install in Codex

You need a Moveo.AI login.

1. In your shell, run:

   ```bash
   codex plugin marketplace add moveo-ai/agent-skills
   codex plugin add moveo@moveo
   ```

2. Sign in to the server of your region with your Moveo.AI login in the browser. Use `moveo` for Europe, `moveo-us` for US Central, or `moveo-br` for Brazil:

   ```bash
   codex mcp login moveo
   ```

3. Start Codex and ask "what can I do with Moveo?" to confirm the connection.

## What is inside

| Part | What it does |
|---|---|
| Moveo MCP servers | One server for each region, each with about 100 tools over agents, guidelines, workflows, knowledge bases, simulations, environments, channels and routing rules, plus 10 guided prompts |
| `get-started` skill | Confirms the sign-in, the region and the account, then routes you to the right workflow |
| `build-agent` skill | Creates and changes agents: guidelines, workflows, training, publish and rollback |
| `knowledge-base` skill | Builds knowledge bases from websites, FAQs and files, and fixes wrong answers |
| `test-agent` skill | Runs quick tests and simulations, and debugs customer conversations |

Every change goes to a draft first. Customers see nothing until you publish. The skills tell Claude to name the account and the resource and to wait for your yes before any publish, rollback or delete. The servers also mark every tool that changes data as destructive. On claude.ai, that mark makes Claude ask before each such call. In Claude Code, your permission settings decide: if you allow the Moveo write tools without a prompt, only the skills stand between a request and the change.

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
| Sign-in works but no account or the wrong account appears | Your account is in another region. Sign in to the server of that region |
| "needs authentication" after some days on the server you use | Run `/mcp`, select that server, and select Re-authenticate |
| A channel type or an external knowledge source cannot be created | Some features are available only in the Moveo.AI dashboard. Claude tells you which ones |

<details>
<summary>Connect without the plugin</summary>

```bash
claude mcp add --transport http moveo https://mcp.moveo.ai/mcp
```

Then run `/mcp` and sign in. For US Central or Brazil, use `mcp.us-central.moveo.ai` or `mcp.sa-east.moveo.ai` in place of `mcp.moveo.ai`.

</details>

## Develop

1. Load your checkout for one session: `claude --plugin-dir .`
2. Validate the manifests: `claude plugin validate . --strict`
3. Run the local checks: `./scripts/check-versions.sh` and `./scripts/check-vocabulary.sh`

Commit messages follow Conventional Commits. release-please opens the release pull request, sets `version` in `plugin.json`, and writes the changelog.

## Security

The plugin contains no credentials, no hooks and no compiled code. It does two things:

1. It declares the three Moveo.AI MCP servers (`mcp.moveo.ai`, `mcp.us-central.moveo.ai` and `mcp.sa-east.moveo.ai`), which Claude Code or Codex reach over HTTPS. A server acts with the permissions of the Moveo.AI user who signs in to it. The plugin sends data to no other destination.
2. It adds four skills, which are Markdown instructions for Claude.

The skills tell Claude to treat transcripts, documents and knowledge base content as untrusted data.

Moveo.AI handles the data in your account under its [Privacy Policy](https://moveo.ai/privacy-policy).

To report a security problem, open a private security advisory on this repository.

## Support

For help with the plugin or your Moveo.AI account, contact [Moveo.AI support](https://moveo.ai/support).

## License

The plugin's files are available under the [MIT License](LICENSE). The license covers this repository only. It does not give access to the Moveo.AI service: using Moveo.AI requires a paid Moveo.AI account and is subject to the [Moveo.AI Terms of Use](https://moveo.ai/terms-of-use). The license grants no rights to the Moveo.AI name or logo.
