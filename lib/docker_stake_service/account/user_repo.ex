defmodule DockerStakeService.UserRepo do
  @moduledoc false

  use DockerStakeService.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias DockerStakeService.Repo

  @fields [:id, :public_address, :nonce]
  @required_fields [:public_address, :nonce]

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "user" do
    field(:public_address, :string, null: true)
    field(:nonce, :integer, null: false)
    field(:lock_version, :integer, default: 1)
    timestamps()
  end

  def changeset(%__MODULE__{} = user, params) do
    user
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:public_address, name: :user_public_address_index)
  end

  def register(public_address) do
    with nil <- get_by_public_address(public_address) do
      changeset(%__MODULE__{}, %{
        public_address: String.downcase(public_address),
        nonce: get_current_utc_seconds()
      })
      |> Repo.insert()
    else
      e ->
        {:ok, e}
    end
  end

  def get_by_public_address(public_address) do
    public_address = String.downcase(public_address)
    __MODULE__
    |> where([u], u.public_address == ^public_address)
    |> Repo.one()
  end

  defp get_current_utc_seconds() do
    DateTime.utc_now() |> DateTime.to_unix()
  end
end
