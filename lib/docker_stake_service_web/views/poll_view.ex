defmodule DockerStakeServiceWeb.PollView do
  use DockerStakeServiceWeb, :view

  def render("show.json", %{poll: poll, user_vote: user_vote}) do
    poll
    |> Map.take([:poll_id, :poll_options, :ticker, :title, :token_name, :url])
    |> Map.put(:user_vote, user_vote)
  end

  def render("show.json", %{
    poll_id: poll_id,
    title: title,
    url: url,
    chosen_option_id: chosen_id,
    chosen_option_content: chosen_content,
    timestamp: timestamp,
  }) do
    %{
      poll_id: poll_id,
      title: title,
      url: url,
      chosen_option_id: chosen_id,
      chosen_option_content: chosen_content,
      timestamp: timestamp,
    }
  end

  def render("history.json", %{entries: entries, total_entries: total, total_pages: pages}) do
    data = entries |> Enum.map(fn entry -> render("show.json", entry) end)
    %{
      entries: data,
      total_entries: total,
      total_pages: pages
    }
  end
end
