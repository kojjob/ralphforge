import Config

config :beacon_core,
  ecto_repos: [BeaconCore.Repo]

config :beacon_core, :ash_domains, [BeaconCore.Domain]

{default_database, default_pool, default_pool_size} =
  case config_env() do
    :test -> {"beacon_stack_test", Ecto.Adapters.SQL.Sandbox, 1}
    _ -> {"beacon_stack_dev", DBConnection.ConnectionPool, 10}
  end

config :beacon_core, BeaconCore.Repo,
  username: System.get_env("POSTGRES_USER") || System.get_env("PGUSER") || System.get_env("USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || System.get_env("PGPASSWORD"),
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  database: System.get_env("POSTGRES_DB") || default_database,
  pool: default_pool,
  pool_size: String.to_integer(System.get_env("POOL_SIZE", Integer.to_string(default_pool_size)))


config :beacon_core, BeaconCore.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]
