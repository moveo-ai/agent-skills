---
name: build-agent
description: Builds or changes a Moveo.AI conversational AI agent. Use when the user wants to create an agent from a brief or to write or fix its guidelines, tone or escalation rules. Also use to add intents and workflows, or to train, publish or roll back an agent. Requests such as "make the bot handle refunds" or "hand refunds over to a human" on a Moveo agent also qualify. Also matches Portuguese or Greek requests, such as "criar um agente" or "φτιάξε έναν agent".
---

# Build a Moveo.AI agent

If `moveo_whoami` did not confirm the account in this conversation, run the `get-started` skill first.

## The model

- An agent has one editable draft, version 0, and a list of immutable published versions. Only the draft accepts edits. Customers get the latest published version.
- Guidelines are the natural-language playbook: goal, overview, features, objections, tone, handover rules. The guideline text becomes the agent's runtime prompt.
- A workflow is a dialog plus the intents its nodes reference. Use workflows for flows that must happen exactly the same way every time, such as collecting an order number before a refund. Use guidelines for everything else.
- Training starts on its own after an edit to intents, dialogs, guidelines or tools.

## Build a new agent

1. Read `moveo://schemas/guideline-authoring` before you write any guideline text. It gives the purpose and character budget of each field.
2. Read `moveo://schemas/agent-languages` and `moveo://schemas/agent-types`. If the brief does not state the language, ask the user. The `language` field is permanent.
3. Call `moveo_create_agent` with the name, language, agent type and the `guidelines` distilled from the brief, in one call.
4. For each flow that must be exact, read `moveo://schemas/workflow-node-types` and `moveo://guides/workflow-authoring`, then call `moveo_create_agent_workflow`. See [references/workflows.md](references/workflows.md).
5. Call `moveo_validate_agent_guidelines` and fix what it reports.
6. Poll `moveo_get_agent` until `status` is `available`.
7. Test the draft with the `test-agent` skill before you publish.
8. Publish only after the user agrees. See "Publish" below.

The `build_agent_from_brief` server prompt runs steps 1 to 8 in one pass. If the user has a complete brief and wants no questions, offer it.

## Change an existing agent

1. Find the agent in the agents snapshot (see `get-started` for its uri). If the name is ambiguous, ask.
2. Read before you write: `moveo_get_agent_guidelines` for the playbook, `moveo_list_agent_workflows` for the flows.
3. Make the smallest edit that does the job. `moveo_update_agent_guidelines` deep-merges, so send only the fields you change.
4. Show the user what changed with `moveo_diff_agent_versions` from the latest published version to `0`.

## Publish

1. Poll `moveo_get_agent` until `status` is `available`.
2. Show the diff from the latest published version to `0` and get the user's approval.
3. Call `moveo_publish_agent` once, and wait for it to return. Do not call it again while it runs.
4. If the new version ends in `status: 'failed'`, fix the content, wait for training, and publish again. If the user wants the previous behavior back, offer `moveo_rollback_agent_to_version`.

## Failure modes

- Publish during training serves a half-trained agent. Always wait for `status: 'available'`.
- `moveo_update_agent` edits top-level fields such as name, model, knowledge base and tools. Guideline fields sent to it are wrong. Use `moveo_update_agent_guidelines` for the playbook.
- An edit to a published version fails. Edit the draft, then publish.
- Rollback overwrites the current draft. Diff first. If the draft holds unpublished work, warn the user.
- `moveo_clone_agent` works only on an agent that was never published.
- Deleting an intent leaves dialog nodes that point at a slug that no longer exists. Call `moveo_get_dialog_references` first, then name what will break and wait for the user's yes.
- If guidelines repeat the knowledge base, answers go stale after documents change. Put facts in the knowledge base and behavior in the guidelines.
- An agent answers from a knowledge base only with two settings: the knowledge base is attached, and the `search_knowledge_base` tool is enabled. Use the `knowledge-base` skill for that.

## Rules for every Moveo task

- Reply in the user's language. Keep tool arguments, resource names and the product terms environment, agent and knowledge base as the tools expect them.
- Before each publish, rollback or delete, name the account, the resource and what will change, then wait for an explicit yes. This holds even when the user asked for the change in the same message, because a request can name the wrong account or resource.
