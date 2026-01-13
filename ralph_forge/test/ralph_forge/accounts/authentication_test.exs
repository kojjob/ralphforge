defmodule RalphForge.Accounts.AuthenticationTest do
  use RalphForge.DataCase, async: true

  alias AshAuthentication.{Info, Strategy}
  alias RalphForge.Accounts.User

  describe "password registration" do
    test "registers a user with valid credentials" do
      strategy = Info.strategy!(User, :password)

      {:ok, user} =
        Strategy.action(strategy, :register, %{
          "email" => "user@example.com",
          "password" => "SecurePass123!",
          "password_confirmation" => "SecurePass123!"
        })

      assert to_string(user.email) == "user@example.com"
      assert is_binary(user.hashed_password)
      assert user.__metadata__.token
    end

    test "rejects mismatched password confirmation" do
      strategy = Info.strategy!(User, :password)

      assert {:error, %Ash.Error.Invalid{}} =
               Strategy.action(strategy, :register, %{
                 "email" => "user@example.com",
                 "password" => "SecurePass123!",
                 "password_confirmation" => "Nope"
               })
    end
  end

  describe "password sign in" do
    test "signs in with correct credentials" do
      strategy = Info.strategy!(User, :password)

      {:ok, user} =
        Strategy.action(strategy, :register, %{
          "email" => "user@example.com",
          "password" => "SecurePass123!",
          "password_confirmation" => "SecurePass123!"
        })

      {:ok, signed_in} =
        Strategy.action(strategy, :sign_in, %{
          "email" => "user@example.com",
          "password" => "SecurePass123!"
        })

      assert signed_in.id == user.id
      assert signed_in.__metadata__.token
    end

    test "fails with invalid password" do
      strategy = Info.strategy!(User, :password)

      {:ok, _user} =
        Strategy.action(strategy, :register, %{
          "email" => "user@example.com",
          "password" => "SecurePass123!",
          "password_confirmation" => "SecurePass123!"
        })

      assert {:error, %AshAuthentication.Errors.AuthenticationFailed{}} =
               Strategy.action(strategy, :sign_in, %{
                 "email" => "user@example.com",
                 "password" => "wrong-pass"
               })
    end
  end
end
