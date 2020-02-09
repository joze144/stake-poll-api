defmodule DockerStakeServiceWeb.UserRoom do
  @moduledoc false
  use Phoenix.Channel

  alias DockerStakeService.UserBalanceRepo
  alias DockerStakeServiceWeb.Endpoint

  def join("private:" <> user_id, _, socket) do
    with true <- user_id == socket.assigns.user_id do
      send(self(), :after_join)
      {:ok, socket}
    else
      false ->
        {:error, "This is not your room, get out"}
    end
  end

  def handle_info(:after_join, socket) do
    socket.assigns.user_id
    |> push_user_balances_update()

    {:noreply, socket}
  end

  def push_user_balances_update(user_id) do
    balances = UserBalanceRepo.get_user_balances(user_id)
    broadcast_balance(user_id, balances)
  end

  def broadcast_balance(user_id, balance_update) when is_list(balance_update) and balance_update != [] do
    Endpoint.broadcast!(
      "private:" <> user_id,
      "balance_update",
      %{
        balances: balance_update,
        message_type: :balance_update
      }
    )
  end

  def broadcast_balance(_, _), do: nil
end
