# SPEC.md — Ralph Runner (Production Technical Specification)

## 0. Overview
This SPEC defines the architecture, data model, state machines, integrations, and repo-execution design for Ralph Runner.

Core design choice (v1): **Rails control plane + GitHub Actions execution**.
- Rails: UI, policies, plan/task management, audit log, run registry.
- GitHub Actions: executes Ralph Loop within the repo, produces PRs, posts status.

---

## 1. System Architecture

### 1.1 Components
1) **Web App (Rails 8)**
- Hotwire/Turbo + Tailwind UI
- Postgres persistence
- Solid Queue jobs for background work:
  - webhook processing
  - plan generation dispatch
  - run dispatch
  - sync repo metadata

2) **GitHub Integration**
- GitHub App installation model (preferred)
- Webhooks ingested by Rails (`/webhooks/github`)
- GitHub API calls (Octokit):
  - list repos for installation
  - create workflow dispatch
  - create PR (optional; usually action does it)
  - create revert PR
  - fetch PR metadata/status

3) **Execution Engine (GitHub Actions)**
- Workflows stored in repo under `.github/workflows/`:
  - `ralph_plan.yml`
  - `ralph_build.yml`
  - `ralph_revert.yml` (optional; revert can be API-only)
- Actions runner:
  - checks out repo
  - ensures `/ralph` exists (bootstrap step if needed)
  - runs `ralph/bin/loop.sh` in bounded mode
  - runs `ralph/bin/run_checks.sh` fast/full as directed
  - commits to branch `ralph/run-<run_id>`
  - opens PR
  - uploads logs/artifacts (optional)
  - sends status back (via GitHub status + webhook to Rails)

### 1.2 Why Actions (v1)
- Zero local setup for non-technical users.
- No need to run untrusted code on our servers.
- Scales with GitHub infrastructure and user trust.

---

## 2. Repository “Ralph Folder” Contract

### 2.1 Required files
Repo must have:
- `ralph/SPECS/*` — markdown specs
- `ralph/IMPLEMENTATION_PLAN.md`
- `ralph/AGENTS.md`
- `ralph/PROMPT_plan.md`
- `ralph/PROMPT_build.md`
- `ralph/bin/loop.sh`
- `ralph/bin/run_checks.sh`

Optional:
- `ralph/ralph.config.json` (polyglot modules)
- `ralph/deps.contracts.json` (contract fan-out rules)
- `ralph/RALPH_DONE`, `ralph/RALPH_FATAL`, `ralph/RALPH_PAUSE` (stop signals)

### 2.2 Bootstrap
If missing, Rails can open a PR that adds the standard `ralph/` template (recommended onboarding path):
- “Enable Ralph Runner” button → creates PR adding folder + workflows.

---

## 3. Ralph Loop Execution Contract

### 3.1 Modes
- `plan`: update `IMPLEMENTATION_PLAN.md` only, no code changes
- `build`: implement exactly one task, update plan, run checks, commit, exit
- `refactor` (optional): non-functional improvements only

### 3.2 “One task per iteration” rule
Build mode MUST:
- select single next unblocked task
- implement it
- add/adjust tests
- run validation
- update plan
- commit
- exit

### 3.3 Validation rules
- Fast checks always for affected modules
- Full checks:
  - on schedule (every N runs) OR
  - when contract files changed OR
  - when policy demands (high risk)

### 3.4 Fail-streak breaker
If checks fail repeatedly:
- write `ralph/RALPH_FATAL` (or `RALPH_PAUSE`)
- stop workflow
- Rails UI shows “needs decision” and prompts user with choices.

---

## 4. GitHub App Spec

### 4.1 Permissions (minimum viable)
- Repository contents: read/write (for branches and commits)
- Pull requests: read/write
- Actions: read (and workflow dispatch if needed via API)
- Checks/Statuses: read

### 4.2 Webhooks
Subscribe to:
- `installation`, `installation_repositories`
- `pull_request`
- `workflow_run` (or `check_suite`)
- `push` (optional)
- `repository` (rename/delete)

### 4.3 Webhook verification
- Verify `X-Hub-Signature-256` using the app’s webhook secret.
- Reject invalid signatures with 401.

### 4.4 Token handling
- Store installation IDs and use GitHub App JWT → installation token exchange.
- Encrypt any stored tokens (ideally store none; fetch tokens on demand).

---

## 5. Workflows (GitHub Actions)

### 5.1 `ralph_build.yml` (high level)
Inputs:
- `run_id`
- `task_id`
- `mode=build`
- `policy_json` (snapshot)
Steps:
1) Checkout repo
2) Ensure `ralph/` exists (fail with guidance if missing)
3) Apply policy guardrails:
   - block changes to locked paths
   - enforce max iterations
4) Run one iteration:
   - `ralph/bin/loop.sh build 1`
5) Run checks:
   - `ralph/bin/run_checks.sh fast`
   - optionally `full`
6) Create branch `ralph/run-<run_id>`
7) Commit changes
8) Create PR (title includes task + run id)
9) Output PR URL (as artifact/log)

### 5.2 `ralph_plan.yml`
Inputs:
- `project_id` / `run_id`
Steps:
- Run plan mode once (or bounded)
- Commit only plan changes to PR OR write plan output artifact for Rails to ingest

Recommended: create PR for plan updates too (transparent & auditable).

### 5.3 `ralph_revert.yml` (optional)
Inputs:
- `pr_number` or `merge_commit_sha`
Steps:
- create revert branch
- open revert PR

Alternative: Rails can call GitHub API to create revert PR.

---

## 6. Rails Domain Model (Suggested)

### 6.1 Tables (core)
- `users`
- `github_installations`
  - installation_id (unique)
  - account_login
  - account_type (User/Org)
  - metadata JSON
- `projects`
  - user_id (owner)
  - github_installation_id
  - repo_full_name
  - default_branch
  - status (enum)
- `spec_versions`
  - project_id
  - content (text)
  - source (ui/upload)
- `plans`
  - project_id
  - version
  - raw_markdown
  - parsed_json (tasks snapshot)
- `tasks`
  - project_id
  - plan_id
  - title
  - description
  - impact (enum)
  - risk (enum)
  - status (enum: idea/planned/in_progress/done)
  - acceptance_json
  - modules_json
  - order_index
  - depends_on_task_ids (json)
- `runs`
  - project_id
  - task_id (nullable for plan runs)
  - status (enum)
  - github_workflow_run_id (nullable)
  - pr_number (nullable)
  - pr_url (nullable)
  - logs_url (nullable)
  - policy_snapshot_json
  - started_at / finished_at
- `policies`
  - project_id
  - pr_only (bool)
  - locked_paths_json
  - require_approval_high_risk (bool)
  - max_runs_per_day
  - max_iterations_per_run
  - full_checks_every
  - daily_budget_cents (optional)
- `approvals`
  - run_id
  - reviewer_user_id
  - status (approved/denied)
  - note
- `audit_events`
  - actor_id
  - project_id
  - event_type
  - payload_json

### 6.2 Enums
- Project status: `stable`, `needs_attention`, `blocked`
- Run status: `queued`, `running`, `succeeded`, `needs_approval`, `failed`, `blocked`, `paused`
- Risk: `low`, `medium`, `high`
- Impact: `low`, `medium`, `high`

---

## 7. State Machines

### 7.1 Task state machine
`idea → planned → in_progress → done`
Transitions:
- planned → in_progress when a run is started
- in_progress → done when a run succeeded & PR merged (optional) OR when user marks done
Recommendation: track “implemented” separate from “merged” for clarity:
- `implemented` when PR created
- `shipped` when merged

### 7.2 Run state machine
`queued → running → (succeeded | needs_approval | failed | blocked | paused)`
Rules:
- `needs_approval` if:
  - task risk=high AND policy requires approval
  - OR locked-path touched attempt detected
- `blocked` if missing env/secrets or guardrail violation
- `paused` if fail-streak breaker triggers and user input is required

---

## 8. Policies & Enforcement

### 8.1 Pre-dispatch enforcement (Rails)
Before dispatching build:
- if daily run limit reached → block
- if budget exceeded → block
- if task risk high and approvals required:
  - either require approval before run OR allow run but require approval before merge (choose one policy)
Recommended v1: require approval before merge; allow run to create PR but label as “approval required”.

### 8.2 In-run enforcement (Actions)
- Compute diff vs base branch after changes.
- If any file matches locked paths → fail run, mark status blocked, do not open PR OR open PR labeled “blocked” (configurable).
Recommended: fail and do not open PR to avoid leaking sensitive diffs.

---

## 9. Plan & Task Generation (LLM)

### 9.1 Inputs
- Latest Specs
- Repo structure (file list; optionally key files)
- Existing plan/task history
- Policies (risk constraints)

### 9.2 Output requirements
- Tasks must be “one-iteration sized”
- Each task includes:
  - acceptance checklist
  - validation expectations (fast/full)
  - modules likely touched
  - dependencies

### 9.3 Storage
- Store plan markdown + parsed JSON representation
- Keep older plan versions for audit and rollback

---

## 10. UX Technical Notes

### 10.1 “Plain English” summaries
Generate PR summaries from:
- git diff stats + changed paths
- task acceptance checklist
- run logs (structured)
Output:
- What changed
- Why
- How to verify
- Risk

### 10.2 Logs & artifacts
- For each run:
  - store GitHub workflow run URL
  - optionally store artifact links (zipped logs)
- Rails displays “technical logs” behind a disclosure panel.

---

## 11. Security Requirements
- Webhook signature verification required.
- Encrypt sensitive fields at rest (Rails Active Record Encryption).
- Least privilege GitHub App permissions.
- Redact secrets from logs (Actions masking + Rails log filtering).
- Rate-limit webhook endpoint and API endpoints.
- Audit trail for all user actions and run dispatches.

---

## 12. Performance & Reliability
- Webhook processing via background jobs; HTTP responds quickly with 202.
- Idempotency keys on webhook deliveries (GitHub delivery ID).
- Retry with exponential backoff for GitHub API calls.
- Job dead-letter queue + admin UI for reprocessing.

---

## 13. Polyglot Module Detection & Contract Fan-out
- `ralph.config.json` defines modules and commands.
- `deps.contracts.json` defines contract files and affected modules.
- `run_checks.sh`:
  - identifies changed files
  - maps to modules
  - expands via contract fan-out
  - runs checks only for impacted modules

---

## 14. Acceptance Criteria (System-Level)
- A user can install GitHub App and select a repo.
- The app can generate a plan and show tasks as cards.
- “Build Next” triggers a GitHub Action run and creates a PR.
- Runs and PR status appear correctly in UI with history.
- Locked paths policy blocks disallowed modifications.
- High-risk tasks require approval per policy.
- Undo creates a revert PR reliably.
- Ralph Loop updates plan deterministically and stays “one task per run.”

---

## 15. Implementation Notes (Suggested Rails Structure)
- Controllers:
  - `ProjectsController`
  - `SpecsController`
  - `PlansController` (generate)
  - `TasksController`
  - `RunsController` (dispatch + show)
  - `SettingsController` (policies)
  - `Webhooks::GithubController`
- Jobs:
  - `Github::HandleWebhookJob`
  - `Github::DispatchWorkflowJob`
  - `Plans::GeneratePlanJob`
- Services:
  - `Github::AppClient`
  - `Github::RepoSync`
  - `Runs::PolicyEvaluator`
  - `Runs::SummaryBuilder`

---

## 16. Repo Onboarding Template (Required Assets)
Provide an “Enable Ralph” PR that adds:
- `ralph/` folder with:
  - prompts, specs, plan, agents
  - loop scripts + check runner
- `.github/workflows/ralph_plan.yml`
- `.github/workflows/ralph_build.yml`
- `.github/workflows/ralph_revert.yml` (optional)

This ensures “no hassle” setup for non-technical users.