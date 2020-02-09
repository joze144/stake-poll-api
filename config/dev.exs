use Mix.Config

bitly_token = System.fetch_env!("BITLY_TOKEN")

# Configure your database
config :docker_stake_service, DockerStakeService.Repo,
  username: "postgres",
  password: "postgres",
  database: "docker_stake_service_test",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :docker_stake_service, DockerStakeServiceWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Watch static and templates for browser reloading.
config :docker_stake_service, DockerStakeServiceWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/docker_stake_service_web/{live,views}/.*(ex)$",
      ~r"lib/docker_stake_service_web/templates/.*(eex)$"
    ]
  ]

config :docker_stake_service, :jwt_secret, "thisisjwtseccretthisisjwtseccretthisisjwtseccretthisisjwtseccretthisisjwtseccretthisisjwtseccretthisisjwtseccret"

# Do not include metadata nor timestamps in development logs
config :logger, level: :info

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :docker_stake_service, :url_domain, "http://localhost:3042/"
config :docker_stake_service, :blockchain_service_enabled, false
config :docker_stake_service, :blockchain_service_url, "http://localhost:3000/"
config :docker_stake_service, :enable_bitly, false
config :docker_stake_service, :bitly_token, bitly_token
