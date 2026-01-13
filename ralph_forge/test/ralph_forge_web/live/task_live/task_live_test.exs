defmodule RalphForgeWeb.TaskLiveTest do
  use RalphForgeWeb.ConnCase, async: false

  import Phoenix.LiveViewTest
  import RalphForgeWeb.AuthTestHelpers

  alias AshAuthentication.BcryptProvider
  alias RalphForge.Accounts
  alias RalphForge.Accounts.User
  alias RalphForge.Tasks
  alias RalphForge.Templates.Template

  describe "task pages" do
    test "renders the task index for signed-in users", %{conn: conn} do
      user = create_user()
      {:ok, task} = Tasks.create_task_from_idea(user.id, "Build a SaaS ops dashboard")
      conn = log_in_user(conn, user)

      {:ok, view, _html} = live(conn, ~p"/tasks")

      assert has_element?(view, "#tasks-index")
      assert has_element?(view, "#tasks")
      assert has_element?(view, "#task-open-#{task.id}")
    end

    test "renders the new task form", %{conn: conn} do
      user = create_user()
      template = create_template()
      conn = log_in_user(conn, user)

      {:ok, view, _html} = live(conn, ~p"/tasks/new")

      assert has_element?(view, "#task-form")
      assert has_element?(view, "#generate-task-button")
      assert has_element?(view, "#task_template_id")
      assert has_element?(view, "option[value=\"#{template.id}\"]")
    end

    test "renders the task show view", %{conn: conn} do
      user = create_user()
      {:ok, task} = Tasks.create_task_from_idea(user.id, "Design a marketplace for local artists")
      conn = log_in_user(conn, user)

      {:ok, view, _html} = live(conn, ~p"/tasks/#{task.id}")

      assert has_element?(view, "#task-show")
      assert has_element?(view, "#copy-json")
    end
  end

  defp create_user do
    email = "user#{System.unique_integer([:positive])}@example.com"
    password = "ValidPassword123!"

    {:ok, hashed_password} = BcryptProvider.hash(password)
    Ash.Seed.seed!(User, %{email: email, hashed_password: hashed_password})

    %User{} = Accounts.get_user_by_email_and_password(email, password)
  end

  defp create_template do
    Ash.Seed.seed!(Template, %{
      name: "Test Template",
      description: "Template for testing",
      category: :saas,
      content: "Template content",
      is_premium: false
    })
  end
end
