defmodule DockerStakeService.Repo.Migrations.AddUrlFieldToPoll do
  use Ecto.Migration

  def change do
    alter table(:poll) do
      add :url, :string
    end

    flush()

    execute("""
    UPDATE poll SET url = CONCAT('http://stakepoll.jozhe.com/poll/', id) WHERE url IS NULL OR url = '';
    """)

    flush()
  end
end
