defmodule RalphForgeWeb.AuthTestHelpers do
  @moduledoc false

  import Phoenix.ConnTest

  def log_in_user(conn, user, password \\ "ValidPassword123!") do
    user = ensure_user_token(user, password)
    subject_name = AshAuthentication.Info.authentication_subject_name!(user.__struct__)

    conn
    |> init_test_session(%{})
    |> AshAuthentication.Plug.Helpers.store_in_session(user)
    |> Plug.Conn.assign(current_subject_name(subject_name), user)
  end

  defp ensure_user_token(%{__metadata__: %{token: token}} = user, _password)
       when is_binary(token),
       do: user

  defp ensure_user_token(user, password) do
    case AshAuthentication.Jwt.token_for_user(user, %{"purpose" => "user"}) do
      {:ok, token, _claims} ->
        Ash.Resource.put_metadata(user, :token, token)

      :error ->
        strategy = AshAuthentication.Info.strategy!(user.__struct__, :password)

        {:ok, signed_in_user} =
          AshAuthentication.Strategy.action(strategy, :sign_in, %{
            "email" => to_string(user.email),
            "password" => password
          })

        signed_in_user
    end
  end

  defp current_subject_name(subject_name) do
    String.to_existing_atom("current_#{subject_name}")
  end
end
