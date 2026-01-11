import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :ralph_forge, RalphForge.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "ralph_forge_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ralph_forge, RalphForgeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "iAMn+Z3nUOaPj7uQ+KASP614Vekzf6x/ndoed36FvtG4OfFhx4EReF6kuA8yIdeh",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

# Sort query params output of verified routes for robust url comparisons
config :phoenix,
  sort_verified_routes_query_params: true

# Speed up bcrypt hashing for tests (never use in production).
config :bcrypt_elixir, log_rounds: 1

# Configure Oban for testing - use inline mode for synchronous execution
config :ralph_forge, Oban, testing: :inline

# Use Mox mock for Claude API in tests
config :ralph_forge, :claude_client, RalphForge.AI.ClaudeMock
