defmodule BeaconCore.RepoTest do
  use ExUnit.Case, async: true

  test "BeaconCore.Repo is defined" do
    assert Code.ensure_loaded?(BeaconCore.Repo)
  end
end
