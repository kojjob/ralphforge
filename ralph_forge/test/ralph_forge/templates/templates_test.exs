defmodule RalphForge.TemplatesTest do
  use RalphForge.DataCase, async: true

  alias RalphForge.Templates
  alias RalphForge.Templates.Template

  describe "list_templates/0" do
    test "returns available templates" do
      template =
        Ash.Seed.seed!(Template, %{
          name: "Test Template",
          description: "Template for testing",
          category: :saas,
          content: "Template content",
          is_premium: false
        })

      assert {:ok, templates} = Templates.list_templates()
      assert Enum.any?(templates, fn item -> item.id == template.id end)
    end
  end

  describe "get_template/1" do
    test "returns template by id" do
      template =
        Ash.Seed.seed!(Template, %{
          name: "API Template",
          description: "Template for APIs",
          category: :api,
          content: "Build an API",
          is_premium: false
        })

      template_id = template.id
      assert %Template{id: ^template_id} = Templates.get_template(template_id)
      assert Templates.get_template(Ecto.UUID.generate()) == nil
    end
  end
end
