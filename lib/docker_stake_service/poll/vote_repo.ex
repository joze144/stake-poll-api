defmodule DockerStakeService.VoteRepo do
  use DockerStakeService.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias DockerStakeService.{PollOptionRepo, PollRepo, Repo, UserRepo}

  @fields [:id, :user_id, :poll_id, :poll_option_id, :weight]
  @required_fields [:user_id, :poll_id, :poll_option_id, :weight]

  schema "vote" do
    belongs_to(
      :user,
      UserRepo,
      references: :id,
      type: Ecto.UUID,
      foreign_key: :user_id
    )
    belongs_to(
      :poll,
      PollRepo,
      references: :id,
      type: Ecto.UUID,
      foreign_key: :poll_id
    )
    belongs_to(
      :poll_option,
      PollOptionRepo,
      references: :id,
      type: Ecto.UUID,
      foreign_key: :poll_option_id
    )
    field(:weight, :integer, null: false)
    field(:lock_version, :integer, default: 1)
    timestamps()
  end

  def changeset(%__MODULE__{} = user, params) do
    user
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:poll_user, name: :vote_poll_id_user_id_index)
  end

  def get_weight_sum_for_poll_options(poll_id) do
    from(v in __MODULE__,
      where: v.poll_id == ^poll_id,
      group_by: v.poll_option_id,
      select: %{
        poll_option_id: v.poll_option_id,
        vote_weight: sum(v.weight)
      }
    )
    |> Repo.all()
  end

  def get_for_poll_and_user(_, nil), do: nil

  def get_for_poll_and_user(poll_id, user_id) do
    from(v in __MODULE__,
      where: v.poll_id == ^poll_id and v.user_id == ^user_id,
      select: v.poll_option_id
    )
    |> Repo.one()
  end

  def insert_vote(user_id, poll_id, poll_option_id, weight) do
    changeset(%__MODULE__{}, %{user_id: user_id, poll_id: poll_id, poll_option_id: poll_option_id, weight: weight})
    |> Repo.insert(on_conflict: :nothing)
  end
end
