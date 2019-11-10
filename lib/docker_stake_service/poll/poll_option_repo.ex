defmodule DockerStakeService.PollOptionRepo do
  use DockerStakeService.Schema
  import Ecto.Changeset

  alias DockerStakeService.PollRepo

  @type poll_id :: String.t()
  @type pole_option :: String.t()

  @fields [:id, :poll_id, :content]
  @required_fields [:poll_id, :content]

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "poll_option" do
    belongs_to(
      :poll,
      PollRepo,
      references: :id,
      type: Ecto.UUID,
      foreign_key: :poll_id
    )
    field(:content, :string, null: false)
    field(:lock_version, :integer, default: 1)
    timestamps()
  end

  def changeset(%__MODULE__{} = user, params) do
    user
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:public_address, name: :user_public_address_index)
  end

  @spec create_poll_options(poll_id, [pole_option]) :: [Ecto.Changeset]
  def create_poll_options(poll_id, pole_options) do
    pole_options
    |> Enum.map(fn %{"id" => option_id, "content" => option} -> prepare_entry(option_id, option, poll_id) end)
  end

  defp prepare_entry(option_id, content, poll_id) do
    %{
      id: option_id,
      poll_id: poll_id,
      content: content,
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
  end
end
