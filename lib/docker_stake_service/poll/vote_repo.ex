defmodule DockerStakeService.VoteRepo do
  use DockerStakeService.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias DockerStakeService.{PollHistoryRepo, PollOptionRepo, PollRepo, Repo, UserBalanceRepo, UserRepo}
  alias Ecto.Multi

  @fields [:id, :user_id, :poll_id, :poll_option_id]
  @required_fields [:user_id, :poll_id, :poll_option_id]

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
    field(:lock_version, :integer, default: 1)
    timestamps()
  end

  def changeset(%__MODULE__{} = user, params) do
    user
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:poll_user, name: :vote_poll_id_user_id_index)
  end

  def get_weight_sum_for_poll_options(poll_id, token_id) do
    from(v in __MODULE__,
      join: ub in UserBalanceRepo,
      on: v.user_id == ub.user_id and ub.token_id == ^token_id,
      where: v.poll_id == ^poll_id,
      group_by: v.poll_option_id,
      select: %{
        poll_option_id: v.poll_option_id,
        vote_weight: sum(ub.balance),
        number_of_voters: count(v.user_id)
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

  def insert_vote(user_id, poll_id, poll_option_id) do
    on_conflict_vote = [
      set: [
        poll_option_id: poll_option_id
      ]
    ]
    vote_entry =
      changeset(%__MODULE__{}, %{user_id: user_id, poll_id: poll_id, poll_option_id: poll_option_id})

    on_conflict_history = [
      set: [
        voted_option_id: poll_option_id
      ]
    ]
    poll_history_entry =
      %PollHistoryRepo{}
      |> PollHistoryRepo.changeset(%{poll_id: poll_id, user_id: user_id, voted_option_id: poll_option_id})

    Multi.new()
    |> Multi.insert(:vote_insert, vote_entry, on_conflict: on_conflict_vote, conflict_target: [:user_id, :poll_id])
    |> Multi.insert(:poll_history_insert, poll_history_entry, on_conflict: on_conflict_history, conflict_target: [:user_id, :poll_id])
    |> Repo.transaction()
  end
end
