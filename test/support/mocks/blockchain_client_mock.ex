defmodule DockerStakeService.Blockchain.BlockchainClientImpl.Mock do
  @moduledoc false

  def verify_signature(_, _, _), do: {:ok, true}
  def get_address_balance(_, _), do: {:ok, 0}
end
