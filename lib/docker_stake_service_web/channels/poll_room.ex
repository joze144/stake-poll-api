defmodule DockerStakeServiceWeb.PollRoom do
  @moduledoc false
  use Phoenix.Channel

  alias DockerStakeServiceWeb.Endpoint

  require Logger

  def join("pool:" <> pool_id, _, socket) do
    {:ok, socket}
  end

  def broadcast_pool(poll_id, %{} = poll_updates) do
    Endpoint.broadcast!("poll:" <> poll_id, "poll_updates", poll_updates)
  end

  def broadcast_pool(_, _), do: nil
end
