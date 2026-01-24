defmodule BeaconWorkersTest do
  use ExUnit.Case
  doctest BeaconWorkers

  test "greets the world" do
    assert BeaconWorkers.hello() == :world
  end
end
