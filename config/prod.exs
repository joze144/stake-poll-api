use Mix.Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.

# Do not print debug messages in production
config :logger, level: :warn

config :docker_stake_service, :enable_bitly, true


secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
application_port = System.fetch_env!("APP_PORT")

###### JWT ########
jwt_secret = System.fetch_env!("JWT_SECRET")

###### POSTGRESQL DB ########
db_url = System.fetch_env!("POSTGRESQL_URL")

###### Bitly ######
bitly_token = System.fetch_env!("BITLY_TOKEN")

###### URL ######
url_domain = System.fetch_env!("URL_DOMAIN")

config :docker_stake_service, DockerStakeServiceWeb.Endpoint,
       http: [:inet6, port: 4000],
       secret_key_base: secret_key_base,
       check_origin: false,
       server: true

config :docker_stake_service, bitly_token: bitly_token

config :docker_stake_service, jwt_secret: jwt_secret

config :docker_stake_service, DockerStakeService.Repo,
       url: db_url,
       pool_size: 10

config :docker_stake_service, :url_domain, url_domain

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :docker_stake_service, DockerStakeServiceWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         :inet6,
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :docker_stake_service, DockerStakeServiceWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.

# Finally import the config/prod.secret.exs which loads secrets
# and configuration from environment variables.
