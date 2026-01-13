# 🔥 RALPH TASK: Build RalphForge SaaS

## ROLE: Autonomous Iteration Agent ("Ralph")

You are an elite software engineer building **RalphForge** - a SaaS platform that transforms business ideas into executable Ralph Wiggum tasks. You follow strict TDD (Test-Driven Development) and DDD (Domain-Driven Design) methodologies.

**Your Mantra:** *"I choo-choo-choose to iterate until success!"*

---

## 🎯 PRIMARY OBJECTIVE

Build a complete, production-ready SaaS application using:

- **Language:** Elixir 1.19.0 +
- **Framework:** Phoenix 1.8+ with LiveView
- **Data Layer:** Ash Framework 3.0 + AshPostgres
- **Authentication:** AshAuthentication + AshAuthenticationPhoenix
- **Authorization:** Ash Policies
- **Background Jobs:** Oban
- **Payments:** Stripity Stripe
- **Styling:** TailwindCSS
- **Database:** PostgreSQL
- **AI Integration:** Claude API (via Req)

---

## ✅ SUCCESS CRITERIA

The task is complete when ALL of the following are true:

### Core Functionality

- [ ] User can register with email/password
- [ ] User can log in and log out
- [ ] User can input a business idea via LiveView form
- [ ] System calls Claude API to generate Ralph task
- [ ] Real-time progress updates shown during generation (LiveView)
- [ ] Generated task displayed with syntax highlighting
- [ ] User can view their task history
- [ ] User can export tasks as Markdown
- [ ] User can export tasks as JSON
- [ ] User can copy task to clipboard

### Templates System

- [ ] Pre-built templates available (SaaS, Mobile, API, etc.)
- [ ] User can select template before generation
- [ ] Templates influence the generated output

### Billing & Subscriptions
- [ ] Stripe Checkout integration for subscriptions
- [ ] Four plans: Free, Starter ($19), Pro ($49), Team ($149)
- [ ] Usage tracking (tasks generated per month)
- [ ] Usage limits enforced per plan
- [ ] Stripe webhook handling for subscription events

### Admin & Monitoring
- [ ] Ash Admin panel accessible at /admin
- [ ] Admin can view all users
- [ ] Admin can view all generated tasks
- [ ] Admin can view usage statistics

### Quality Gates
- [ ] All tests pass: `mix test`
- [ ] No Credo warnings: `mix credo --strict`
- [ ] Dialyzer passes: `mix dialyzer`
- [ ] No compiler warnings: `mix compile --warnings-as-errors`
- [ ] Database migrations run cleanly

### Completion Token
When ALL criteria above are met, output:
```
<RALPHFORGE_COMPLETE>
```

---

## 🔍 VERIFICATION COMMAND

Run this command to verify success:

```bash
mix compile --warnings-as-errors && \
mix test && \
mix credo --strict && \
mix dialyzer && \
echo "✅ ALL CHECKS PASSED"
```

---

## 📁 PROJECT STRUCTURE

Create and maintain this structure:

```
ralph_forge/
├── .ralph/                          # Ralph state (create this)
│   ├── ralph_state.json
│   ├── ralph_log.md
│   └── ralph_plan.md
│
├── config/
│   ├── config.exs
│   ├── dev.exs
│   ├── prod.exs
│   ├── runtime.exs
│   └── test.exs
│
├── lib/
│   ├── ralph_forge/
│   │   ├── application.ex
│   │   ├── repo.ex
│   │   │
│   │   ├── accounts/                # Accounts Domain
│   │   │   ├── accounts.ex          # Ash Domain
│   │   │   ├── resources/
│   │   │   │   ├── user.ex
│   │   │   │   └── token.ex
│   │   │   └── secrets.ex
│   │   │
│   │   ├── tasks/                   # Tasks Domain
│   │   │   ├── tasks.ex             # Ash Domain
│   │   │   ├── resources/
│   │   │   │   ├── task.ex
│   │   │   │   └── generation.ex
│   │   │   ├── changes/
│   │   │   │   └── generate_prompt.ex
│   │   │   └── workers/
│   │   │       └── generate_worker.ex
│   │   │
│   │   ├── templates/               # Templates Domain
│   │   │   ├── templates.ex
│   │   │   └── resources/
│   │   │       └── template.ex
│   │   │
│   │   ├── billing/                 # Billing Domain
│   │   │   ├── billing.ex
│   │   │   ├── resources/
│   │   │   │   ├── subscription.ex
│   │   │   │   ├── plan.ex
│   │   │   │   └── usage_event.ex
│   │   │   └── stripe/
│   │   │       └── webhook_handler.ex
│   │   │
│   │   └── ai/                      # AI Integration
│   │       ├── ai.ex
│   │       └── claude.ex
│   │
│   └── ralph_forge_web/
│       ├── endpoint.ex
│       ├── router.ex
│       ├── telemetry.ex
│       │
│       ├── components/
│       │   ├── core_components.ex
│       │   ├── layouts.ex
│       │   └── ui/
│       │       ├── button.ex
│       │       ├── card.ex
│       │       └── form.ex
│       │
│       ├── live/
│       │   ├── home_live.ex
│       │   ├── dashboard_live.ex
│       │   │
│       │   ├── task_live/
│       │   │   ├── index.ex
│       │   │   ├── new.ex
│       │   │   └── show.ex
│       │   │
│       │   ├── auth_live/
│       │   │   ├── register.ex
│       │   │   └── login.ex
│       │   │
│       │   └── billing_live/
│       │       ├── plans.ex
│       │       └── success.ex
│       │
│       └── controllers/
│           ├── auth_controller.ex
│           └── webhook_controller.ex
│
├── priv/
│   ├── repo/
│   │   └── migrations/
│   └── static/
│
├── test/
│   ├── ralph_forge/
│   │   ├── accounts/
│   │   │   └── user_test.exs
│   │   ├── tasks/
│   │   │   └── task_test.exs
│   │   ├── billing/
│   │   │   └── subscription_test.exs
│   │   └── ai/
│   │       └── claude_test.exs
│   │
│   ├── ralph_forge_web/
│   │   └── live/
│   │       ├── home_live_test.exs
│   │       ├── task_live_test.exs
│   │       └── auth_live_test.exs
│   │
│   └── support/
│       ├── data_case.ex
│       ├── conn_case.ex
│       └── factory.ex
│
├── mix.exs
├── mix.lock
├── .formatter.exs
├── .credo.exs
└── fly.toml
```

---

## 📦 DEPENDENCIES (mix.exs)

```elixir
defp deps do
  [
    # Phoenix Core
    {:phoenix, "~> 1.7.14"},
    {:phoenix_ecto, "~> 4.5"},
    {:phoenix_html, "~> 4.1"},
    {:phoenix_live_reload, "~> 1.5", only: :dev},
    {:phoenix_live_view, "~> 0.20.17"},
    {:phoenix_live_dashboard, "~> 0.8.4"},
    
    # Ash Framework
    {:ash, "~> 3.0"},
    {:ash_postgres, "~> 2.0"},
    {:ash_phoenix, "~> 2.0"},
    {:ash_authentication, "~> 4.0"},
    {:ash_authentication_phoenix, "~> 2.0"},
    {:ash_admin, "~> 0.11"},
    {:ash_oban, "~> 0.2"},
    
    # Database
    {:ecto_sql, "~> 3.11"},
    {:postgrex, ">= 0.0.0"},
    
    # Background Jobs
    {:oban, "~> 2.17"},
    
    # HTTP & API
    {:req, "~> 0.5"},
    {:jason, "~> 1.4"},
    
    # Payments
    {:stripity_stripe, "~> 3.2"},
    
    # Auth
    {:bcrypt_elixir, "~> 3.1"},
    
    # Email
    {:swoosh, "~> 1.16"},
    {:finch, "~> 0.18"},
    
    # Assets
    {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
    {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
    {:heroicons, "~> 0.5"},
    
    # Telemetry
    {:telemetry_metrics, "~> 1.0"},
    {:telemetry_poller, "~> 1.1"},
    
    # Dev & Test
    {:floki, ">= 0.36.0", only: :test},
    {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
    {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
    {:ex_machina, "~> 2.8", only: :test},
    {:mox, "~> 1.1", only: :test},
    
    # Runtime
    {:plug_cowboy, "~> 2.7"},
    {:gettext, "~> 0.24"},
    {:dns_cluster, "~> 0.1.3"}
  ]
end
```

---

## 🏗️ IMPLEMENTATION PHASES

### Phase 1: Project Bootstrap (Iteration 1-5)

1. **Create Phoenix project:**
   ```bash
   mix phx.new ralph_forge --live --no-dashboard
   cd ralph_forge
   ```

2. **Add dependencies to mix.exs**

3. **Configure Ash in config/config.exs:**
   ```elixir
   config :ralph_forge,
     ash_domains: [
       RalphForge.Accounts,
       RalphForge.Tasks,
       RalphForge.Templates,
       RalphForge.Billing
     ]
   
   config :ash,
     include_embedded_source_by_default?: false,
     default_page_type: :keyset,
     policies: [no_filter_static_forbidden_reads?: false]
   ```

4. **Set up .ralph/ state directory**

5. **Run initial setup:**
   ```bash
   mix deps.get
   mix ecto.create
   ```

### Phase 2: Accounts Domain (Iteration 6-15)

**TDD Cycle: Write tests first!**

1. **Create User resource with AshAuthentication:**
   - Email/password authentication
   - Password hashing with bcrypt
   - Token generation for sessions

2. **Create Accounts domain module**

3. **Write tests for:**
   - User registration
   - User login
   - Password validation
   - Token generation

4. **Create auth LiveViews:**
   - Registration form
   - Login form
   - Logout functionality

### Phase 3: Tasks Domain (Iteration 16-30)

**TDD Cycle: Write tests first!**

1. **Create Task resource:**
   ```elixir
   # Attributes needed:
   - id (uuid)
   - input_idea (string, required)
   - generated_prompt (string)
   - tech_stack (map)
   - feature_breakdown (map)
   - status (atom: pending, generating, completed, failed)
   - tokens_used (integer)
   - belongs_to :user
   - belongs_to :template (optional)
   - timestamps
   ```

2. **Create Generation resource** (tracks generation progress)

3. **Create Claude integration module:**
   ```elixir
   defmodule RalphForge.AI.Claude do
     @moduledoc "Claude API integration for task generation"
     
     def generate_ralph_task(idea, opts \\ []) do
       # Call Claude API
       # Stream response for real-time updates
       # Return structured result
     end
   end
   ```

4. **Create Oban worker for background generation**

5. **Create TaskLive modules:**
   - Index: List user's tasks
   - New: Form for new task + real-time generation
   - Show: Display generated task with export options

6. **Write tests for:**
   - Task creation
   - Task generation (mock Claude API)
   - Real-time updates
   - Export functionality

### Phase 4: Templates Domain (Iteration 31-40)

1. **Create Template resource:**
   ```elixir
   # Attributes:
   - id (uuid)
   - name (string)
   - description (string)
   - category (atom: saas, mobile, api, cli, library)
   - content (string) - the template prompt
   - is_premium (boolean)
   - timestamps
   ```

2. **Seed default templates:**
   - SaaS Web Application
   - iOS Mobile App (SwiftUI)
   - REST API
   - Elixir/Phoenix Application
   - CLI Tool

3. **Create template selection in task creation flow**

### Phase 5: Billing Domain (Iteration 41-55)

1. **Create Plan resource:**
   ```elixir
   # Plans:
   - free: 3 tasks/month, $0
   - starter: 20 tasks/month, $19
   - pro: 100 tasks/month, $49
   - team: 500 tasks/month, $149
   ```

2. **Create Subscription resource with state machine:**
   - States: pending, active, cancelled, expired
   - Transitions: activate, cancel, expire, renew

3. **Create UsageEvent resource for tracking**

4. **Implement Stripe integration:**
   - Checkout session creation
   - Webhook handling
   - Subscription management

5. **Create billing LiveViews:**
   - Plans page (pricing)
   - Success page (post-checkout)

6. **Enforce usage limits in Task creation policy**

### Phase 6: Admin & Polish (Iteration 56-70)

1. **Configure Ash Admin:**
   ```elixir
   # In router.ex
   import AshAdmin.Router
   
   scope "/" do
     pipe_through [:browser, :require_admin]
     ash_admin "/admin"
   end
   ```

2. **Add admin role to User**

3. **Create dashboard LiveView:**
   - Recent tasks
   - Usage stats
   - Quick actions

4. **Add UI polish:**
   - Loading states
   - Error handling
   - Toast notifications
   - Responsive design

5. **Add copy to clipboard functionality**

6. **Add syntax highlighting for generated output**

### Phase 7: Testing & Quality (Iteration 71-80)

1. **Achieve >80% test coverage**

2. **Fix all Credo warnings**

3. **Fix all Dialyzer warnings**

4. **Add integration tests for critical flows:**
   - Full registration → login → generate task flow
   - Subscription → usage tracking flow

5. **Performance testing with realistic data**

### Phase 8: Deployment Prep (Iteration 81-90)

1. **Create fly.toml configuration**

2. **Set up runtime.exs for production secrets**

3. **Create release configuration**

4. **Add health check endpoint**

5. **Final verification of all success criteria**

---

## 🔐 ENVIRONMENT VARIABLES

Create `.env.example`:

```bash
# Database
DATABASE_URL=postgres://localhost/ralph_forge_dev

# Phoenix
SECRET_KEY_BASE=generate-with-mix-phx-gen-secret
PHX_HOST=localhost

# Stripe
STRIPE_API_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
STRIPE_PRICE_STARTER=price_...
STRIPE_PRICE_PRO=price_...
STRIPE_PRICE_TEAM=price_...

# Claude API
ANTHROPIC_API_KEY=sk-ant-...

# Oban (optional)
OBAN_WEB_LICENSE_KEY=...
```

---

## 🧪 KEY TEST EXAMPLES

### User Registration Test

```elixir
defmodule RalphForge.Accounts.UserTest do
  use RalphForge.DataCase, async: true
  
  alias RalphForge.Accounts
  alias RalphForge.Accounts.User

  describe "register_with_password/1" do
    test "creates user with valid params" do
      params = %{
        email: "test@example.com",
        password: "SecurePass123!",
        password_confirmation: "SecurePass123!"
      }
      
      assert {:ok, user} = Accounts.register_with_password(params)
      assert user.email == "test@example.com"
      assert user.hashed_password != nil
    end

    test "fails with invalid email" do
      params = %{email: "invalid", password: "SecurePass123!"}
      
      assert {:error, _} = Accounts.register_with_password(params)
    end

    test "fails with weak password" do
      params = %{email: "test@example.com", password: "weak"}
      
      assert {:error, _} = Accounts.register_with_password(params)
    end
  end
end
```

### Task Generation Test

```elixir
defmodule RalphForge.Tasks.TaskTest do
  use RalphForge.DataCase, async: true
  
  import Mox
  import RalphForge.Factory
  
  alias RalphForge.Tasks
  alias RalphForge.AI.ClaudeMock

  setup :verify_on_exit!

  describe "create_task/2" do
    test "creates task for user within limit" do
      user = insert(:user, plan: :starter)
      
      assert {:ok, task} = Tasks.create_task(
        %{input_idea: "Build a habit tracker"},
        actor: user
      )
      
      assert task.status == :pending
      assert task.user_id == user.id
    end

    test "fails when user exceeds plan limit" do
      user = insert(:user, plan: :free)
      # Free plan = 3 tasks
      insert_list(3, :task, user: user)
      
      assert {:error, %Ash.Error.Forbidden{}} = Tasks.create_task(
        %{input_idea: "Another task"},
        actor: user
      )
    end
  end

  describe "generate_task/1" do
    test "generates ralph task via Claude API" do
      task = insert(:task, status: :pending)
      
      ClaudeMock
      |> expect(:generate_ralph_task, fn idea, _opts ->
        {:ok, %{
          prompt: "Generated prompt for: #{idea}",
          tech_stack: %{language: "elixir"},
          tokens_used: 1500
        }}
      end)
      
      assert {:ok, updated} = Tasks.generate_task(task)
      assert updated.status == :completed
      assert updated.generated_prompt =~ "Generated prompt"
    end
  end
end
```

### LiveView Test

```elixir
defmodule RalphForgeWeb.TaskLive.NewTest do
  use RalphForgeWeb.ConnCase, async: true
  
  import Phoenix.LiveViewTest
  import RalphForge.Factory

  describe "task creation" do
    setup :register_and_log_in_user

    test "renders form", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/tasks/new")
      
      assert html =~ "Create New Task"
      assert has_element?(view, "form#task-form")
    end

    test "submits and shows generating state", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/tasks/new")
      
      view
      |> form("#task-form", task: %{input_idea: "Build a SaaS"})
      |> render_submit()
      
      assert render(view) =~ "Generating"
    end
  end
end
```

---

## 🔁 ITERATION PROTOCOL

### Before Each Iteration

1. **Check current state:**
   ```bash
   cat .ralph/ralph_state.json
   ```

2. **Run verification:**
   ```bash
   mix compile --warnings-as-errors 2>&1 | head -20
   mix test 2>&1 | tail -10
   ```

3. **Identify next failing test or missing feature**

### During Each Iteration

Follow TDD strictly:

1. **RED:** Write a failing test
2. **GREEN:** Write minimum code to pass
3. **REFACTOR:** Clean up, maintain quality

### After Each Iteration

1. **Update .ralph/ralph_log.md:**
   ```markdown
   ## Iteration N - [timestamp]
   
   **Focus:** [what was attempted]
   **Outcome:** [success/partial/blocked]
   **Tests:** X passing, Y failing
   **Next:** [what to do next]
   ```

2. **Update .ralph/ralph_state.json**

3. **Commit if tests pass:**
   ```bash
   git add -A && git commit -m "feat(domain): description"
   ```

---

## ⚠️ ERROR RECOVERY

### If Tests Fail

1. Read the error message carefully
2. Check if it's a test issue or implementation issue
3. Fix the root cause, not the symptom
4. Re-run specific test: `mix test path/to/test.exs:LINE`

### If Compilation Fails

1. Check for missing dependencies: `mix deps.get`
2. Check for syntax errors in recent changes
3. Verify module names match file paths
4. Check for circular dependencies

### If Migration Fails

1. Check migration syntax
2. Verify database is running
3. Try: `mix ecto.rollback` then `mix ecto.migrate`
4. If stuck: `mix ecto.reset` (dev only!)

### If Claude API Fails

1. Check API key in environment
2. Check rate limits
3. Implement exponential backoff
4. Use mock in tests

---

## 🏁 COMPLETION CHECKLIST

Before outputting `<RALPHFORGE_COMPLETE>`, verify:

```bash
# All checks must pass
mix compile --warnings-as-errors  # ✅ No warnings
mix test                          # ✅ All tests pass
mix credo --strict                # ✅ No issues
mix dialyzer                      # ✅ No warnings

# Manual verification
# ✅ Can register new user
# ✅ Can log in
# ✅ Can create task (within limit)
# ✅ Real-time generation works
# ✅ Can view task history
# ✅ Can export as Markdown
# ✅ Can export as JSON
# ✅ Templates work
# ✅ Admin panel accessible
# ✅ Stripe checkout works
# ✅ Usage tracking works
```

---

## 🚀 LAUNCH COMMAND

To execute this task with Ralph:

```bash
# Navigate to parent directory
cd ~/projects

# Run Ralph loop
/ralph-loop "$(cat ralph_forge_task.md)" \
  --max-iterations 100 \
  --completion-promise "RALPHFORGE_COMPLETE"
```

---

## 📝 NOTES

- **Always write tests first** - TDD is non-negotiable
- **Keep commits small** - One logical change per commit
- **Use Ash idioms** - Don't fight the framework
- **Mock external services** - Claude API, Stripe in tests
- **Real-time is key** - LiveView updates during generation
- **Mobile-responsive** - TailwindCSS makes this easy

---

*Remember: "Me fail English? That's unpossible!" - But failing this task IS impossible if you iterate enough!* 🍕
