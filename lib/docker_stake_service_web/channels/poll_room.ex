defmodule DockerStakeServiceWeb.PollRoom do
  @moduledoc false
  use Phoenix.Channel

  alias DockerStakeService.PollRepo
  alias DockerStakeServiceWeb.Endpoint

  require Logger

  def join("pool:" <> pool_id, _, socket) do
    with %PollRepo{} <- PollRepo.get_poll_by_id(pool_id) do
      {:ok, socket}
    else
      _ ->
        {:error, "Poll does not exist"}
    end
  end

  def broadcast_pool(poll_id, %{} = poll_updates) do
    Endpoint.broadcast!("poll:" <> poll_id, "poll_updates", poll_updates)
  end

  def broadcast_pool(_, _), do: nil
end
