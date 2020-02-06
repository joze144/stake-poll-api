defmodule DockerStakeServiceWeb.PollRoom do
  @moduledoc false
  use Phoenix.Channel

  alias DockerStakeService.PollRepo
  alias DockerStakeServiceWeb.Endpoint

  require Logger

  def join("poll:" <> poll_id, _, socket) do
    with {:ok, _} <- UUID.info(poll_id),
         %PollRepo{} <- PollRepo.get_by_id(poll_id) do
      PollRepo.increment_number_of_views_on_poll(poll_id)
      {:ok, socket}
    else
      _ ->
        {:error, "Poll does not exist"}
    end
  end

  def broadcast_pool(poll_id, %{} = poll_updates) do
    Endpoint.broadcast!(
      "poll:" <> poll_id,
      "poll_updates",
      poll_updates |> Map.put(:message_type, "poll_update" <> poll_id)
    )
  end

  def broadcast_pool(_, _), do: nil
end
