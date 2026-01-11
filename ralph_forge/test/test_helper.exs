Mox.defmock(RalphForge.AI.ClaudeMock, for: RalphForge.AI.ClaudeBehaviour)
Mox.set_mox_private()

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(RalphForge.Repo, :manual)
