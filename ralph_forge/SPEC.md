# SPEC.md — RalphForge SaaS (Phoenix + Ash)
Version: 1.0
This spec defines architecture, Ash resources, policies, workflows, and test strategy.
It is written to be production-ready and compatible with Elixir 1.19 / Phoenix 1.8 / Ash 3.

---

## 1) Architecture Overview

### 1.1 Components
- Phoenix 1.8 + LiveView UI
- Ash domains + AshPostgres for resources and data access
- AshAuthentication + AshAuthenticationPhoenix for auth
- Ash policies for authorization and usage limits
- Oban for background jobs (generation, webhook processing)
- Req for Claude API
- Stripity Stripe for billing and webhook handling
- Tailwind for styling
- AshAdmin for admin UI

### 1.2 Boundary Rules (DDD)
- Web layer (LiveViews/Controllers) must call **Domain APIs** only (Ash actions / domain modules).
- External integrations must be behind adapters:
  - `RalphForge.AI.Claude` (HTTP calls)
  - `RalphForge.Billing.Stripe` (checkout + webhooks)
- Background jobs orchestrate work but do not contain business rules that belong in Ash resources/policies.

---

## 2) Domains & Resources (Ash)

### 2.1 Accounts Domain (`RalphForge.Accounts`)
Resources:
- `RalphForge.Accounts.User`
- (optional) `RalphForge.Accounts.Token` (if needed; AshAuth can manage tokens)

#### User attributes
- `id` (uuid primary key)
- `email` (string, required, unique)
- `hashed_password` (managed by AshAuth)
- `role` (atom: :user | :admin) default :user
- `inserted_at`, `updated_at`

#### User actions
- `create :register_with_password` (AshAuth)
- `read :by_id`
- `read :by_email`
- `update :make_admin` (admin-only)
- `destroy :delete` (admin-only)

#### Policies
- Users can read/update themselves
- Admins can read all
- Only admins can access admin panel routes

---

### 2.2 Templates Domain (`RalphForge.Templates`)
Resource: `RalphForge.Templates.Template`

Attributes:
- `id` uuid
- `name` string required unique
- `description` string
- `category` atom (:saas, :mobile, :api, :cli, :phoenix)
- `content` text required (prompt template body)
- `is_premium` boolean default false
- timestamps

Actions:
- `read :list` (public for logged-in users)
- `create/update/destroy` (admin-only)
- `read :by_category`

Seed:
- Create seed module to insert default templates on dev/prod boot (or mix task).

Policies:
- All authenticated users can read templates
- Premium templates only readable if subscription >= Starter (optional toggle)

---

### 2.3 Tasks Domain (`RalphForge.Tasks`)
Resources:
- `RalphForge.Tasks.Task` (primary)
- `RalphForge.Tasks.Generation` (progress tracking)

#### Task attributes
- `id` uuid
- `input_idea` string required
- `status` atom (:pending, :generating, :completed, :failed) default :pending
- `generated_markdown` text (final output)
- `generated_json` map (structured output for export)
- `tokens_used` integer
- `error_message` string (for failed)
- relationships:
  - `belongs_to :user` (required)
  - `belongs_to :template` (optional)
  - `has_many :generations`

#### Task actions
- `create :create` (authenticated; subject to usage policy)
- `read :list_for_user` (filter by actor)
- `read :get` (actor owns or admin)
- `update :mark_generating`
- `update :complete`
- `update :fail`
- `action :enqueue_generation` (custom) → enqueues Oban job

#### Generation attributes
- `id` uuid
- `task_id` uuid required
- `stage` atom (:queued, :preparing, :calling_ai, :parsing, :saving, :completed, :failed)
- `progress` integer 0..100
- `message` string
- `partial_markdown` text (optional)
- timestamps

Generation actions:
- `create :start_for_task`
- `update :progress`
- `update :finish`
- `update :fail`

Policies:
- Actor must own task/generation, or be admin.

---

### 2.4 Billing Domain (`RalphForge.Billing`)
Resources:
- `RalphForge.Billing.Plan` (static rows)
- `RalphForge.Billing.Subscription`
- `RalphForge.Billing.UsageEvent`

#### Plan attributes
- `id` uuid
- `code` atom (:free, :starter, :pro, :team) unique
- `name` string
- `price_cents` integer
- `tasks_per_month` integer
- `stripe_price_id` string (env-backed; store copy for reference)
- timestamps

#### Subscription attributes
- `id` uuid
- `user_id` uuid required
- `plan_code` atom
- `stripe_customer_id` string
- `stripe_subscription_id` string
- `status` atom (:pending, :active, :canceled, :past_due, :incomplete, :expired)
- `current_period_start` utc_datetime
- `current_period_end` utc_datetime
- timestamps

Actions:
- `read :current_for_user`
- `create :from_checkout` (webhook-driven)
- `update :sync_from_stripe` (webhook-driven)
- `update :cancel`

#### UsageEvent attributes
- `id` uuid
- `user_id` uuid required
- `task_id` uuid optional
- `event_type` atom (:task_generated)
- `occurred_at` utc_datetime required
- `month_key` string (e.g., "2026-01")
- timestamps

Actions:
- `create :record_task_generated`
- `read :count_for_user_month` (aggregate)

Policies:
- Users can read their own subscription and usage
- Admin can read all

---

## 3) Usage Limits & Enforcement (Ash Policies)

### 3.1 Entitlement Resolution
Compute effective plan:
- If user has active subscription => that plan
- Else => :free

### 3.2 Monthly Usage
Define month_key as UTC year-month, e.g. `Timex.format!(Date.utc_today(), "{YYYY}-{0M}")`
(or `Calendar.strftime` equivalents; keep deps minimal.)

### 3.3 Enforcement Policy (recommended)
Enforce at Task creation:
- deny `Task.create` if user has exceeded `tasks_per_month` for current month_key.

Implementation options:
- Policy check using `Ash.Policy.SimpleCheck` + query aggregate
- Or custom `Ash.Policy.Check` module that:
  - resolves plan
  - queries usage count for month
  - compares to limit

Count usage on completion:
- Create `UsageEvent` when generation completes successfully.

Note: If you want to count attempts, record on enqueue instead.

---

## 4) AI Integration — Claude (Req)

### 4.1 Module
`RalphForge.AI.Claude`

Responsibilities:
- Build prompt from:
  - user idea
  - selected template content
  - system constraints (output format)
- Call Claude API via Req
- Support:
  - non-streaming response (v1)
  - optional streaming (v1.1)
- Return structured result:
  - markdown output
  - extracted JSON (if included)
  - token usage estimate if available

### 4.2 Prompt Contract (Output)
Claude must output:
1) A Markdown “Ralph task” (primary)
2) A JSON block for structured export (secondary)

Example (spec):
- Markdown contains: goal, assumptions, milestones, steps, acceptance criteria
- JSON contains fields like:
  - title
  - summary
  - milestones[]
  - tasks[] with id, title, description, done_when[]
  - tech_stack

### 4.3 Error Handling
- 429 / 5xx => retry with exponential backoff in Oban (max attempts)
- 4xx => fail task with clear message
- Always redact keys and sensitive data from logs

### 4.4 Testing
Use Mox:
- Define behaviour `RalphForge.AI.Provider`
- `Claude` implements it
- Tests inject `ClaudeMock`

---

## 5) Background Jobs (Oban)

### 5.1 Workers
- `RalphForge.Tasks.Workers.GenerateWorker`
  - args: %{task_id: uuid}
  - steps:
    1) mark task generating
    2) create generation record stage queued → preparing
    3) call Claude, update progress stages
    4) parse output to markdown/json
    5) update task complete + record usage event
    6) broadcast progress to LiveView

- `RalphForge.Billing.Workers.StripeWebhookWorker` (optional)
  - args include event id/payload
  - idempotency key: stripe event id

### 5.2 Progress Broadcasting
Use Phoenix PubSub:
- Topic: `"task_generation:#{task_id}"`
- LiveView subscribes and receives:
  - stage updates
  - progress percentage
  - partial output (optional)

### 5.3 Idempotency
GenerateWorker should be idempotent:
- If task already completed => no-op
- If generating but has generation record => resume or fail safely

---

## 6) Web Layer (Phoenix/LiveView)

### 6.1 Routes
- `/` HomeLive
- `/register` AuthLive.Register
- `/login` AuthLive.Login
- `/logout` (AshAuth route helper)
- `/dashboard` DashboardLive (authenticated)
- `/tasks` TaskLive.Index (authenticated)
- `/tasks/new` TaskLive.New (authenticated)
- `/tasks/:id` TaskLive.Show (authenticated)
- `/billing/plans` BillingLive.Plans
- `/billing/success` BillingLive.Success
- `/stripe/webhook` WebhookController (POST)
- `/admin` AshAdmin (admin-only)

### 6.2 LiveView Behaviors
TaskLive.New:
- form input idea + template selection
- on submit:
  - create Task
  - enqueue generation
  - show progress component
  - subscribe to PubSub topic
- on completion:
  - redirect to show page or render results inline

TaskLive.Show:
- syntax-highlighted markdown (client-side)
- export buttons (routes or endpoints)
- copy button (JS hook)

TaskLive.Index:
- list tasks for current user (keyset pagination)
- filters: status/date/template (optional)

### 6.3 Syntax Highlighting
Options:
- Use client-side highlight.js for fenced code blocks
- Or render with a markdown renderer and decorate blocks
Keep it simple: highlight.js + Tailwind prose styles.

### 6.4 Export Endpoints
- `/tasks/:id/export.md`
- `/tasks/:id/export.json`
Controllers can fetch task and send file response.
Protect by ownership.

---

## 7) Billing (Stripe)

### 7.1 Checkout
`RalphForge.Billing.Stripe.create_checkout_session(user, plan_code)`
- creates Stripe Checkout session for subscription
- uses env vars:
  - STRIPE_API_KEY
  - STRIPE_PRICE_* IDs
- success/cancel URLs point back to app

### 7.2 Webhook Handler
Controller verifies signature using STRIPE_WEBHOOK_SECRET.
On event:
- enqueue StripeWebhookWorker (preferred) or process inline
Handle:
- checkout.session.completed → create/update customer + subscription
- customer.subscription.updated/deleted → update subscription record
- invoice.payment_failed → mark past_due

### 7.3 Plan Mapping
Plan resource holds tasks_per_month and price.
Stripe price id mapping stored in env and mirrored into plan rows.

---

## 8) Admin (AshAdmin)
Mount AshAdmin:
- protect route with an admin-only plug
- policies ensure only admin can read all resources
Expose:
- Users
- Tasks
- Subscriptions
- UsageEvents
- Templates
Provide simple aggregates (counts by plan, tasks per day)

---

## 9) Testing Strategy (TDD)

### 9.1 Test Layers
- Unit: policy checks, AI parsing, entitlement calculation
- Resource tests: Ash actions (create/read/update), policies
- LiveView tests: registration/login, task creation, progress UI, history
- Billing tests: webhook signature verification, subscription sync (mock Stripe calls)

### 9.2 Mocks
- Claude: Mox behaviour
- Stripe: Mox behaviour or use Stripe test events with verified signatures in integration tests

### 9.3 Quality Gates
CI must run:
- `mix compile --warnings-as-errors`
- `mix test`
- `mix credo --strict`
- `mix dialyzer`

---

## 10) Ralph Loop (Internal Development Protocol)

### 10.1 Repo State Files
Create `.ralph/`:
- `.ralph/ralph_state.json` (machine-readable)
- `.ralph/ralph_log.md` (human-readable)
- `.ralph/ralph_plan.md` (milestones, next tasks)

### 10.2 Iteration Rules
Each iteration:
1) Read state
2) Identify next failing test / next checklist item
3) RED: write failing test
4) GREEN: implement minimum
5) REFACTOR: clean code
6) Update state/log
7) Commit if green

Completion token is emitted only when all success criteria + quality gates pass.

---

## 11) Project Structure (Canonical)
Align your project to:

lib/ralph_forge/
  accounts/
  tasks/
  templates/
  billing/
  ai/
  audit/ (optional)
lib/ralph_forge_web/
  live/ (auth, tasks, billing, dashboard)
  controllers/ (stripe webhook + exports)
  components/

This keeps the system maintainable and consistent with Ash DDD.