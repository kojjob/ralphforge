defmodule RalphForgeWeb.AuthLive.SignInTest do
  use RalphForgeWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias AshAuthentication.Info
  alias RalphForge.Accounts.User

  describe "sign in" do
    test "renders the sign in form", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/sign-in")

      assert has_element?(view, "#auth-shell")
      assert has_element?(view, "form##{sign_in_form_id()}")
    end

    test "renders the registration form", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/register")

      assert has_element?(view, "#auth-shell")
      assert has_element?(view, "input[name=\"user[password_confirmation]\"]")
    end
  end

  defp sign_in_form_id do
    auth_form_id(strategy().sign_in_action_name)
  end

  defp auth_form_id(action_name) do
    strategy = strategy()

    subject =
      User
      |> Info.authentication_subject_name!()
      |> to_string()
      |> Slug.slugify()

    strategy_name =
      strategy.name
      |> to_string()
      |> Slug.slugify()

    action =
      action_name
      |> to_string()
      |> Slug.slugify()

    "#{subject}-#{strategy_name}-#{action}"
  end

  defp strategy do
    Info.strategy!(User, :password)
  end
end
