defmodule RalphForge.Factory do
  @moduledoc """
  Test factories for RalphForge using ExMachina.
  """

  use ExMachina.Ecto, repo: RalphForge.Repo

  alias RalphForge.Accounts.User
  alias RalphForge.Tasks.Task
  alias RalphForge.Templates.Template

  def user_factory do
    %User{
      email: sequence(:email, &"user#{&1}@example.com"),
      hashed_password: Bcrypt.hash_pwd_salt("ValidPassword123!")
    }
  end

  def task_factory do
    %Task{
      input_idea: "Build a SaaS platform for managing customer feedback",
      status: :pending,
      user: build(:user)
    }
  end

  def processing_task_factory do
    %Task{
      input_idea: "Create an e-commerce marketplace",
      status: :generating,
      user: build(:user)
    }
  end

  def completed_task_factory do
    %Task{
      input_idea: "Develop a project management tool",
      status: :completed,
      generated_prompt: "Complete Ralph task for project management...",
      tech_stack: %{"backend" => ["Elixir", "Phoenix"], "frontend" => ["LiveView"]},
      user: build(:user)
    }
  end

  def template_factory do
    %Template{
      name: sequence(:template_name, &"Template #{&1}"),
      description: "A starter template for testing",
      category: :saas,
      content: "Template instructions for building a SaaS product.",
      is_premium: false
    }
  end
end
