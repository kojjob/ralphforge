defmodule RalphForge.Repo.Migrations.AddTemplateIdToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :template_id, references(:templates, type: :uuid, on_delete: :nilify_all)
    end

    create index(:tasks, [:template_id])
  end
end
