# PRD.md — RalphForge SaaS
Version: 1.0
Owner: Kojo
Stack: Elixir 1.19+, Phoenix 1.8+, LiveView, Ash 3, AshPostgres, AshAuthentication, AshAdmin, Oban, Stripity Stripe, Tailwind, PostgreSQL, Req (Claude)

## 1) Product Summary
RalphForge is a SaaS that transforms a user's business idea into an **executable, structured Ralph task** (a step-by-step build plan) using Claude. It is optimized for “average users”: minimal friction, clear progress feedback, and exportable results.

RalphForge also provides a standardized **Ralph Loop** iteration protocol inside the codebase, ensuring deterministic, test-driven delivery and predictable product evolution.

## 2) Primary Objective
A logged-in user can enter a business idea, optionally pick a template, and generate a high-quality “Ralph task” with:
- real-time progress updates
- syntax-highlighted output
- task history
- export (Markdown/JSON)
- usage limits by subscription plan
- Stripe billing
- admin visibility (users/tasks/usage)

## 3) Success Criteria (Definition of Done)
The release is complete when all are true:

### Core
- [ ] User can register with email/password
- [ ] User can log in and log out
- [ ] User can input a business idea via LiveView form
- [ ] System calls Claude API to generate Ralph task
- [ ] Real-time progress updates during generation (LiveView)
- [ ] Generated task displayed with syntax highlighting
- [ ] User can view their task history
- [ ] User can export tasks as Markdown
- [ ] User can export tasks as JSON
- [ ] User can copy task to clipboard

### Templates
- [ ] Pre-built templates available (SaaS, Mobile, API, etc.)
- [ ] User can select template before generation
- [ ] Templates influence generated output

### Billing
- [ ] Stripe Checkout subscriptions
- [ ] Four plans: Free, Starter ($19), Pro ($49), Team ($149)
- [ ] Usage tracking (tasks generated per month)
- [ ] Usage limits enforced per plan
- [ ] Stripe webhook handling for subscription lifecycle events

### Admin & Monitoring
- [ ] Ash Admin panel accessible at `/admin`
- [ ] Admin can view all users
- [ ] Admin can view all generated tasks
- [ ] Admin can view usage statistics

### Quality Gates
- [ ] `mix compile --warnings-as-errors` passes
- [ ] `mix test` passes
- [ ] `mix credo --strict` passes
- [ ] `mix dialyzer` passes
- [ ] Migrations run cleanly

## 4) Personas
### A) Non-technical founder
Wants a clear, structured plan that can be handed to a developer/AI to build.

### B) Solo technical builder
Wants consistently formatted, actionable tasks and templates for different project types.

### C) Admin/operator
Wants visibility into usage, subscriptions, failures, and user activity.

## 5) User Journeys

### 5.1 Onboarding
1. Visit homepage
2. Register
3. Land on dashboard
4. Create first task (idea + template)
5. See progress during generation
6. View result + export/copy

### 5.2 Task Generation (Happy Path)
1. User goes to “New Task”
2. Chooses template (optional)
3. Submits idea
4. UI shows “Generating…” with live progress
5. Task completes and is displayed with syntax highlighting
6. User exports or copies result

### 5.3 Usage Limit (Free plan)
1. User reaches monthly limit
2. Create Task blocks with friendly message + CTA to upgrade
3. Upgrade → can generate again

### 5.4 Subscription
1. User chooses plan on pricing page
2. Stripe checkout
3. Return to success page
4. Subscription active; usage limits updated
5. Webhooks keep state correct even if user closes browser

### 5.5 Admin
1. Admin logs in
2. Visits `/admin`
3. Views users, tasks, subscriptions, usage
4. Can inspect failures/blocked generations

## 6) Product Requirements (Functional)

### 6.1 Accounts & Auth
- Email/password registration and login via AshAuthentication + AshAuthenticationPhoenix.
- Password policy: minimum length, complexity rules (configurable).
- Sessions/tokens managed by AshAuth.
- Optional “admin” boolean on user with policies restricting `/admin`.

### 6.2 Tasks (Idea → Generated Output)
A “Task” represents a generated deliverable:
- input idea (required)
- template (optional)
- generation status: pending/generating/completed/failed
- generated output: markdown string (primary)
- structured output JSON for exports
- token usage estimate
- timestamps
- belongs to user

### 6.3 Templates
Pre-built templates that influence output:
- SaaS Web App
- iOS Mobile (Swift/SwiftUI)
- REST API
- CLI Tool
- Phoenix App
Each template has:
- name, description, category, prompt_content
- is_premium flag (optional)
- used in generation request

### 6.4 Real-time Generation
- A generation runs in the background (Oban) and streams progress to the UI.
- UI displays progress steps and partial output if available.
- On completion, task is updated and UI transitions to results view.

### 6.5 Exports & Clipboard
- Export Markdown: downloads `.md`
- Export JSON: downloads `.json`
- Copy: copies markdown to clipboard using a small JS hook

### 6.6 Billing & Subscriptions
Plans:
- Free: 3 tasks/month
- Starter: 20 tasks/month ($19)
- Pro: 100 tasks/month ($49)
- Team: 500 tasks/month ($149)

Rules:
- Usage is counted per calendar month in the app’s timezone (UTC).
- Task generation increments usage on “generation success” (configurable; optional count on attempt).
- Enforce limits using Ash policies: deny create/generate when limit exceeded.
- Stripe subscription determines plan entitlement.

### 6.7 Stripe Integration
- Checkout Session creation (server-side).
- Webhooks:
  - checkout.session.completed
  - customer.subscription.created/updated/deleted
  - invoice.paid / invoice.payment_failed (optional)
- Webhooks are idempotent and verified by signature.

### 6.8 Admin Panel
- AshAdmin mounted at `/admin`
- Admin-only access enforced by policies + Phoenix plug.

## 7) Non-functional Requirements
- Security: strong auth, webhook verification, secret handling, rate limiting for generation endpoints.
- Reliability: Oban retries, idempotent jobs, robust failure reporting.
- Performance: list pages paginated; avoid N+1; use Ash pagination.
- Observability: structured logs, telemetry; track job failures and response times.
- Compliance: basic audit events for billing/generation actions.

## 8) Ralph Loop (Product Development Protocol)
RalphForge maintains a `.ralph/` directory for deterministic progress tracking:
- `.ralph/ralph_state.json` — iteration status, next step, counters
- `.ralph/ralph_log.md` — iteration log
- `.ralph/ralph_plan.md` — ordered implementation plan & current focus

Rules:
- Every iteration must be TDD (RED → GREEN → REFACTOR).
- If blocked, record reason in state and produce a minimal reproduction.
- Only declare completion when quality gates pass.

## 9) Out of Scope (v1)
- Multi-tenant org billing (can be v2)
- Team collaboration and shared projects (can be v2)
- Multiple AI providers (v2 via adapter interface)
- Native desktop app (v2)

## 10) Release Milestones
M1: Auth + basic UI shell (Home/Dashboard)
M2: Templates + Task creation + background generation + history
M3: Exports + clipboard + syntax highlighting
M4: Stripe plans + usage limits + webhooks
M5: Admin panel + usage dashboards
M6: Quality gates + deploy readiness