# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :docker_stake_service,
  ecto_repos: [DockerStakeService.Repo]

# Configures the endpoint
config :docker_stake_service, DockerStakeServiceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Jaqkjv2/qawUz1hon05WU2+F9rQ+/3WIy9FhOYpOXyA01+QNMdDvPv17hVSl2HJq",
  render_errors: [view: DockerStakeServiceWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DockerStakeService.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
