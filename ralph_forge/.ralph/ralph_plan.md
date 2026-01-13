# Ralph plan

## Context
- Objective: Build RalphForge SaaS as described in `ralph_forge_task.md`.
- Current state: Phoenix app exists with Ash domains for Accounts/Tasks, Claude client, and an Oban worker; many LiveViews and features are still missing.

## Subtasks (ordered)
1. Inventory: map existing code to success criteria and identify gaps.
2. Auth/accounts: ensure AshAuthentication actions and registration/login/logout UI.
3. Tasks core: task actions, status updates, and TaskGenerationWorker wiring; provide Tasks API functions.
4. Task UI: LiveViews for new/index/show with real-time progress.
5. Task outputs: syntax highlighting; export Markdown/JSON; copy to clipboard.
6. Templates: resource + seeds; template selection in task creation.
7. Billing: plan/subscription/usage resources; Stripe checkout + webhooks; usage limits.
8. Admin: Ash admin access; admin role; monitoring views.
9. UX polish: loading states, transitions, responsive layout.
10. Quality gates: tests, credo, dialyzer, precommit.

## Next up
- Start auth/accounts (subtask 2): add AshAuthentication actions and LiveView auth UI.

## Inventory summary
### Present
- Phoenix 1.8 app with core web plumbing, layouts, and a static home page.
- Ash domains for Accounts/Tasks/Templates/Billing; Tasks and Accounts resources exist.
- AshAuthentication password strategy + token resource; signing secret wired.
- Claude API client via Req, TaskGenerator service, and Oban worker skeleton.
- AshAdmin route mounted at `/admin`; Task resource has AshAdmin columns.

### Missing vs success criteria
- No LiveViews (tasks UI, auth UI, dashboard); only controller-based home page exists.
- Accounts: no create/register actions, validations, or AshAuthentication UI wiring.
- Tasks: no context functions; missing status update actions for processing/failed; status type mismatch.
- Generation flow: worker/task generator call missing Tasks API implementation; no real-time progress updates.
- Task outputs: no syntax highlighting, export (MD/JSON), or clipboard support.
- Templates domain/resources/seeds and template selection missing.
- Billing domain/resources/Stripe integration/usage limits missing.
- Admin: users not exposed via AshAdmin; no admin role or usage stats.
- Quality gates not verified; existing worker tests reference missing Tasks functions.
