defmodule DockerStakeService.Repo.Migrations.PollHistoryTable do
  use Ecto.Migration

  def change do
    create table(:poll_history, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:user, column: :id, type: :uuid, on_delete: :delete_all), null: false
      add :poll_id, references(:poll, column: :id, type: :uuid, on_delete: :delete_all), null: false
      add :voted_option_id, references(:poll_option, column: :id, type: :uuid, on_delete: :delete_all), null: true
      add :lock_version, :integer, null: false, default: 1
      timestamps()
    end
    create unique_index(:poll_history, [:user_id, :poll_id], name: :poll_history_user_id_poll_id_index)
  end
end
