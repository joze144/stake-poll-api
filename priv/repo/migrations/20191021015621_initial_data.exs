defmodule DockerStakeService.Repo.Migrations.InitialData do
  use Ecto.Migration

  alias DockerStakeService.TokenRepo
  alias DockerStakeService.Repo

  def change do
    TokenRepo.changeset(%TokenRepo{}, %{id: "8bb6fd41-dc57-405f-87da-e372bc511efe", ticker: "ETH", name: "Ethereum"})
    |> Repo.insert(on_conflict: :nothing)
  end
end
