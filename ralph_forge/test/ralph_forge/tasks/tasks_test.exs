defmodule RalphForge.TasksTest do
  use RalphForge.DataCase, async: true

  alias AshAuthentication.BcryptProvider
  alias RalphForge.Accounts.User
  alias RalphForge.Tasks

  describe "create_task_from_idea/2" do
    test "creates a task for the user with default status" do
      user = create_user()

      assert {:ok, task} =
               Tasks.create_task_from_idea(user.id, "Build an AI-powered journaling app")

      assert task.user_id == user.id
      assert task.input_idea == "Build an AI-powered journaling app"
      assert task.status == :pending
    end

    test "returns error when user is missing" do
      assert {:error, :user_not_found} =
               Tasks.create_task_from_idea(Ecto.UUID.generate(), "Missing user")
    end
  end

  describe "update_task_status/2" do
    test "normalizes processing status to generating" do
      user = create_user()
      {:ok, task} = Tasks.create_task_from_idea(user.id, "Idea")

      assert {:ok, updated} = Tasks.update_task_status(task, :processing)
      assert updated.status == :generating
    end
  end

  describe "complete_task_from_result/2" do
    test "stores completion metadata from AI result" do
      user = create_user()
      {:ok, task} = Tasks.create_task_from_idea(user.id, "Idea")

      result = %{
        generated_prompt: "Generated prompt",
        tech_stack: %{"backend" => ["Elixir"]},
        project_name: "Idea",
        user_stories: [%{"id" => "US-001", "title" => "Signup"}],
        phases: [%{"name" => "Phase 1", "description" => "MVP"}],
        ralph_prompt: "Do the thing",
        usage: %{input_tokens: 5, output_tokens: 10}
      }

      assert {:ok, updated} = Tasks.complete_task_from_result(task, result)
      assert updated.status == :completed
      assert updated.tokens_used == 15

      assert updated.feature_breakdown == %{
               "project_name" => "Idea",
               "user_stories" => [%{"id" => "US-001", "title" => "Signup"}],
               "phases" => [%{"name" => "Phase 1", "description" => "MVP"}],
               "ralph_prompt" => "Do the thing"
             }
    end
  end

  defp create_user do
    email = "user#{System.unique_integer([:positive])}@example.com"
    {:ok, hashed_password} = BcryptProvider.hash("ValidPassword123!")

    Ash.Seed.seed!(User, %{email: email, hashed_password: hashed_password})
  end
end
