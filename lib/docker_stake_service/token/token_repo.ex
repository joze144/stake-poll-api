defmodule DockerStakeService.TokenRepo do
  @moduledoc false

  use DockerStakeService.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias DockerStakeService.Repo

  @fields [:id, :ticker, :name]
  @required_fields [:ticker, :name]

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "token" do
    field(:ticker, :string)
    field(:name, :string)
    field(:lock_version, :integer, default: 1)
    timestamps()
  end

  def changeset(%__MODULE__{} = user, params) do
    user
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:ticker, name: :token_ticker_index)
  end
end
