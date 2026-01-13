defmodule RalphForgeWeb.PageControllerTest do
  use RalphForgeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Transform Ideas Into"
  end
end
