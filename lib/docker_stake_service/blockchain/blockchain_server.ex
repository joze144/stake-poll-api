defmodule DockerStakeService.BlockchainServer do
  @moduledoc false

  use GenServer

  alias DockerStakeService.Blockchain.BlockchainClient
  alias DockerStakeService.UserBalanceRepo
  alias DockerStakeServiceWeb.UserRoom

  require Logger

  def start_link(opts \\ []), do: GenServer.start_link(__MODULE__, [], opts)

  def stop(reason \\ :normal) do
    Logger.warn("#{inspect(reason)}")
    GenServer.stop(__MODULE__, reason)
  end

  def init(_args) do
    Logger.info("Blockchain server is running")
    {:ok, {[]}}
  end

  def update_account_balance(user_id, public_address, token_id) do
    GenServer.cast(__MODULE__, {:update_account_balance, user_id, public_address, token_id})
  end

  def handle_cast({:update_account_balance, user_id, public_address, token_id}, state) do
    with {:ok, %{balance: balance}} <- BlockchainClient.get_address_balance(public_address, "token_address") do
      UserBalanceRepo.update_user_balance_for_token(user_id, token_id, balance)
      UserRoom.push_user_balances_update(user_id)
    end
    {:noreply, state}
  end
end
