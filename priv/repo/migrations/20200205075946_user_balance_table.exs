defmodule DockerStakeService.Repo.Migrations.UserBalanceTable do
  use Ecto.Migration

  alias DockerStakeService.UserRepo
  alias DockerStakeService.UserBalanceRepo
  alias DockerStakeService.Repo

  @eth_token_id "8bb6fd41-dc57-405f-87da-e372bc511efe"

  def change do
    create table(:user_balance, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:user, column: :id, type: :uuid), null: false
      add :token_id, references(:token, column: :id, type: :uuid, on_delete: :delete_all), null: false
      add :balance, :integer, null: false
      add :lock_version, :integer, null: false, default: 1
      timestamps()
    end
    create unique_index(:user_balance, [:user_id, :token_id], name: :user_balance_user_id_token_id_index)

    alter table(:vote) do
      remove :weight
    end

    flush()

    entries =
      UserRepo.get_all()
      |> Enum.map(&create_user_balances_for_existing_users/1)

    Repo.insert_all(UserBalanceRepo, entries, on_conflict: :nothing)
  end

  defp create_user_balances_for_existing_users(%{id: user_id}) do
    %{
      id: Ecto.UUID.generate(),
      user_id: user_id,
      token_id: @eth_token_id,
      balance: 0,
      updated_at: NaiveDateTime.utc_now(),
      inserted_at: NaiveDateTime.utc_now()
    }
  end
end
