defmodule RalphForgeWeb.NavigationRenderingTest do
  use RalphForgeWeb.ConnCase, async: false

  import Phoenix.LiveViewTest
  import RalphForgeWeb.AuthTestHelpers

  alias AshAuthentication.BcryptProvider
  alias RalphForge.Accounts
  alias RalphForge.Accounts.User
  alias RalphForge.Tasks
  alias RalphForge.Templates.Template

  describe "task_live/index navigation rendering" do
    test "renders primary navigation with authenticated user", %{conn: conn} do
      user = create_user()
      conn = log_in_user(conn, user)

      {:ok, view, _html} = live(conn, ~p"/tasks")

      # Verify navigation bar exists
      assert has_element?(view, "nav")

      # Verify brand/logo
      assert has_element?(view, "a", "🤖 Ralph Forge")

      # Verify authenticated navigation items are visible
      assert has_element?(view, "a", "Dashboard")
      assert has_element?(view, "a", "Tasks")
      assert has_element?(view, "a", "Sign out")
    end

    test "authenticated user sees dashboard and task management links", %{conn: conn} do
      user = create_user()
      conn = log_in_user(conn, user)

      {:ok, view, _html} = live(conn, ~p"/tasks")

      # Verify task-related links are available to authenticated users
      assert has_element?(view, "a", "Tasks")
      assert has_element?(view, "a", "Dashboard")
      assert has_element?(view, "a", "Settings")
    end

    test "authenticated user sees profile and sign out options", %{conn: conn} do
      user = create_user()
      conn = log_in_user(conn, user)

      {:ok, view, _html} = live(conn, ~p"/tasks")

      # Verify user menu is present with sign out option
      assert has_element?(view, "a", "Sign out")
      # Avatar should contain first letter of email
      html = render(view)
      assert html =~ String.upcase(String.first(to_string(user.email)))
    end
  end

  describe "task_live/show navigation rendering" do
    test "renders navigation in task show page with authenticated user", %{conn: conn} do
      user = create_user()
      {:ok, task} = Tasks.create_task_from_idea(user.id, "Build a SaaS dashboard")
      conn = log_in_user(conn, user)

      {:ok, view, _html} = live(conn, ~p"/tasks/#{task.id}")

      # Verify navigation bar exists
      assert has_element?(view, "nav")

      # Verify brand is clickable
      assert has_element?(view, "a", "🤖 Ralph Forge")

      # Verify authenticated navigation items
      assert has_element?(view, "a", "Tasks")
      assert has_element?(view, "a", "Sign out")
    end

    test "displays task details alongside navigation", %{conn: conn} do
      user = create_user()
      {:ok, task} = Tasks.create_task_from_idea(user.id, "Design a marketplace")
      conn = log_in_user(conn, user)

      {:ok, view, _html} = live(conn, ~p"/tasks/#{task.id}")

      # Verify task details render
      assert has_element?(view, "#task-show")
      assert render(view) =~ "Design a marketplace"

      # Verify navigation is also present
      assert has_element?(view, "nav")
    end
  end

  describe "task_live/new navigation rendering" do
    test "renders navigation in new task form page", %{conn: conn} do
      user = create_user()
      create_template()
      conn = log_in_user(conn, user)

      {:ok, view, _html} = live(conn, ~p"/tasks/new")

      # Verify navigation bar exists
      assert has_element?(view, "nav")

      # Verify authenticated navigation items
      assert has_element?(view, "a", "Dashboard")
      assert has_element?(view, "a", "Sign out")
    end

    test "renders form alongside navigation", %{conn: conn} do
      user = create_user()
      create_template()
      conn = log_in_user(conn, user)

      {:ok, view, _html} = live(conn, ~p"/tasks/new")

      # Verify form renders
      assert has_element?(view, "#task-form")

      # Verify navigation is present
      assert has_element?(view, "nav")
      assert has_element?(view, "a", "🤖 Ralph Forge")
    end
  end

  describe "auth_live/sign_in navigation rendering" do
    test "renders navigation on sign in page for unauthenticated users", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/sign-in")

      # Verify navigation bar exists
      assert has_element?(view, "nav")

      # Verify brand/logo
      assert has_element?(view, "a", "🤖 Ralph Forge")

      # Verify public navigation items
      assert has_element?(view, "a", "Pricing")
      assert has_element?(view, "a", "Documentation")
    end

    test "renders auth form alongside navigation", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/sign-in")

      # Verify auth panel renders
      assert has_element?(view, "#auth-panel") or has_element?(view, "#auth-shell")

      # Verify navigation is present
      assert has_element?(view, "nav")
    end
  end

  describe "navigation authentication awareness" do
    test "sign in page shows public navigation items for unauthenticated users", %{conn: conn} do
      # Test unauthenticated state on public sign-in page
      {:ok, view, _html} = live(conn, ~p"/sign-in")

      # Sign In button should be visible
      assert has_element?(view, "a", "Sign in")

      # Sign Out should not be present
      refute has_element?(view, "a", "Sign out")

      # Public nav items (Pricing, Documentation) should be visible
      assert has_element?(view, "a", "Pricing")
      assert has_element?(view, "a", "Documentation")
    end

    test "authenticated user on protected route sees auth navigation", %{conn: conn} do
      user = create_user()
      conn_auth = log_in_user(conn, user)

      # Authenticated users on protected routes see authenticated nav
      {:ok, view_auth, _html} = live(conn_auth, ~p"/tasks")

      # Sign out should be present for authenticated users
      assert has_element?(view_auth, "a", "Sign out")

      # Sign in should not be present
      refute has_element?(view_auth, "a", "Sign in")
    end

    test "dashboard link only appears for authenticated users", %{conn: conn} do
      # Unauthenticated users on sign-in page don't see Dashboard
      {:ok, view_unauth, _html} = live(conn, ~p"/sign-in")
      refute has_element?(view_unauth, "a", "Dashboard")

      # Authenticated users on protected routes see Dashboard
      user = create_user()
      conn_auth = log_in_user(conn, user)
      {:ok, view_auth, _html} = live(conn_auth, ~p"/tasks")
      assert has_element?(view_auth, "a", "Dashboard")
    end
  end

  describe "navigation link href attributes" do
    test "navigation links have correct href values for authenticated pages", %{conn: conn} do
      user = create_user()
      conn = log_in_user(conn, user)

      {:ok, view, _html} = live(conn, ~p"/tasks")

      # Verify links point to correct routes
      html = render(view)

      # Brand link should point home
      assert html =~ "href=\"/\""

      # Tasks link should point to tasks
      assert html =~ "href=\"/tasks\""
    end
  end

  describe "navigation layout and structure" do
    test "navigation uses navbar component from DaisyUI", %{conn: conn} do
      user = create_user()
      conn = log_in_user(conn, user)

      {:ok, view, _html} = live(conn, ~p"/tasks")

      html = render(view)

      # Verify navbar structure with DaisyUI classes
      assert html =~ "navbar"
      assert html =~ "navbar-start"
      assert html =~ "navbar-center"
      assert html =~ "navbar-end"
    end

    test "navigation includes responsive menu toggle for mobile", %{conn: conn} do
      user = create_user()
      conn = log_in_user(conn, user)

      {:ok, view, _html} = live(conn, ~p"/tasks")

      html = render(view)

      # Verify mobile menu components are present
      assert html =~ "hidden" or html =~ "lg:flex"
    end
  end

  # Helper functions
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
