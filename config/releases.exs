import Config

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

###### BLOCKCHAIN SERVICE #######

blockchain_service_url = System.fetch_env!("BLOCKCHAIN_SERVICE_URL")

config :docker_stake_service, :blockchain_service_url, blockchain_service_url

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

config :docker_stake_service, :enable_bitly, true
