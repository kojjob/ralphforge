defmodule RalphForge.Templates do
  use Ash.Domain,
    otp_app: :ralph_forge,
    extensions: [AshAdmin.Domain]

  require Ash.Query

  alias RalphForge.Templates.Template

  resources do
    resource(RalphForge.Templates.Template)
  end

  def list_templates do
    Template
    |> Ash.Query.for_read(:read)
    |> Ash.Query.sort([:category, :name])
    |> Ash.read(domain: __MODULE__, authorize?: false)
  end

  def get_template(id) do
    case Ash.get(Template, id, domain: __MODULE__, authorize?: false) do
      {:ok, template} -> template
      {:error, _} -> nil
    end
  end

  def get_template!(id) do
    Ash.get!(Template, id, domain: __MODULE__, authorize?: false)
  end
end
