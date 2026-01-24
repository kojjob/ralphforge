# BeaconStack — SaaS Foundation Spec

## System / Role

You are a principal Elixir/Phoenix architect and platform engineer. Build a production-grade, reusable “SaaS Foundation” template named **BeaconStack** that will be cloned to start multiple B2B SaaS products.

## High-level goal

Create an Elixir umbrella monorepo that provides a reusable architecture for:

- Multi-tenant B2B SaaS (tenant isolation, roles, audit)
- Event-driven backbone (domain events, transactional outbox, projections)
- Real-time UX (Phoenix PubSub + Channels + LiveView operator consoles)
- Ash-first domain modeling and authorization policies
- Postgres partitioning for high-volume logs
- Built-in observability, rate limiting, and circuit breakers

This is NOT a demo. It must be production-ready with tests, docs, and clear extension points.

## Constraints

- Pure Elixir (BEAM) services only (no Go/Rust microservices).
- Avoid compliance-heavy features; this is a foundation, not a regulated product.
- Default multi-tenancy is shared DB with `tenant_id`, with optional enterprise path described (schema-per-tenant).
- Must include a robust event publishing approach using a **Transactional Outbox** pattern (avoid dual-write failures).

## Tech stack

- Elixir + Phoenix + Phoenix LiveView + Phoenix PubSub
- Ash Framework + `ash_postgres` + `ash_phoenix` + `ash_policies` (+ optional `ash_auth` if needed)
- PostgreSQL
- Oban for background jobs
- OpenTelemetry + Telemetry for instrumentation
- `Hammer.Plug` (or equivalent) for rate limiting
- Circuit breaker via `fuse` (or equivalent BEAM library)
- TailwindCSS

## Deliverables

1) Umbrella repo with these apps:
   - `beacon_core` (Ash domain/resources/policies/tenancy/outbox schemas)
   - `beacon_web` (Phoenix endpoint, router, LiveView, PubSub topics)
   - `beacon_workers` (Oban jobs: outbox dispatcher, projections, maintenance)
   - `beacon_observability` (Telemetry/OTel wiring, logger metadata, trace helpers)

2) A working sample feature (“Vertical Slice”) to prove the template:
   - Tenants + Users + Memberships (roles)
   - A sample resource (e.g., `Project` + `Task`)
   - Create/Update emits domain events into outbox
   - Projections update a dashboard counter
   - LiveView dashboard updates in real-time

3) Docs:
   - `docs/ARCHITECTURE.md` (overall diagram + data flows)
   - `docs/TENANCY.md` (RLS strategy + request scoping)
   - `docs/EVENTS.md` (event naming/versioning + outbox + projections)
   - `docs/OBSERVABILITY.md` (trace IDs, metrics, logs, SLOs)
   - `docs/SECURITY.md` (authz model + audit + rate limiting)
   - `docs/CONTRIBUTING.md` (how to add a new resource “the Beacon way”)

4) Tests:
   - Unit tests for tenancy scoping + policies
   - Integration tests ensuring cross-tenant reads fail
   - Outbox reliability tests (idempotency, retry, ordering constraints)
   - LiveView real-time update test for the sample dashboard

## Architecture requirements

### A) Multi-tenancy (default)

- All tenant-bound tables have `tenant_id` (UUID).
- Provide a single “Tenant Context Plug” that resolves tenant (subdomain/header/JWT claim) and sets tenant context for the request.
- Implement Postgres RLS approach OR a strict query scoping approach:
  - Prefer RLS when possible; ensure a consistent DB session setting per request/transaction.
- Provide a clear enterprise upgrade path explanation (schema-per-tenant), but keep default as shared DB.

### B) Domain events + Transactional Outbox

- Implement an `outbox_events` table:
  - id, tenant_id, event_name, event_version, payload (jsonb), meta (jsonb), status, attempts, available_at, inserted_at
- Enforce: domain writes and outbox insert happen in the SAME DB transaction (use `Ecto.Multi`).
- Create an Oban job `OutboxDispatcher`:
  - Claims pending events (safe concurrency)
  - Broadcasts to PubSub topics
  - Enqueues projection jobs
  - Marks events as dispatched
- Must be idempotent (safe to retry) and handle duplicates.
- Document why outbox is used and how it avoids “dual-write” failure modes.

### C) Projections

- Create projection tables (read models) for dashboards:
  - e.g., `tenant_stats` with counters like tasks_created_today, active_users, etc.
- Projections are updated by jobs consuming outbox events.
- Ensure projection updates are idempotent per event id.

### D) Real-time layer

- Standard topic conventions:
  - `tenant:{tenant_id}:dashboard:{name}`
  - `tenant:{tenant_id}:resource:{type}:{id}`
- LiveView pages subscribe to tenant dashboard topics and update counters instantly.
- Use Channels only if needed for client API; otherwise LiveView-first.

### E) Ash modeling + authorization + audit

- All core entities are Ash resources.
- Policies live in Ash resources (no scattered authorization logic).
- Include audit trail using `ash_paper_trail` for selected resources (Tenant, User, Membership, Project, Task).

### F) Postgres partitioning for high-volume logs

- Provide migrations and utilities for partitioning ONLY for append-only tables like telemetry/events (optional toggle).
- Provide a `CleanupPartitions` job that drops old partitions by retention policy.
- Include docs on when to enable partitioning.

### G) Observability and safety rails

- Trace IDs: generate per request, propagate to logs and jobs.
- Telemetry events for: web requests, DB queries, Oban jobs, outbox lag, projection latency.
- OpenTelemetry export wiring (pluggable exporters).
- Add rate limiting on:
  - auth endpoints
  - expensive API endpoints
  - webhook endpoints
- Add circuit breakers for external calls (LLM/SMS/email/webhooks), with backoff + fallback.

## Engineering standards

- Consistent code style, `.formatter.exs` setup, Credo config.
- Clear extension points:
  - adding a new Ash resource
  - adding a new event + projection
  - adding a new LiveView dashboard widget
- Everything should be readable for a solo founder and safe-by-default.

## Output format

- Provide:
  - Full file tree
  - Key files content (core modules, plugs, outbox schema, dispatcher job, projection job, sample LiveViews)
  - Migrations
  - Test suite skeleton with at least a few real tests implemented
  - Docs in Markdown in `/docs`

## Acceptance criteria (must pass)

- Running `mix test` passes.
- Running the app and creating a Task results in:
  - outbox event inserted
  - dispatcher publishes
  - projection updates
  - LiveView dashboard counter updates without refresh
- Cross-tenant access tests prove isolation.
