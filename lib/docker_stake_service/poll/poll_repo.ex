defmodule DockerStakeService.PollRepo do
  @moduledoc false

  use DockerStakeService.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias DockerStakeService.{PollOptionRepo, PollHistoryRepo,Repo, TokenRepo}
  alias Ecto.Multi

  @type poll_id :: String.t()
  @type user_id :: String.t()
  @type title :: String.t()
  @type poll_option :: String.t()
  @type token_id :: String.t()
  @type url :: String.t()

  @fields [:id, :token_id, :title, :url, :total_views]
  @required_fields [:token_id, :title, :url]

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "poll" do
    belongs_to(
      :token,
      TokenRepo,
      references: :id,
      type: Ecto.UUID,
      foreign_key: :token_id
    )
    field(:title, :string)
    field(:url, :string)
    field(:total_views, :integer, default: 0)
    field(:lock_version, :integer, default: 1)
    timestamps()

    has_many(
      :poll_option,
      PollOptionRepo,
      references: :id,
      foreign_key: :poll_id,
      on_delete: :delete_all
    )
  end

  def changeset(%__MODULE__{} = user, params) do
    user
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:public_address, name: :user_public_address_index)
  end

  @spec get_by_id(poll_id) :: %__MODULE__{} | nil
  def get_by_id(poll_id) do
    __MODULE__
    |> where([p], p.id == ^poll_id)
    |> Repo.one()
  end

  @spec get_poll_by_id(poll_id) :: Map.t() | nil
  def get_poll_by_id(poll_id) do
    from(p in __MODULE__,
      join: t in TokenRepo,
      on: t.id == p.token_id,
      where: p.id == ^poll_id,
      select: %{
        poll_id: p.id,
        title: p.title,
        url: p.url,
        token_id: t.id,
        ticker: t.ticker,
        token_name: t.name,
        total_views: p.total_views,
        timestamp: p.inserted_at
      }
    )
    |> Repo.one()
    |> preload_poll_options()
  end

  @spec create_poll_transaction(poll_id, title, [poll_option], token_id, user_id, url) :: {:ok, %__MODULE__{}} | {:error, String.t()}
  def create_poll_transaction(poll_id, title, poll_options, token_id, nil, url) do
    poll_entry =
      %__MODULE__{}
      |> changeset(%{id: poll_id, token_id: token_id, title: title, url: url})

    options_entries = PollOptionRepo.create_poll_options(poll_id, poll_options)

    Multi.new()
    |> Multi.insert(:poll_insert, poll_entry, on_conflict: :nothing)
    |> Multi.insert_all(:poll_options_insert, PollOptionRepo, options_entries, on_conflict: :nothing)
    |> Repo.transaction()
  end

  def create_poll_transaction(poll_id, title, poll_options, token_id, user_id, url) do
    poll_entry =
      %__MODULE__{}
      |> changeset(%{id: poll_id, token_id: token_id, title: title, url: url})

    poll_history_entry =
      %PollHistoryRepo{}
      |> PollHistoryRepo.changeset(%{poll_id: poll_id, user_id: user_id})

    options_entries = PollOptionRepo.create_poll_options(poll_id, poll_options)

    Multi.new()
    |> Multi.insert(:poll_insert, poll_entry, on_conflict: :nothing)
    |> Multi.insert_all(:poll_options_insert, PollOptionRepo, options_entries, on_conflict: :nothing)
    |> Multi.insert(:poll_history_insert, poll_history_entry, on_conflict: :nothing)
    |> Repo.transaction()
  end

  def preload_poll_options(%{poll_id: poll_id} = poll) do
    poll_options =
      from(po in PollOptionRepo,
        where: po.poll_id == ^poll_id,
        select: %{
          poll_option_id: po.id,
          content: po.content
        }
      )
      |> Repo.all()

    Map.put(poll, :poll_options, poll_options)
  end

  def preload_poll_options(nil), do: nil

  def increment_number_of_views_on_poll(poll_id) do
    {:ok, binary_poll_id} = Ecto.UUID.dump(poll_id)
    Ecto.Adapters.SQL.query!(
      Repo, "UPDATE poll SET total_views = total_views + 1 WHERE id = $1", [binary_poll_id]
    )
  end
end
