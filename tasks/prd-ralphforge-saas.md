# PRD: RalphForge SaaS - Task Generation Platform

## Introduction

RalphForge is a SaaS platform that transforms business ideas into executable Ralph Wiggum tasks. Users input vague ideas like "build a habit tracking app" and get complete, production-ready task breakdowns with tech stack recommendations, feature decomposition, and ready-to-run Ralph prompts.

## Goals

- Enable users to transform any business idea into executable development tasks
- Provide AI-powered tech stack recommendations and feature decomposition
- Generate complete Ralph task prompts ready for autonomous execution
- Create a subscription-based SaaS with freemium model
- Achieve 1,500 paying users and $720K ARR in Year 1

## User Stories

### US-001: Set up Phoenix project with Ash Framework
**Description:** As a developer, I need a Phoenix project with Ash Framework configured so I can build the core data layer.

**Acceptance Criteria:**
- [ ] Phoenix project created with LiveView support
- [ ] Ash Framework dependencies added (ash, ash_postgres, ash_phoenix, ash_authentication)
- [ ] Database configured (PostgreSQL)
- [ ] Basic project structure established
- [ ] Typecheck passes
- [ ] Tests pass

### US-002: Configure Ash domains (Accounts, Tasks, Templates, Billing)
**Description:** As a developer, I need Ash domains configured for the core business entities.

**Acceptance Criteria:**
- [ ] Accounts domain created for user management
- [ ] Tasks domain created for task generation
- [ ] Templates domain created for reusable templates
- [ ] Billing domain created for subscriptions
- [ ] Domain modules properly configured
- [ ] Typecheck passes
- [ ] Tests pass

### US-003: Create User resource with AshAuthentication
**Description:** As a developer, I need user authentication working via AshAuthentication.

**Acceptance Criteria:**
- [ ] User resource created with email/password
- [ ] AshAuthentication configured
- [ ] Registration endpoint working
- [ ] Login endpoint working
- [ ] Authentication middleware configured
- [ ] Typecheck passes
- [ ] Tests pass

### US-004: Create Task resource for task generation
**Description:** As a developer, I need a Task resource to store generated tasks.

**Acceptance Criteria:**
- [ ] Task resource created with input_idea, generated_prompt, tech_stack fields
- [ ] Belongs_to relationship to User
- [ ] Create action for task generation
- [ ] Basic CRUD operations working
- [ ] Typecheck passes
- [ ] Tests pass

### US-005: Implement Claude API integration
**Description:** As a developer, I need Claude API integration to generate Ralph tasks.

**Acceptance Criteria:**
- [ ] Claude API client configured
- [ ] Task generation function implemented
- [ ] Error handling for API failures
- [ ] Token usage tracking
- [ ] Typecheck passes
- [ ] Tests pass

### US-006: Set up Oban for background job processing
**Description:** As a developer, I need background job processing for AI calls.

**Acceptance Criteria:**
- [ ] Oban dependency added
- [ ] Worker for task generation created
- [ ] Job queuing working
- [ ] Background processing configured
- [ ] Typecheck passes
- [ ] Tests pass

### US-007: Create task generation LiveView
**Description:** As a user, I want a web interface to generate tasks from business ideas.

**Acceptance Criteria:**
- [ ] LiveView for task input created
- [ ] Real-time generation progress shown
- [ ] Results displayed after completion
- [ ] Export options (Markdown, JSON)
- [ ] Typecheck passes
- [ ] Tests pass
- [ ] Verify in browser using dev-browser skill

### US-008: Implement subscription system with Stripe
**Description:** As a developer, I need Stripe integration for subscription billing.

**Acceptance Criteria:**
- [ ] Plan resource created
- [ ] Subscription resource with state machine
- [ ] Stripe webhooks configured
- [ ] Usage tracking implemented
- [ ] Billing limits enforced
- [ ] Typecheck passes
- [ ] Tests pass

### US-009: Add authentication UI (LiveView)
**Description:** As a user, I want to register and login via web interface.

**Acceptance Criteria:**
- [ ] Registration LiveView created
- [ ] Login LiveView created
- [ ] Authentication redirects working
- [ ] Form validation implemented
- [ ] Typecheck passes
- [ ] Tests pass
- [ ] Verify in browser using dev-browser skill

### US-010: Create dashboard for task history
**Description:** As a user, I want to see my generated tasks and usage.

**Acceptance Criteria:**
- [ ] Dashboard LiveView created
- [ ] Task list displayed
- [ ] Usage statistics shown
- [ ] Export functionality working
- [ ] Typecheck passes
- [ ] Tests pass
- [ ] Verify in browser using dev-browser skill

## Functional Requirements

- FR-1: System must generate complete Ralph tasks from business ideas
- FR-2: Users must authenticate via email/password
- FR-3: Tasks must persist with user association
- FR-4: AI generation must happen asynchronously via background jobs
- FR-5: Subscription limits must be enforced (free: 3/month, pro: 100/month)
- FR-6: Real-time UI updates during task generation
- FR-7: Export options must include Markdown and JSON formats
- FR-8: Stripe webhooks must handle subscription lifecycle events

## Non-Goals

- Mobile app (web-only MVP)
- Advanced AI model customization
- Team collaboration features
- Marketplace for user-generated templates
- Enterprise SSO features

## Technical Considerations

- Use Ash Framework for all data operations
- Leverage LiveView for real-time features
- Implement proper error boundaries
- Add rate limiting for API endpoints
- Ensure GDPR compliance for data handling

## Success Metrics

- All tests pass (>80% coverage)
- Typecheck passes without warnings
- Credo linting passes
- Dialyzer passes
- Application boots successfully
- Basic task generation works end-to-end

## Open Questions

- Which Claude model to use for task generation (Haiku vs Sonnet)?
- How to handle API rate limits gracefully?
- What export formats to prioritize initially?