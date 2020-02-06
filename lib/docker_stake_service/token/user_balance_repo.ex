defmodule DockerStakeService.UserBalanceRepo do
  @moduledoc false

  use DockerStakeService.Schema
  import Ecto.Changeset

  alias DockerStakeService.Repo

  @fields [:id, :user_id, :token_id, :balance]
  @required_fields [:user_id, :token_id, :balance]

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "user_balance" do
    belongs_to(
      :user,
      UserRepo,
      references: :id,
      type: Ecto.UUID,
      foreign_key: :user_id
    )
    belongs_to(
      :token,
      TokenRepo,
      references: :id,
      type: Ecto.UUID,
      foreign_key: :token_id
    )
    field(:balance, :integer)
    field(:lock_version, :integer, default: 1)
    timestamps()
  end

  def changeset(%__MODULE__{} = user, params) do
    user
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:ticker, name: :token_ticker_index)
  end

  def update_user_balance_for_token(user_id, token_id, balance) do
    on_conflict = [
      set: [
        balance: balance
      ]
    ]

    %__MODULE__{}
    |> changeset(%{
      user_id: user_id,
      token_id: token_id,
      balance: balance
    })
    |> Repo.insert(on_conflict: on_conflict, conflict_target: [:user_id, :token_id])
  end
end
