# PRD.md — Ralph Runner (No-Hassle AI Dev Runner)

## 1. Summary
Ralph Runner is a web app that lets non-technical users safely “ship code” by connecting a GitHub repo and running an automated, iterative AI workflow (“Ralph Loop”) that produces Pull Requests instead of modifying `main`. The app acts as a **control plane** (planning, task selection, safety policies, run history, approvals) while **GitHub Actions** executes the loop in the repo to create PRs.

**Core promise (for average users):**
Connect GitHub → Pick repo → Generate Plan → Build Next → PR appears → Merge (or Undo)

## 2. Goals
- Make AI-assisted development usable for non-technical users with **minimal friction**.
- Default to **safe, reversible** operations:
  - PR-only mode
  - approvals for high-risk work
  - locked folders
  - budgets and run limits
  - one-click revert PR
- Support polyglot repos via module detection (Swift/Rust/Python/Go/JS) and contract fan-out.
- Standardize work as **small, deterministic iterations** (Ralph Loop) with file-based memory.

## 3. Non-Goals (v1)
- No direct editing on `main` (always PR).
- No self-hosted runner orchestration in v1 (use GitHub Actions).
- No full IDE replacement (this is workflow + PR generation, not code editing).
- No “automerge without review” (optional later for low-risk tasks).

## 4. Target Users & Personas
### Persona A: Non-technical Founder / PM
- Wants features shipped without learning dev tooling.
- Needs confidence, “undo,” and plain-English summaries.

### Persona B: Solo Dev / Technical Founder
- Wants structured, repeatable AI loop with guardrails and logs.
- Uses it to speed up repetitive work and keep quality gates.

### Persona C: Team Lead
- Wants approvals, policies, audit trail, and predictable PRs.

## 5. Key Use Cases
1) Connect GitHub and select repo(s)  
2) Write requirements as Specs or upload doc → Generate Plan (task cards)  
3) Click Build Next → GitHub Action runs Ralph Loop → PR created  
4) Review PR summary → Merge or Request Review  
5) Undo: create Revert PR  
6) Monitor runs, logs, costs, and approvals over time  

## 6. Product Requirements (Functional)

### 6.1 Authentication & Accounts
- Sign up / sign in with email (optional) + GitHub connection.
- Connect via **GitHub App installation** (preferred for least hassle and safer perms).
- Support multiple installations (personal + org).

**Acceptance**
- User can install app on GitHub and see repos granted.

### 6.2 Projects
- Create a Project by selecting a GitHub repo from an installation.
- Store repo metadata (default branch, visibility, owner/org).
- Show Projects list with health (stable/needs attention/blocked).

**Acceptance**
- Projects screen shows repo name, stack detected, last run status, open PR count.

### 6.3 Specs (Requirements Input)
- A project has Specs:
  - editable plain English text
  - optional attachments (links or file uploads)
- Specs are versioned (keep history).

**Acceptance**
- Users can edit specs and restore a previous version.

### 6.4 Plan Generation (Task Cards)
- “Generate Plan” creates/updates a Plan and Task cards.
- Each Task includes:
  - title
  - impact (low/med/high)
  - risk (low/med/high)
  - modules touched (ios/rust/python/go/web)
  - acceptance checklist
  - test expectations
  - dependencies (optional)
  - recommended ordering
- Plan can be regenerated (overwrites/archives old plan).

**Acceptance**
- Plan produces 5–50 tasks, each “one-iteration sized.”

### 6.5 Task Board
- Kanban columns: Ideas / Planned / In Progress / Done.
- “Recommended next” highlights a single task.
- Reorder tasks.
- Edit a task (title, acceptance checklist, risk/impact).

**Acceptance**
- User can pick any task or click Build Next for recommended.

### 6.6 Runs (Execution)
- “Build Next” triggers a Run for a specific task.
- Run is executed by GitHub Actions:
  - checks out repo
  - runs Ralph Loop for one iteration (or bounded iterations)
  - pushes branch
  - creates PR
- Runs capture:
  - status: queued/running/succeeded/needs_approval/failed/blocked/paused
  - start/finish times
  - logs link
  - PR link/number
  - policy snapshot used

**Acceptance**
- Run appears in UI within seconds of dispatch and updates via webhook.

### 6.7 PR Review & Merge Flow
- Show PR summary:
  - what changed (plain English)
  - how to verify
  - tests status
  - risk badge
- Buttons:
  - Open PR on GitHub
  - Request Review (if approvals enabled)
  - Undo/Revert PR

**Acceptance**
- Non-technical user understands what happened without reading diffs.

### 6.8 Undo / Rollback
- “Undo” creates a revert PR (GitHub API-based).
- Revert PR references the original PR/run.

**Acceptance**
- Revert PR can be created even if user doesn’t understand git.

### 6.9 Safety Policies (Per Project)
Policies stored per project:
- PR-only mode (always on v1)
- require approval for high-risk tasks
- locked paths (folders that cannot be changed)
- budget limits:
  - max runs per day
  - max iterations per run
  - optional token/£ cap (approx or provider-based)
- full checks cadence:
  - run full test suite every N runs or on contract changes

**Enforcement**
- Pre-dispatch: app blocks disallowed runs.
- In-run: GitHub Action checks changed files against locked paths and fails/blocks.

**Acceptance**
- A run that edits a locked path is automatically blocked.

### 6.10 Admin & Audit (Minimum)
- Audit log for:
  - project created
  - plan generated
  - run triggered
  - approval granted/denied
  - revert created
- Basic admin view to inspect installations and webhooks.

## 7. Ralph Loop Requirements (Core Differentiator)
### 7.1 Definition
Ralph Loop is a deterministic outer loop that:
- starts fresh each iteration (no hidden memory)
- reads repo files as the source of truth (Specs/Plan/Agents)
- implements **one small task** per iteration
- runs checks and updates plan
- exits cleanly

### 7.2 File-Based State (in the repo)
Every project repo must contain a `/ralph` directory (can be bootstrapped automatically):
- `SPECS/*` — requirements “topics of concern”
- `IMPLEMENTATION_PLAN.md` — ordered tasks
- `AGENTS.md` — operational commands only
- `PROMPT_plan.md`, `PROMPT_build.md` — prompts
- `ralph.config.json` — module commands & policies (optional)
- `deps.contracts.json` — contract fan-out mapping (optional)
- `bin/