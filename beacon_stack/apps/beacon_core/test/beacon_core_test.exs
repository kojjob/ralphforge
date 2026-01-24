defmodule BeaconCoreTest do
  use ExUnit.Case
  doctest BeaconCore

  test "greets the world" do
    assert BeaconCore.hello() == :world
  end
end
