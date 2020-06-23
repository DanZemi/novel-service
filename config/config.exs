# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :novel_service,
  ecto_repos: [NovelService.Repo]

# Configures the endpoint
config :novel_service, NovelServiceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "z91MtfW7rkrpOxm4yllx0XF7/79GqLYAXM8CljMUcTe8ava2g4uHsL0v0FhzQxlA",
  render_errors: [view: NovelServiceWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: NovelService.PubSub,
  live_view: [signing_salt: "jZPTxvmo"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
