defmodule DockerStakeService.Repo.Migrations.TotalViewsOnPoll do
  use Ecto.Migration

  def change do
    alter table("poll") do
      add :total_views, :integer, null: false, default: 0
    end
  end
end
