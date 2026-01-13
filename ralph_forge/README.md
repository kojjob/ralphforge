# RalphForge — Build Ralph Tasks from Business Ideas (SaaS)
RalphForge is a Phoenix + LiveView SaaS that turns a business idea into a high-quality, executable **Ralph Task** using Claude. It includes templates (SaaS/Mobile/API/etc.), real-time progress during generation, task history, exports (Markdown/JSON), and subscription billing with Stripe. Built with **Ash Framework** for DDD + policies.

> Mantra: **"I choo-choo-choose to iterate until success!"**

---

## ✨ Features (v1)
### Core
- Email/password registration & login (AshAuthentication + AshAuthenticationPhoenix)
- Create a task by entering a business idea in LiveView
- Select a template (SaaS, Mobile, API, etc.) to shape the output
- Calls Claude (Anthropic) to generate the Ralph Task
- Live progress updates during generation (Oban + PubSub)
- Syntax-highlighted output
- Task history list and detail view
- Export as Markdown and JSON
- Copy-to-clipboard

### Billing
- Stripe Checkout subscriptions via Stripity Stripe
- Plans: **Free (3/mo), Starter (20/mo $19), Pro (100/mo $49), Team (500/mo $149)**
- Usage tracking and plan limit enforcement (Ash policies)
- Stripe webhooks for subscription lifecycle updates

### Admin
- Ash Admin panel at `/admin` (admin-only)
- View users, tasks, templates, subscriptions, usage

### Quality Gates
- `mix compile --warnings-as-errors`
- `mix test`
- `mix credo --strict`
- `mix dialyzer`

---

## 🧱 Tech Stack
- Elixir 1.19+  
- Phoenix 1.8+ + LiveView  
- Ash 3 + AshPostgres  
- AshAuthentication + AshAuthenticationPhoenix  
- Authorization: Ash Policies  
- Jobs: Oban  
- AI: Claude API via Req  
- Payments: Stripity Stripe  
- Styling: TailwindCSS  
- DB: PostgreSQL  

---

## 🚀 Getting Started (Local Dev)

### 1) Prerequisites
- Elixir 1.19+
- Erlang/OTP compatible with Elixir 1.19
- PostgreSQL 14+
- Node.js (for assets, if needed by your Phoenix setup)

### 2) Clone and setup
```bash
git clone <your_repo_url>
cd ralph_forge

mix deps.get
mix ecto.create
mix ecto.migrate

mix phx.server