defmodule BeaconCore.Repo do
  use Ecto.Repo,
    otp_app: :beacon_core,
    adapter: Ecto.Adapters.Postgres
end
