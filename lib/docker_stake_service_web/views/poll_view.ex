defmodule DockerStakeServiceWeb.PollView do
  use DockerStakeServiceWeb, :view

  def render("show.json", %{poll: poll, user_vote: user_vote}) do
    poll
    |> Map.take([:poll_id, :poll_options, :ticker, :title, :token_name])
    |> Map.put(:user_vote, user_vote)
  end
end
