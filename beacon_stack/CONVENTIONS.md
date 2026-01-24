# BeaconStack Conventions

These conventions keep the Ralph loop consistent over long runs.

## Eventing

- Event names: `<bounded_context>.<aggregate>.<action>` (e.g. `tasks.task.created`)
- Events are append-only; handlers/projections must be idempotent.
- Every event carries: `tenant_id`, `occurred_at`, `trace_id`.

## Tenancy

- Shared DB, every table includes `tenant_id`.
- Postgres RLS enforces tenant isolation; app must not rely on filters alone.

## Repo Structure (target)

- `apps/*` for umbrella apps
- `docs/*` for user-facing documentation
- `priv/*` for migrations/seeds per app

## Testing

- Prefer small unit tests; add 1 integration test per vertical slice.
- Never commit red builds; `mix test` must pass.
