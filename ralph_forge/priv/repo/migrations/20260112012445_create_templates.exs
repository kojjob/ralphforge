defmodule RalphForge.Repo.Migrations.CreateTemplates do
  use Ecto.Migration

  def change do
    create table(:templates, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :name, :text, null: false
      add :description, :text
      add :category, :text, null: false
      add :content, :text, null: false
      add :is_premium, :boolean, default: false, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:templates, [:name])
  end
end
