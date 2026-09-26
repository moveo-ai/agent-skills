# Workflows

The server holds the contract. Read both resources before you compose `nodes`:

- `moveo://schemas/workflow-node-types` gives the node types (`intent`, `event`, `unknown`), the required fields, and the rules between fields.
- `moveo://guides/workflow-authoring` gives the patterns, the anti-patterns, and one worked example for each node type.

This file lists only the judgment that the resources do not make for you.

## Decide first

Ask one question before you build a workflow: must this step happen in a fixed order, record a value, call a webhook, or hand over to a human? If the answer is no, put the behavior in the guidelines instead.

Most production workflows have one to three nodes. If a draft has more, look for a question-and-answer chain that requisites can replace.

## Compose

1. Name the intent after the customer's goal, for example `start_return`, not after the first words of an utterance.
2. Give each intent 10 to 20 varied training expressions in the agent's language. Include short, long, polite, angry and misspelled forms.
3. Collect facts with requisites on one node. Each requisite has `save_as`, a question, and a `validation_guideline`. The runtime asks, validates and asks again. Do not add nodes for retries.
4. Branch with conditions. Put deterministic rules first, guideline rules second, and `else` last. The first branch that matches wins.
5. Call a webhook only after the requisites it needs are filled. Get the `webhook_id` from `moveo_list_agent_webhooks`. If the webhook does not exist yet, create it with `moveo_create_agent_webhook` and test it with `moveo_test_agent_webhook`.

## Change

- `moveo_update_agent_workflow` applies changes in a fixed order: it creates intents, then updates intents, then patches the dialog. Send one call with all the parts.
- Before you rename or delete an intent, call `moveo_get_dialog_references` to find nodes in other dialogs that point at it.
- `moveo_get_agent_workflow` returns only `expression_count`. Read the resource link it returns to see the full expressions.

## Verify

After every create or update, training starts. Poll `moveo_get_agent` until `status` is `available`. Then call `moveo_classify_utterance` with three utterances that must match the new intent and one that must not.
