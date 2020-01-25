import Config

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
application_port = System.fetch_env!("APP_PORT")

###### JWT ########
jwt_secret = System.fetch_env!("JWT_SECRET")

###### POSTGRESQL DB ########
## "postgres://postgres:postgres@172.12.0.101:5432/docker_stake_service_prod"
db_url = System.fetch_env!("POSTGRESQL_URL")
pool_size = System.get_env!("POOL_SIZE")

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
       pool_size: String.to_integer(pool_size)

# "http://stakepoll.jozhe.com/"
config :docker_stake_service, :url_domain, url_domain
