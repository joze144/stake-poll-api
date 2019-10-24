use Mix.Config

# Configure your database
config :docker_stake_service, DockerStakeService.Repo,
  username: "postgres",
  password: "postgres",
  database: "docker_stake_service_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :docker_stake_service, DockerStakeServiceWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
