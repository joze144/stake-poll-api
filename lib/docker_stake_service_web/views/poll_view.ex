defmodule DockerStakeServiceWeb.PollView do
  use DockerStakeServiceWeb, :view

  def render("show.json", %{user: user}) do
    user
    |> Map.from_struct()
    |> Map.take([:id, :token_id])
  end
end
