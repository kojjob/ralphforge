defmodule BeaconWebTest do
  use ExUnit.Case
  doctest BeaconWeb

  test "greets the world" do
    assert BeaconWeb.hello() == :world
  end
end
