# 🏭 Ralph Task Generator System

> **Version:** 1.0  
> **Purpose:** Automatically transform any business idea into a production-ready Ralph Wiggum task  
> **Output:** Complete `.ralph/` setup + executable task prompt

---

## 📋 Table of Contents

1. [System Overview](#system-overview)
2. [The Generator Prompt](#the-generator-prompt)
3. [Tech Stack Decision Matrix](#tech-stack-decision-matrix)
4. [Feature Decomposition Framework](#feature-decomposition-framework)
5. [Task Templates by Project Type](#task-templates-by-project-type)
6. [Automated Setup Scripts](#automated-setup-scripts)
7. [Example Transformations](#example-transformations)
8. [Usage Instructions](#usage-instructions)

---

## 🎯 System Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                    RALPH TASK GENERATOR SYSTEM                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   INPUT                        PROCESS                    OUTPUT    │
│   ─────                        ───────                    ──────    │
│                                                                     │
│   "Build a SaaS      ──►   ┌──────────────┐    ──►   Complete       │
│    for X..."               │              │          Ralph Task     │
│                            │  1. Analyze  │          + Project      │
│   OR                       │  2. Decide   │            Setup        │
│                            │     Stack    │          + Tests        │
│   "I need an app     ──►   │  3. Break    │    ──►   + Config       │
│    that does Y..."         │     Down     │          + Ready to     │
│                            │  4. Generate │            Run!         │
│   OR                       │     Tasks    │                         │
│                            │  5. Create   │                         │
│   Any business       ──►   │     Files    │    ──►                  │
│   idea/prompt              │              │                         │
│                            └──────────────┘                         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### What This System Does

1. **Intake** — Accepts any business idea (vague or detailed)
2. **Analysis** — Extracts requirements, constraints, and goals
3. **Architecture** — Recommends optimal tech stack
4. **Decomposition** — Breaks idea into epics → features → tasks
5. **Generation** — Creates complete Ralph task prompt
6. **Setup** — Initializes project structure and config files
7. **Output** — Ready-to-execute Ralph loop command

---

## 🤖 The Generator Prompt

Copy this entire section and use it with Claude to transform any idea:

```markdown
# ROLE: Ralph Task Generator

You are a senior software architect and project planner. Your job is to transform a business idea into a complete, executable Ralph Wiggum task.

## YOUR PROCESS

### STEP 1: INTAKE & CLARIFICATION

First, gather information about the idea. If not provided, infer or ask:

**Required Information:**
- [ ] Core problem being solved
- [ ] Target users/audience
- [ ] Key features (MVP scope)
- [ ] Preferred tech stack (or should I recommend?)
- [ ] Deployment target (web, mobile, API, CLI)
- [ ] Timeline constraints
- [ ] Must-have vs nice-to-have features

### STEP 2: TECH STACK DECISION

Based on the requirements, recommend a stack:

**Decision Factors:**
| Factor | Weight | Options |
|--------|--------|---------|
| Team expertise | High | Use familiar tech |
| Time to market | High | Use productive frameworks |
| Scalability needs | Medium | Consider future growth |
| Budget | Medium | Open source vs paid |
| Deployment | Medium | Cloud, self-hosted, edge |

**Default Recommendations by Project Type:**

| Project Type | Primary Stack | Test Framework | Build Tool |
|--------------|---------------|----------------|------------|
| Web App (Full) | Next.js + TypeScript | Vitest + Playwright | npm/pnpm |
| Web App (Simple) | React + Vite | Vitest | npm |
| API Only | Node.js + Express/Fastify | Vitest | npm |
| API (Python) | FastAPI + SQLAlchemy | pytest | pip/poetry |
| API (Elixir) | Phoenix + Ecto | ExUnit | mix |
| Mobile (iOS) | SwiftUI + Swift | XCTest | Xcode |
| Mobile (Cross) | React Native | Jest + Detox | npm |
| CLI Tool | Node.js or Rust | Vitest or cargo test | npm/cargo |
| SaaS Platform | Next.js + Prisma + tRPC | Vitest | npm |

### STEP 3: FEATURE DECOMPOSITION

Break down into a hierarchy:

```
PRODUCT
└── Epic 1: [Major Feature Area]
    ├── Feature 1.1: [Specific Capability]
    │   ├── Task 1.1.1: [Atomic Work Item]
    │   ├── Task 1.1.2: [Atomic Work Item]
    │   └── Task 1.1.3: [Atomic Work Item]
    └── Feature 1.2: [Specific Capability]
        ├── Task 1.2.1: [Atomic Work Item]
        └── Task 1.2.2: [Atomic Work Item]
└── Epic 2: [Major Feature Area]
    └── ...
```

**Rules for Tasks:**
- Each task should be completable in 1-5 Ralph iterations
- Each task must have clear, testable success criteria
- Tasks should be independent when possible
- Order tasks by dependency (do dependencies first)

### STEP 4: GENERATE RALPH TASK

Create the complete Ralph prompt with:
1. Clear objective
2. Specific success criteria (testable!)
3. Correct verification command
4. Tech stack context
5. File structure hints
6. The full iteration protocol

### STEP 5: GENERATE SETUP FILES

Create all necessary files:
1. `ralph_task.md` — The main prompt
2. `ralph_plan.md` — Full feature breakdown
3. `ralph_state.json` — Initial state
4. `setup.sh` — Project initialization script
5. `CLAUDE.md` — Claude Code context file

---

## OUTPUT FORMAT

When given a business idea, output:

### 1. Analysis Summary
Brief summary of what you understood.

### 2. Recommended Tech Stack
Table of chosen technologies with reasoning.

### 3. Feature Breakdown
Hierarchical list of epics → features → tasks.

### 4. The Ralph Task Prompt
Complete, ready-to-use prompt (in code block).

### 5. Setup Script
Bash script to initialize everything.

### 6. Launch Command
The exact command to start the Ralph loop.

---

## EXAMPLE INPUT → OUTPUT

**Input:**
"I want to build a habit tracking app for iOS"

**Output:**

### 1. Analysis Summary
Mobile app for iOS that helps users track daily habits, view streaks, and stay motivated through gamification.

### 2. Recommended Tech Stack
| Component | Choice | Reason |
|-----------|--------|--------|
| Language | Swift 5.9 | Native iOS, best performance |
| UI Framework | SwiftUI | Modern, declarative, fast dev |
| Data | SwiftData | Native persistence, simple |
| Testing | XCTest + ViewInspector | Standard + SwiftUI testing |
| Architecture | MVVM | Clean separation, testable |

### 3. Feature Breakdown
[Full hierarchical breakdown...]

### 4. The Ralph Task Prompt
[Complete prompt...]

### 5. Setup Script
[Bash script...]

### 6. Launch Command
```bash
/ralph-loop "$(cat .claude/prompts/ralph_task.md)" --max-iterations 50 --completion-promise "RALPH_TASK_COMPLETE"
```
```

---

## 🔧 Tech Stack Decision Matrix

Use this matrix to determine the optimal stack:

### Web Applications

```
                    ┌─────────────────────────────────────────┐
                    │         COMPLEXITY / SCALE              │
                    ├───────────┬───────────┬─────────────────┤
                    │   Low     │  Medium   │     High        │
┌───────────────────┼───────────┼───────────┼─────────────────┤
│ Speed to Market   │           │           │                 │
│   Fast            │ Next.js   │ Next.js   │ Next.js +       │
│                   │ (App Dir) │ + Prisma  │ microservices   │
├───────────────────┼───────────┼───────────┼─────────────────┤
│   Medium          │ React +   │ Remix     │ Custom React +  │
│                   │ Vite      │           │ tRPC            │
├───────────────────┼───────────┼───────────┼─────────────────┤
│   Slow OK         │ Vanilla   │ SvelteKit │ Elixir Phoenix  │
│   (max perf)      │ + HTMX    │           │ LiveView        │
└───────────────────┴───────────┴───────────┴─────────────────┘
```

### APIs / Backends

```
┌─────────────────┬──────────────────────────────────────────────────┐
│ Requirement     │ Recommended Stack                                │
├─────────────────┼──────────────────────────────────────────────────┤
│ Fast & Simple   │ FastAPI (Python) or Express (Node)               │
│ Type Safety     │ tRPC + Node or Rust Axum                         │
│ Real-time       │ Elixir Phoenix or Node + Socket.io               │
│ High Throughput │ Go Fiber or Rust Actix                           │
│ AI/ML Heavy     │ Python FastAPI + async                           │
│ Enterprise      │ NestJS (Node) or Spring Boot (Java)              │
└─────────────────┴──────────────────────────────────────────────────┘
```

### Mobile Applications

```
┌─────────────────┬──────────────────────────────────────────────────┐
│ Target          │ Recommended Stack                                │
├─────────────────┼──────────────────────────────────────────────────┤
│ iOS Only        │ SwiftUI + Swift + SwiftData                      │
│ Android Only    │ Jetpack Compose + Kotlin                         │
│ Both (shared)   │ React Native or Flutter                          │
│ Both (native)   │ SwiftUI + Compose (separate codebases)           │
│ Simple/MVP      │ React Native + Expo                              │
└─────────────────┴──────────────────────────────────────────────────┘
```

---

## 🧩 Feature Decomposition Framework

### The INVEST Criteria for Tasks

Each task should be:

| Letter | Meaning | Question to Ask |
|--------|---------|-----------------|
| **I** | Independent | Can it be done without other tasks? |
| **N** | Negotiable | Is scope flexible within the task? |
| **V** | Valuable | Does it deliver user/business value? |
| **E** | Estimable | Can we guess iterations needed? |
| **S** | Small | Completable in 1-5 Ralph iterations? |
| **T** | Testable | Clear pass/fail criteria? |

### Decomposition Template

```markdown
## Epic: [Name]
**Goal:** [What this epic achieves]
**User Value:** [Why users care]

### Feature: [Name]
**Goal:** [Specific capability]
**Acceptance Criteria:**
- [ ] [Criterion 1]
- [ ] [Criterion 2]

#### Tasks:
1. **[Task Name]** (Est: X iterations)
   - Success: [How to verify]
   - Test: [What test to write]
   
2. **[Task Name]** (Est: X iterations)
   - Success: [How to verify]
   - Test: [What test to write]
```

### Common Epic Patterns

**For SaaS Applications:**
```
1. Epic: Authentication & Users
2. Epic: Core Feature (the main thing)
3. Epic: Billing & Subscriptions
4. Epic: Admin Dashboard
5. Epic: Notifications
6. Epic: Analytics & Reporting
```

**For Mobile Apps:**
```
1. Epic: Onboarding & Auth
2. Epic: Core Feature
3. Epic: Data Persistence
4. Epic: Settings & Preferences
5. Epic: Notifications
6. Epic: Sync & Backup
```

**For APIs:**
```
1. Epic: Auth & Authorization
2. Epic: Core Resources (CRUD)
3. Epic: Business Logic
4. Epic: Integrations
5. Epic: Rate Limiting & Security
6. Epic: Documentation
```

---

## 📄 Task Templates by Project Type

### Template 1: SaaS Web Application

```markdown
# ROLE: Autonomous Iteration Agent ("Ralph")

You are building a SaaS application. Follow TDD strictly.

## 🎯 THE TASK

**PRIMARY OBJECTIVE:**
Build [PRODUCT NAME]: [ONE SENTENCE DESCRIPTION]

**Target Users:** [WHO]
**Core Value Prop:** [WHY THEY'D PAY]

**Success Criteria:**
- [ ] User can sign up and log in
- [ ] User can [CORE ACTION 1]
- [ ] User can [CORE ACTION 2]
- [ ] Stripe integration for payments
- [ ] All tests pass (>80% coverage)
- [ ] No TypeScript errors
- [ ] Deployed to Vercel/Railway

**Verification Command:**
```bash
npm run test && npm run lint && npm run typecheck && npm run build
```

**Tech Stack:**
- Framework: Next.js 14 (App Router)
- Language: TypeScript (strict)
- Database: PostgreSQL + Prisma
- Auth: NextAuth.js or Clerk
- Payments: Stripe
- Styling: TailwindCSS
- Testing: Vitest + Playwright

**Project Structure:**
```
src/
├── app/                 # Next.js App Router
│   ├── (auth)/          # Auth routes
│   ├── (dashboard)/     # Protected routes
│   └── api/             # API routes
├── components/          # React components
├── lib/                 # Utilities
├── server/              # Server-side code
│   ├── db/              # Database
│   └── services/        # Business logic
└── tests/               # Test files
```

**Completion Token:**
<RALPH_TASK_COMPLETE>

## 🔁 ITERATION PROTOCOL
[Include full protocol from base template]
```

---

### Template 2: iOS Mobile Application

```markdown
# ROLE: Autonomous Iteration Agent ("Ralph")

You are building an iOS application. Follow TDD strictly.

## 🎯 THE TASK

**PRIMARY OBJECTIVE:**
Build [APP NAME]: [ONE SENTENCE DESCRIPTION]

**Target Users:** [WHO]
**App Store Category:** [CATEGORY]

**Success Criteria:**
- [ ] App launches without crash
- [ ] User can [CORE ACTION 1]
- [ ] User can [CORE ACTION 2]
- [ ] Data persists between launches
- [ ] All tests pass
- [ ] No SwiftLint warnings
- [ ] Builds for release

**Verification Command:**
```bash
xcodebuild test -scheme [SCHEME] -destination 'platform=iOS Simulator,name=iPhone 15' && swiftlint
```

**Tech Stack:**
- Language: Swift 5.9
- UI: SwiftUI
- Architecture: MVVM
- Data: SwiftData
- Testing: XCTest + ViewInspector
- Linting: SwiftLint

**Project Structure:**
```
[AppName]/
├── App/
│   └── [AppName]App.swift
├── Features/
│   ├── [Feature1]/
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   └── Models/
│   └── [Feature2]/
├── Core/
│   ├── Services/
│   ├── Extensions/
│   └── Utilities/
└── Tests/
    ├── UnitTests/
    └── UITests/
```

**Completion Token:**
<RALPH_TASK_COMPLETE>

## 🔁 ITERATION PROTOCOL
[Include full protocol from base template]
```

---

### Template 3: REST API

```markdown
# ROLE: Autonomous Iteration Agent ("Ralph")

You are building a REST API. Follow TDD strictly.

## 🎯 THE TASK

**PRIMARY OBJECTIVE:**
Build [API NAME]: [ONE SENTENCE DESCRIPTION]

**Consumers:** [WHO WILL USE THIS API]

**Success Criteria:**
- [ ] All CRUD endpoints for [RESOURCE 1]
- [ ] All CRUD endpoints for [RESOURCE 2]
- [ ] Authentication (JWT)
- [ ] Input validation on all endpoints
- [ ] Error handling with proper status codes
- [ ] All tests pass (>90% coverage)
- [ ] OpenAPI documentation generated
- [ ] No linter errors

**Verification Command:**
```bash
npm run test -- --coverage && npm run lint && npm run build
```

**Tech Stack:**
- Runtime: Node.js 20
- Framework: Fastify (or Express)
- Language: TypeScript
- Database: PostgreSQL + Prisma
- Validation: Zod
- Testing: Vitest + Supertest
- Docs: Swagger/OpenAPI

**Project Structure:**
```
src/
├── routes/              # Route handlers
├── controllers/         # Request handlers
├── services/            # Business logic
├── repositories/        # Data access
├── schemas/             # Zod schemas
├── middleware/          # Auth, validation, etc.
├── utils/               # Helpers
└── tests/
    ├── unit/
    └── integration/
```

**Completion Token:**
<RALPH_TASK_COMPLETE>

## 🔁 ITERATION PROTOCOL
[Include full protocol from base template]
```

---

### Template 4: Elixir/Phoenix Application

```markdown
# ROLE: Autonomous Iteration Agent ("Ralph")

You are building an Elixir/Phoenix application. Follow TDD strictly.

## 🎯 THE TASK

**PRIMARY OBJECTIVE:**
Build [APP NAME]: [ONE SENTENCE DESCRIPTION]

**Success Criteria:**
- [ ] [FEATURE 1] working with tests
- [ ] [FEATURE 2] working with tests
- [ ] LiveView for real-time UI
- [ ] All tests pass
- [ ] No Credo warnings
- [ ] Dialyzer passes

**Verification Command:**
```bash
mix test && mix credo --strict && mix dialyzer
```

**Tech Stack:**
- Language: Elixir 1.16
- Framework: Phoenix 1.7+
- Database: PostgreSQL + Ecto
- Real-time: LiveView
- Testing: ExUnit
- Linting: Credo + Dialyzer

**Project Structure:**
```
lib/
├── [app_name]/          # Domain logic
│   ├── [context1]/      # Bounded context
│   └── [context2]/      # Bounded context
├── [app_name]_web/      # Web layer
│   ├── controllers/
│   ├── live/            # LiveView
│   └── components/
test/
├── [app_name]/          # Domain tests
└── [app_name]_web/      # Web tests
```

**Completion Token:**
<RALPH_TASK_COMPLETE>

## 🔁 ITERATION PROTOCOL
[Include full protocol from base template]
```

---

## 🔧 Automated Setup Scripts

### Universal Setup Script

Save as `setup_ralph_project.sh`:

```bash
#!/bin/bash

# ============================================
# Ralph Task Generator - Project Setup Script
# ============================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🏭 Ralph Task Generator - Project Setup${NC}"
echo "=========================================="

# Get project info
read -p "Project name: " PROJECT_NAME
read -p "Project type (saas/api/ios/elixir/cli): " PROJECT_TYPE
read -p "Brief description: " DESCRIPTION

# Create directory structure
echo -e "\n${YELLOW}📁 Creating directory structure...${NC}"

mkdir -p .ralph
mkdir -p .claude/prompts

# Initialize ralph_state.json
echo -e "${YELLOW}📝 Initializing ralph_state.json...${NC}"

cat > .ralph/ralph_state.json << EOF
{
  "iteration": 0,
  "phase": "bootstrap",
  "current_objective": "Initialize project and create plan",
  "blockers": [],
  "last_error": null,
  "attempts_on_current_blocker": 0,
  "tests_passing": false,
  "subtasks_completed": [],
  "subtasks_remaining": [],
  "started_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "last_updated": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF

# Initialize ralph_log.md
echo -e "${YELLOW}📝 Initializing ralph_log.md...${NC}"

cat > .ralph/ralph_log.md << EOF
# Ralph Iteration Log

**Project:** ${PROJECT_NAME}
**Started:** $(date)
**Type:** ${PROJECT_TYPE}

---

## Iteration 0: Bootstrap
**Timestamp:** $(date -u +"%Y-%m-%dT%H:%M:%SZ")
**Phase:** bootstrap
**Action:** Initialized Ralph system
**Result:** Ready for first iteration
**Next:** Create project plan and first task

---
EOF

# Initialize ralph_errors.md
cat > .ralph/ralph_errors.md << EOF
# Ralph Error Log

**Project:** ${PROJECT_NAME}

---

*No errors yet. This file tracks error patterns and solutions.*

---
EOF

# Initialize ralph_plan.md
cat > .ralph/ralph_plan.md << EOF
# Project Plan: ${PROJECT_NAME}

**Description:** ${DESCRIPTION}
**Type:** ${PROJECT_TYPE}
**Created:** $(date)

---

## Epics & Features

*To be filled by Ralph on first iteration*

---

## Task Breakdown

*To be generated based on analysis*

---
EOF

# Create CLAUDE.md for context
echo -e "${YELLOW}📝 Creating CLAUDE.md...${NC}"

cat > CLAUDE.md << EOF
# ${PROJECT_NAME}

${DESCRIPTION}

## Project Type
${PROJECT_TYPE}

## Tech Stack
*To be determined*

## Architecture Decisions
- Follow TDD (Red → Green → Refactor)
- Use DDD principles for domain logic
- Maintain >80% test coverage
- Atomic commits with conventional messages

## File Structure
*To be created*

## Running Tests
*To be configured*

## Ralph Configuration
- State: \`.ralph/ralph_state.json\`
- Log: \`.ralph/ralph_log.md\`
- Plan: \`.ralph/ralph_plan.md\`
- Errors: \`.ralph/ralph_errors.md\`

## Commands
\`\`\`bash
# Start Ralph loop
/ralph-loop "\$(cat .claude/prompts/ralph_task.md)" --max-iterations 50 --completion-promise "RALPH_TASK_COMPLETE"

# Cancel Ralph
/cancel-ralph

# Watch progress
tail -f .ralph/ralph_log.md
\`\`\`
EOF

# Create placeholder task prompt
echo -e "${YELLOW}📝 Creating task prompt placeholder...${NC}"

cat > .claude/prompts/ralph_task.md << EOF
# ROLE: Autonomous Iteration Agent ("Ralph")

You are an autonomous, self-correcting coding agent.

## 🎯 THE TASK

**PRIMARY OBJECTIVE:**
${DESCRIPTION}

**Success Criteria:**
- [ ] TODO: Define specific criteria
- [ ] TODO: Define specific criteria
- [ ] All tests pass
- [ ] No linter errors

**Verification Command:**
\`\`\`bash
# TODO: Add your test command
echo "Configure test command"
\`\`\`

**Tech Stack:**
- TODO: Define tech stack

**Completion Token:**
<RALPH_TASK_COMPLETE>

## 🔁 ITERATION PROTOCOL

### PHASE 0: BOOTSTRAP (First Run Only)
IF \`.ralph/\` state is empty:
1. Analyze THE TASK
2. Break into subtasks → write to ralph_plan.md
3. Initialize ralph_state.json with subtasks
4. Set up project structure
5. Commit: \`ralph: initialize project\`

### PHASE 1: ORIENTATION (Every Loop)
1. \`cat .ralph/ralph_state.json\`
2. \`git log -1 --oneline\`
3. Review what was attempted and results

### PHASE 2: VERIFICATION
Run verification command.
- PASS + criteria met → Output completion token
- PASS + more work → Next subtask
- FAIL → Parse error, continue to Phase 3

### PHASE 3: RED (Write Failing Test)
1. Write test for next requirement
2. Confirm test fails
3. Commit: \`test: <description>\`

### PHASE 4: GREEN (Make It Pass)
1. Minimal code to pass test
2. Run tests
3. Commit: \`feat: <description>\`

### PHASE 5: REFACTOR
1. Clean up (tests must stay green)
2. Commit: \`refactor: <description>\`

### PHASE 6: LOG & EXIT
1. Update ralph_state.json
2. Append to ralph_log.md
3. Exit (loop continues)

---

Output \`<RALPH_TASK_COMPLETE>\` only when ALL criteria verified.
EOF

# Initialize git if needed
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}📝 Initializing git repository...${NC}"
    git init
fi

# Add .ralph to gitignore (optional - some prefer to track it)
if [ -f ".gitignore" ]; then
    if ! grep -q ".ralph/" .gitignore; then
        echo -e "\n# Ralph state (optional: remove to track progress)\n# .ralph/" >> .gitignore
    fi
fi

# Summary
echo -e "\n${GREEN}✅ Ralph project setup complete!${NC}"
echo ""
echo "Created files:"
echo "  📄 .ralph/ralph_state.json"
echo "  📄 .ralph/ralph_log.md"
echo "  📄 .ralph/ralph_errors.md"
echo "  📄 .ralph/ralph_plan.md"
echo "  📄 .claude/prompts/ralph_task.md"
echo "  📄 CLAUDE.md"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Edit .claude/prompts/ralph_task.md with your specific task"
echo "  2. Configure your verification command"
echo "  3. Run: claude"
echo "  4. Execute: /ralph-loop \"\$(cat .claude/prompts/ralph_task.md)\" --max-iterations 30 --completion-promise \"RALPH_TASK_COMPLETE\""
echo ""
echo -e "${BLUE}Happy iterating! 🍕${NC}"
```

### Make it executable:

```bash
chmod +x setup_ralph_project.sh
./setup_ralph_project.sh
```

---

## 📝 Example Transformations

### Example 1: Vague Idea → Complete Task

**INPUT:**
> "I want to build something that helps people track their reading habits"

**TRANSFORMED OUTPUT:**

#### Analysis Summary
A reading tracker application that helps users log books, track reading progress, set goals, and visualize their reading habits over time.

#### Recommended Tech Stack
| Component | Choice | Reason |
|-----------|--------|--------|
| Platform | Web (PWA) | Accessible everywhere, offline support |
| Framework | Next.js 14 | Fast dev, great DX, easy deployment |
| Database | PostgreSQL + Prisma | Reliable, good for relational data |
| Auth | Clerk | Quick setup, good free tier |
| Styling | TailwindCSS | Rapid UI development |
| Testing | Vitest + Playwright | Unit + E2E coverage |

#### Feature Breakdown
```
Epic 1: Authentication
├── Feature: User Registration
│   ├── Task: Set up Clerk integration
│   └── Task: Create auth middleware
└── Feature: User Profile
    └── Task: Profile page with reading stats

Epic 2: Book Management
├── Feature: Add Books
│   ├── Task: Book search API (Google Books)
│   ├── Task: Manual book entry form
│   └── Task: Book details page
├── Feature: Reading List
│   ├── Task: Currently reading section
│   ├── Task: Want to read section
│   └── Task: Finished books section
└── Feature: Reading Progress
    ├── Task: Progress tracking UI
    └── Task: Progress update API

Epic 3: Goals & Stats
├── Feature: Reading Goals
│   ├── Task: Annual book goal
│   └── Task: Daily reading time goal
└── Feature: Statistics Dashboard
    ├── Task: Books read chart
    └── Task: Reading streak tracker
```

#### The Ralph Task Prompt

```markdown
# ROLE: Autonomous Iteration Agent ("Ralph")

## 🎯 THE TASK

**PRIMARY OBJECTIVE:**
Build "ReadTrack" - A web application for tracking reading habits with book logging, progress tracking, and goal setting.

**Success Criteria:**
- [ ] User can sign up and log in (Clerk)
- [ ] User can search and add books (Google Books API)
- [ ] User can track reading progress (pages/percentage)
- [ ] User can set and track annual reading goal
- [ ] User can view reading statistics dashboard
- [ ] All tests pass (>80% coverage)
- [ ] No TypeScript errors
- [ ] Lighthouse score >90

**Verification Command:**
```bash
npm run test && npm run lint && npm run typecheck && npm run build
```

**Tech Stack:**
- Framework: Next.js 14 (App Router)
- Language: TypeScript (strict)
- Database: PostgreSQL + Prisma
- Auth: Clerk
- Styling: TailwindCSS + shadcn/ui
- Testing: Vitest + Playwright
- API: Google Books API

**Completion Token:**
<RALPH_TASK_COMPLETE>
```

---

### Example 2: Specific Idea → Complete Task

**INPUT:**
> "Build a Stripe billing webhook handler for my SaaS that handles subscription created, updated, and cancelled events"

**TRANSFORMED OUTPUT:**

```markdown
# ROLE: Autonomous Iteration Agent ("Ralph")

## 🎯 THE TASK

**PRIMARY OBJECTIVE:**
Implement Stripe webhook handler for subscription lifecycle events (created, updated, cancelled) with proper signature verification and database synchronization.

**Success Criteria:**
- [ ] Webhook endpoint at /api/webhooks/stripe
- [ ] Signature verification using Stripe SDK
- [ ] Handle `customer.subscription.created` event
- [ ] Handle `customer.subscription.updated` event
- [ ] Handle `customer.subscription.deleted` event
- [ ] Update user subscription status in database
- [ ] Idempotency handling (no duplicate processing)
- [ ] Error handling with proper logging
- [ ] All tests pass (including webhook simulation)
- [ ] No TypeScript errors

**Verification Command:**
```bash
npm run test -- --coverage && npm run lint && npm run typecheck
```

**Tech Stack:**
- Runtime: Node.js 20
- Framework: Next.js 14 API Routes
- Language: TypeScript
- Database: Prisma
- Payment: Stripe SDK
- Testing: Vitest + MSW (mock Stripe)

**Key Files:**
- `src/app/api/webhooks/stripe/route.ts` - Webhook handler
- `src/lib/stripe.ts` - Stripe client config
- `src/services/subscription.ts` - Subscription service
- `tests/webhooks/stripe.test.ts` - Webhook tests

**Completion Token:**
<RALPH_TASK_COMPLETE>

## 🔁 ITERATION PROTOCOL
[Standard protocol...]
```

---

## 🚀 Usage Instructions

### Method 1: Manual Generation

1. Copy the Generator Prompt section
2. Open Claude (web or Code)
3. Paste the prompt
4. Add your business idea at the end
5. Claude generates complete Ralph task
6. Copy output to your project

### Method 2: Automated Script

```bash
# 1. Run setup script
./setup_ralph_project.sh

# 2. Edit generated task file
vim .claude/prompts/ralph_task.md

# 3. Start Claude Code
claude

# 4. Run Ralph
/ralph-loop "$(cat .claude/prompts/ralph_task.md)" --max-iterations 50 --completion-promise "RALPH_TASK_COMPLETE"
```

### Method 3: One-Shot Generation

Use this prompt directly in Claude:

```
Transform this business idea into a complete Ralph Wiggum task:

"[YOUR IDEA HERE]"

Output:
1. Tech stack recommendation
2. Feature breakdown
3. Complete Ralph task prompt (ready to copy)
4. Setup commands
```

---

## 🎯 Quick Start Checklist

```
□ Have a business idea
□ Run setup script (or create files manually)
□ Edit ralph_task.md with your specific task
□ Ensure project has working test command
□ Initialize git repo
□ Install ralph-wiggum plugin
□ Run /ralph-loop command
□ Monitor with tail -f .ralph/ralph_log.md
□ Wake up to working code! 🍕
```

---

## 📚 Additional Resources

- [Ralph Wiggum Plugin](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum)
- [Original Blog Post](https://ghuntley.com/ralph/)
- [AwesomeClaude](https://awesomeclaude.ai/ralph-wiggum)

---

*Generated by Ralph Task Generator System v1.0*
