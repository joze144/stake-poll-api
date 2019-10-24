defmodule DockerStakeService.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table(:user, primary_key: false) do
      add :id, :uuid, primary_key: true
      add(:public_address, :string, null: false)
      add(:nonce, :integer, null: false)
      add :lock_version, :integer, null: false, default: 1
      timestamps()
    end
    create unique_index(:user, [:public_address], name: :user_public_address_index)

    create table(:token, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :ticker, :string, null: false
      add :name, :string, null: false
      add :lock_version, :integer, null: false, default: 1
      timestamps()
    end
    create unique_index(:token, [:ticker], name: :token_ticker_index)

    create table(:poll, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :token_id, references(:token, column: :id, type: :uuid, on_delete: :delete_all), null: false
      add :title, :string, null: false
      add :lock_version, :integer, null: false, default: 1
      timestamps()
    end

    create table(:poll_option, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :poll_id, references(:poll, column: :id, type: :uuid, on_delete: :delete_all), null: false
      add :content, :string, null: false
      add :lock_version, :integer, null: false, default: 1
      timestamps()
    end

    create table(:vote) do
      add :user_id, references(:user, column: :id, type: :uuid), null: false
      add :poll_id, references(:poll, column: :id, type: :uuid, on_delete: :delete_all), null: false
      add :poll_option_id, references(:poll_option, column: :id, type: :uuid, on_delete: :delete_all), null: false
      add :weight, :integer, null: false
      add :lock_version, :integer, null: false, default: 1
      timestamps()
    end

    create unique_index(:vote, [:poll_id, :user_id], name: :vote_poll_id_user_id_index)
  end
end
