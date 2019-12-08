import Config

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
application_port = System.fetch_env!("APP_PORT")
jwt_secret = System.fetch_env!("JWT_SECRET")

###### Bitly ######
bitly_token = System.fetch_env!("BITLY_TOKEN")

config :docker_stake_service, DockerStakeServiceWeb.Endpoint,
       http: [:inet6, port: 4000],
       secret_key_base: secret_key_base,
       check_origin: false,
       server: true

config :docker_stake_service, bitly_token: bitly_token
