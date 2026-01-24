defmodule BeaconWebWeb.PageController do
  use BeaconWebWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
