# BeaconStack TODO

This file is the Ralph loop’s source of truth.

## Milestones

- [ ] M1) Umbrella skeleton + Phoenix web boots
- [ ] M2) Deps + baseline config (Ash, Oban, Telemetry/OTel, rate limit, fuse)
- [ ] M3) Tenancy + RLS + tenant plug + isolation tests
- [ ] M4) Ash resources + policies + migrations + tests
- [ ] M5) Transactional outbox + dispatcher + idempotency tests
- [ ] M6) Projections + tenant_stats + idempotency tests
- [ ] M7) LiveView realtime dashboard + E2E test
- [ ] M8) Observability (trace_id, telemetry, OTel) + docs
- [ ] M9) Security rails (rate limit, circuit breakers) + tests + docs
- [ ] M10) Docs polish + tutorial + final `mix test`

## Next Up (keep this short)

- [x] Read `SPEC.md` and outline M1 skeleton
- [x] Convert `apps/beacon_web` to Phoenix app
- [x] Convert `apps/beacon_core` to Ecto + Repo skeleton
- [x] Add Ash + ash_postgres to `beacon_core`
- [x] Add test DB setup + migrations baseline
- [ ] Add first AshPostgres resource + migration

## Notes

- Keep tasks small (one loop each).
- Prefer `mix test` over broad commands.
