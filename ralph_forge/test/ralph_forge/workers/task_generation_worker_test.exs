defmodule RalphForge.Workers.TaskGenerationWorkerTest do
  use RalphForge.DataCase, async: true
  use Oban.Testing, repo: RalphForge.Repo

  import Mox

  alias AshAuthentication.BcryptProvider
  alias RalphForge.Accounts.User
  alias RalphForge.Workers.TaskGenerationWorker
  alias RalphForge.Tasks

  # Make sure mocks are verified
  setup :verify_on_exit!
  setup :set_mox_from_context

  describe "perform/1" do
    test "successfully generates and saves task content" do
      user = create_user()
      task = create_task(user)

      # Mock the Claude API response
      expect(RalphForge.AI.ClaudeMock, :generate_task, fn _idea, _opts ->
        {:ok,
         %{
           generated_prompt: "Generated Ralph task prompt...",
           tech_stack: %{"backend" => ["Elixir"], "frontend" => ["LiveView"]},
           project_name: "RalphForge",
           user_stories: [%{"id" => "US-001", "title" => "Example"}],
           phases: [%{"name" => "Phase 1", "description" => "Basics"}],
           ralph_prompt: "Do the thing",
           usage: %{input_tokens: 100, output_tokens: 500}
         }}
      end)

      assert :ok = perform_job(TaskGenerationWorker, %{task_id: task.id})

      # Verify task was updated
      updated_task = Tasks.get_task!(task.id)
      assert updated_task.status == :completed
      assert updated_task.generated_prompt == "Generated Ralph task prompt..."
      assert updated_task.tech_stack == %{"backend" => ["Elixir"], "frontend" => ["LiveView"]}
      assert updated_task.tokens_used == 600

      assert updated_task.feature_breakdown == %{
               "project_name" => "RalphForge",
               "user_stories" => [%{"id" => "US-001", "title" => "Example"}],
               "phases" => [%{"name" => "Phase 1", "description" => "Basics"}],
               "ralph_prompt" => "Do the thing"
             }
    end

    test "marks task as failed when API returns error" do
      user = create_user()
      task = create_task(user)

      expect(RalphForge.AI.ClaudeMock, :generate_task, fn _idea, _opts ->
        {:error, :missing_api_key}
      end)

      assert {:error, :missing_api_key} =
               perform_job(TaskGenerationWorker, %{task_id: task.id})

      # Verify task was marked as failed
      updated_task = Tasks.get_task!(task.id)
      assert updated_task.status == :failed
    end

    test "handles task not found gracefully" do
      non_existent_id = Ecto.UUID.generate()

      assert {:error, :task_not_found} =
               perform_job(TaskGenerationWorker, %{task_id: non_existent_id})
    end

    test "skips already completed tasks" do
      user = create_user()
      task = create_task(user, %{status: :completed})

      # Should not call the API for completed tasks
      assert :ok = perform_job(TaskGenerationWorker, %{task_id: task.id})

      # Status should remain completed
      assert Tasks.get_task!(task.id).status == :completed
    end

    test "sets task to generating before API call" do
      user = create_user()
      task = create_task(user)

      expect(RalphForge.AI.ClaudeMock, :generate_task, fn _idea, _opts ->
        # During the API call, verify task is in generating state
        generating_task = Tasks.get_task!(task.id)
        assert generating_task.status == :generating

        {:ok,
         %{
           generated_prompt: "Generated prompt",
           tech_stack: %{},
           usage: %{input_tokens: 50, output_tokens: 200}
         }}
      end)

      assert :ok = perform_job(TaskGenerationWorker, %{task_id: task.id})
    end
  end

  describe "enqueue/1" do
    test "enqueues a job for task generation" do
      user = create_user()
      task = create_task(user)

      # In inline mode, the job runs immediately, so we need to mock
      expect(RalphForge.AI.ClaudeMock, :generate_task, fn _idea, _opts ->
        {:ok,
         %{
           generated_prompt: "Generated prompt",
           tech_stack: %{},
           usage: %{input_tokens: 50, output_tokens: 200}
         }}
      end)

      assert {:ok, %Oban.Job{}} = TaskGenerationWorker.enqueue(task.id)
    end

    test "uses task_generation queue" do
      user = create_user()
      task = create_task(user)

      # In inline mode, the job runs immediately, so we need to mock
      expect(RalphForge.AI.ClaudeMock, :generate_task, fn _idea, _opts ->
        {:ok,
         %{
           generated_prompt: "Generated prompt",
           tech_stack: %{},
           usage: %{input_tokens: 50, output_tokens: 200}
         }}
      end)

      {:ok, job} = TaskGenerationWorker.enqueue(task.id)
      assert job.queue == "task_generation"
    end
  end

  defp create_user do
    email = "user#{System.unique_integer([:positive])}@example.com"
    {:ok, hashed_password} = BcryptProvider.hash("ValidPassword123!")

    Ash.Seed.seed!(User, %{email: email, hashed_password: hashed_password})
  end

  defp create_task(user, attrs \\ %{}) do
    input_idea =
      Map.get(attrs, :input_idea, "Build a SaaS platform for managing customer feedback")

    {:ok, task} = Tasks.create_task_from_idea(user.id, input_idea)

    case Map.get(attrs, :status) do
      nil ->
        task

      status ->
        {:ok, task} = Tasks.update_task_status(task, status)
        task
    end
  end
end
