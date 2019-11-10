defmodule DockerStakeService.PollHistoryRepo do
  @moduledoc false

  use DockerStakeService.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias DockerStakeService.{PollOptionRepo, PollRepo, UserRepo}
  alias DockerStakeService.Repo

  @page_size 30

  @fields [:id, :user_id, :poll_id, :voted_option_id]
  @required_fields [:user_id, :poll_id]

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "poll_history" do
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
      :voted_option,
      PollOptionRepo,
      references: :id,
      type: Ecto.UUID,
      foreign_key: :voted_option_id
    )
    field(:lock_version, :integer, default: 1)
    timestamps()
  end

  def changeset(%__MODULE__{} = user, params) do
    user
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:user_poll, name: :poll_history_user_id_poll_id_index)
  end

  def get_by_user_id_paginated(user_id, page) do
    from(ph in __MODULE__,
      join: p in PollRepo,
      on: p.id == ph.poll_id,
      left_join: po in PollOptionRepo,
      on: ph.voted_option_id == po.id,
      where: ph.user_id == ^user_id,
      order_by: [desc: ph.inserted_at],
      select: %{
        poll_id: ph.poll_id,
        title: p.title,
        chosen_option_id: ph.voted_option_id,
        chosen_option_content: fragment("""
        CASE WHEN p2 IS NOT NULL THEN p2.content ELSE NULL END
        """),
        timestamp: ph.inserted_at
      }
    )
    |> Repo.paginate(page: page, page_size: @page_size)
  end
end
