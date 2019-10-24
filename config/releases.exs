import Config

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
cool_text = System.fetch_env!("COOL_TEXT")
application_port = System.fetch_env!("APP_PORT")
jwt_secret = System.fetch_env!("JWT_SECRET")

config :docker_stake_service_release, StakePollApiReleaseWeb.Endpoint,
       http: [:inet6, port: String.to_integer(application_port)],
       secret_key_base: secret_key_base

config :docker_stake_service_release,
       cool_text: cool_text
