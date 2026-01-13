#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
# 🔥 RalphForge Setup Script
# ═══════════════════════════════════════════════════════════════════════════════
# This script bootstraps the RalphForge project with all dependencies and
# initializes the Ralph state directory for iterative development.
# ═══════════════════════════════════════════════════════════════════════════════

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "═══════════════════════════════════════════════════════════════════════════════"
echo "  🔥 RalphForge Setup"
echo "  Building the SaaS that builds SaaS"
echo "═══════════════════════════════════════════════════════════════════════════════"
echo -e "${NC}"

# ─────────────────────────────────────────────────────────────────────────────────
# Step 1: Check Prerequisites
# ─────────────────────────────────────────────────────────────────────────────────
echo -e "${YELLOW}[1/7] Checking prerequisites...${NC}"

# Check Elixir
if ! command -v elixir &> /dev/null; then
    echo -e "${RED}Error: Elixir is not installed.${NC}"
    echo "Install via: brew install elixir (macOS) or see https://elixir-lang.org/install.html"
    exit 1
fi

# Check Phoenix
if ! mix phx.new --version &> /dev/null; then
    echo -e "${YELLOW}Installing Phoenix...${NC}"
    mix archive.install hex phx_new --force
fi

# Check PostgreSQL
if ! command -v psql &> /dev/null; then
    echo -e "${RED}Warning: PostgreSQL CLI not found. Make sure PostgreSQL is running.${NC}"
fi

echo -e "${GREEN}✓ Prerequisites OK${NC}"

# ─────────────────────────────────────────────────────────────────────────────────
# Step 2: Create Phoenix Project
# ─────────────────────────────────────────────────────────────────────────────────
echo -e "${YELLOW}[2/7] Creating Phoenix project...${NC}"

PROJECT_NAME="ralph_forge"

if [ -d "$PROJECT_NAME" ]; then
    echo -e "${YELLOW}Directory $PROJECT_NAME already exists. Skipping creation.${NC}"
    cd "$PROJECT_NAME"
else
    mix phx.new "$PROJECT_NAME" --live --no-dashboard --no-mailer
    cd "$PROJECT_NAME"
fi

echo -e "${GREEN}✓ Phoenix project created${NC}"

# ─────────────────────────────────────────────────────────────────────────────────
# Step 3: Update mix.exs with Ash dependencies
# ─────────────────────────────────────────────────────────────────────────────────
echo -e "${YELLOW}[3/7] Updating dependencies...${NC}"

# Create a backup of mix.exs
cp mix.exs mix.exs.bak

# Replace deps function in mix.exs
cat > mix_deps.tmp << 'DEPS_EOF'
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
      
      # Assets
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      
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
      {:dns_cluster, "~> 0.1.3"},
      {:bandit, "~> 1.5"}
    ]
  end
DEPS_EOF

echo -e "${GREEN}✓ Dependencies configured (update mix.exs manually with the output)${NC}"

# ─────────────────────────────────────────────────────────────────────────────────
# Step 4: Create .ralph directory
# ─────────────────────────────────────────────────────────────────────────────────
echo -e "${YELLOW}[4/7] Creating Ralph state directory...${NC}"

mkdir -p .ralph

# Create ralph_state.json
cat > .ralph/ralph_state.json << 'STATE_EOF'
{
  "project": "ralph_forge",
  "version": "0.1.0",
  "current_phase": "bootstrap",
  "current_iteration": 0,
  "status": "initialized",
  "phases": {
    "bootstrap": { "status": "in_progress", "iterations": 0 },
    "accounts": { "status": "pending", "iterations": 0 },
    "tasks": { "status": "pending", "iterations": 0 },
    "templates": { "status": "pending", "iterations": 0 },
    "billing": { "status": "pending", "iterations": 0 },
    "admin": { "status": "pending", "iterations": 0 },
    "testing": { "status": "pending", "iterations": 0 },
    "deployment": { "status": "pending", "iterations": 0 }
  },
  "tests": {
    "total": 0,
    "passing": 0,
    "failing": 0
  },
  "last_updated": null
}
STATE_EOF

# Create ralph_log.md
cat > .ralph/ralph_log.md << 'LOG_EOF'
# 🔥 RalphForge Development Log

## Project: RalphForge SaaS
## Started: $(date -Iseconds)
## Tech Stack: Elixir, Phoenix, Ash, LiveView, PostgreSQL, TailwindCSS

---

## Iteration Log

### Iteration 0 - Bootstrap
**Timestamp:** $(date -Iseconds)
**Phase:** Bootstrap
**Focus:** Project initialization
**Outcome:** Project scaffolded with Phoenix
**Next:** Add Ash dependencies and configure

---

LOG_EOF

# Create ralph_plan.md
cat > .ralph/ralph_plan.md << 'PLAN_EOF'
# 🎯 RalphForge Implementation Plan

## Phase 1: Bootstrap (Iterations 1-5)
- [x] Create Phoenix project
- [ ] Add Ash dependencies
- [ ] Configure Ash domains
- [ ] Set up database
- [ ] Create initial migrations

## Phase 2: Accounts Domain (Iterations 6-15)
- [ ] Create User resource with AshAuthentication
- [ ] Create Token resource
- [ ] Set up password authentication
- [ ] Create registration LiveView
- [ ] Create login LiveView
- [ ] Write account tests

## Phase 3: Tasks Domain (Iterations 16-30)
- [ ] Create Task resource
- [ ] Create Generation resource
- [ ] Implement Claude API integration
- [ ] Create Oban worker for generation
- [ ] Create TaskLive.Index
- [ ] Create TaskLive.New (with real-time updates)
- [ ] Create TaskLive.Show
- [ ] Add export functionality
- [ ] Write task tests

## Phase 4: Templates Domain (Iterations 31-40)
- [ ] Create Template resource
- [ ] Seed default templates
- [ ] Add template selection to task creation
- [ ] Write template tests

## Phase 5: Billing Domain (Iterations 41-55)
- [ ] Create Plan resource
- [ ] Create Subscription resource with state machine
- [ ] Create UsageEvent resource
- [ ] Implement Stripe Checkout
- [ ] Implement Stripe webhooks
- [ ] Enforce usage limits
- [ ] Create pricing page
- [ ] Write billing tests

## Phase 6: Admin & Polish (Iterations 56-70)
- [ ] Configure Ash Admin
- [ ] Add admin role
- [ ] Create dashboard
- [ ] Add UI polish
- [ ] Add toast notifications
- [ ] Mobile responsiveness

## Phase 7: Testing & Quality (Iterations 71-80)
- [ ] Achieve >80% test coverage
- [ ] Fix all Credo warnings
- [ ] Fix all Dialyzer warnings
- [ ] Integration tests

## Phase 8: Deployment (Iterations 81-90)
- [ ] Create fly.toml
- [ ] Configure runtime.exs
- [ ] Create release config
- [ ] Health check endpoint
- [ ] Final verification

PLAN_EOF

echo -e "${GREEN}✓ Ralph state directory created${NC}"

# ─────────────────────────────────────────────────────────────────────────────────
# Step 5: Create CLAUDE.md
# ─────────────────────────────────────────────────────────────────────────────────
echo -e "${YELLOW}[5/7] Creating CLAUDE.md...${NC}"

cat > CLAUDE.md << 'CLAUDE_EOF'
# RalphForge - Claude Code Context

## Project Overview

RalphForge is a SaaS platform that transforms business ideas into executable Ralph Wiggum tasks for AI-assisted development.

## Tech Stack

- **Language:** Elixir 1.16+
- **Framework:** Phoenix 1.7+ with LiveView
- **Data Layer:** Ash Framework 3.0 + AshPostgres
- **Auth:** AshAuthentication + AshAuthenticationPhoenix
- **Background Jobs:** Oban
- **Payments:** Stripity Stripe
- **Styling:** TailwindCSS
- **Database:** PostgreSQL

## Architecture

### Domains (DDD)

1. **Accounts** - User management, authentication
2. **Tasks** - Task generation, history
3. **Templates** - Pre-built templates
4. **Billing** - Subscriptions, usage tracking

### Key Patterns

- Ash Resources for data modeling
- Ash Policies for authorization
- Oban Workers for background processing
- LiveView for real-time UI
- TDD methodology throughout

## Commands

```bash
# Development
mix phx.server          # Start server
mix test                # Run tests
mix credo --strict      # Lint
mix dialyzer            # Type checking

# Database
mix ecto.migrate        # Run migrations
mix ecto.rollback       # Rollback
mix ash.codegen         # Generate Ash code

# Ash specific
mix ash.generate.resource <Domain> <Resource>
```

## Environment Variables

- `DATABASE_URL` - PostgreSQL connection
- `SECRET_KEY_BASE` - Phoenix secret
- `ANTHROPIC_API_KEY` - Claude API
- `STRIPE_API_KEY` - Stripe secret key
- `STRIPE_WEBHOOK_SECRET` - Stripe webhook secret

## Ralph State

Check `.ralph/` directory for:
- `ralph_state.json` - Current iteration state
- `ralph_log.md` - Development history
- `ralph_plan.md` - Implementation plan

## Testing

Follow TDD strictly:
1. Write failing test
2. Implement minimum code to pass
3. Refactor

Target: >80% coverage
CLAUDE_EOF

echo -e "${GREEN}✓ CLAUDE.md created${NC}"

# ─────────────────────────────────────────────────────────────────────────────────
# Step 6: Create .env.example
# ─────────────────────────────────────────────────────────────────────────────────
echo -e "${YELLOW}[6/7] Creating environment template...${NC}"

cat > .env.example << 'ENV_EOF'
# Database
DATABASE_URL=postgres://postgres:postgres@localhost/ralph_forge_dev

# Phoenix
SECRET_KEY_BASE=generate_with_mix_phx_gen_secret
PHX_HOST=localhost
PORT=4000

# Stripe
STRIPE_API_KEY=sk_test_your_key_here
STRIPE_WEBHOOK_SECRET=whsec_your_secret_here
STRIPE_PRICE_STARTER=price_starter_id
STRIPE_PRICE_PRO=price_pro_id
STRIPE_PRICE_TEAM=price_team_id

# Claude API
ANTHROPIC_API_KEY=sk-ant-your_key_here
ENV_EOF

# Add to .gitignore
cat >> .gitignore << 'GIT_EOF'

# Environment
.env
.env.local

# Ralph state (optional - keep if you want history)
# .ralph/
GIT_EOF

echo -e "${GREEN}✓ Environment template created${NC}"

# ─────────────────────────────────────────────────────────────────────────────────
# Step 7: Final Instructions
# ─────────────────────────────────────────────────────────────────────────────────
echo -e "${YELLOW}[7/7] Setup complete!${NC}"

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✅ RalphForge project initialized!${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo ""
echo "  1. Update mix.exs with Ash dependencies (see mix_deps.tmp)"
echo ""
echo "  2. Install dependencies:"
echo "     ${BLUE}mix deps.get${NC}"
echo ""
echo "  3. Create database:"
echo "     ${BLUE}mix ecto.create${NC}"
echo ""
echo "  4. Copy .env.example to .env and fill in your keys:"
echo "     ${BLUE}cp .env.example .env${NC}"
echo ""
echo "  5. Start developing with Ralph:"
echo "     ${BLUE}/ralph-loop \"\$(cat ralph_forge_task.md)\" --max-iterations 100 --completion-promise \"RALPHFORGE_COMPLETE\"${NC}"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Happy shipping! 🚀${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════════${NC}"
