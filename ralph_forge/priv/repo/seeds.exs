# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RalphForge.Repo.insert!(%RalphForge.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias RalphForge.Templates.Template

templates = [
  %{
    name: "SaaS Web App",
    description: "Recurring revenue web product with onboarding, billing, and analytics.",
    category: :saas,
    content:
      "Design a SaaS web application. Include multi-tenant accounts, onboarding flows, usage limits, billing, and admin tooling.",
    is_premium: false
  },
  %{
    name: "Mobile App",
    description: "Mobile-first product with iOS/Android delivery.",
    category: :mobile,
    content:
      "Design a mobile app. Include offline support, push notifications, analytics, and app store release steps.",
    is_premium: false
  },
  %{
    name: "REST API",
    description: "Backend API with authentication, rate limiting, and versioning.",
    category: :api,
    content:
      "Design a REST API. Include authentication, rate limiting, versioning, error handling, and OpenAPI documentation.",
    is_premium: false
  },
  %{
    name: "CLI Tool",
    description: "Command-line tool for automation and developer workflows.",
    category: :cli,
    content:
      "Design a CLI tool. Include command structure, configuration, logging, and packaging/release steps.",
    is_premium: false
  },
  %{
    name: "Phoenix LiveView",
    description: "Elixir Phoenix LiveView application with real-time UI.",
    category: :phoenix,
    content:
      "Design a Phoenix LiveView app. Include contexts, LiveView UI, real-time updates, and deployment steps.",
    is_premium: false
  }
]

Enum.each(templates, fn attrs ->
  Ash.Seed.upsert!(Template, attrs, identity: :unique_name)
end)
