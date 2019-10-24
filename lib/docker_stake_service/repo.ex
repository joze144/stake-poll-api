defmodule DockerStakeService.Repo do
  use Ecto.Repo,
    otp_app: :docker_stake_service,
    adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 10
end
