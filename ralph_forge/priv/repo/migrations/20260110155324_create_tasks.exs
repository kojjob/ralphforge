defmodule RalphForge.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :input_idea, :text
      add :generated_prompt, :text
      add :tech_stack, :map
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:user_id])
  end
end
