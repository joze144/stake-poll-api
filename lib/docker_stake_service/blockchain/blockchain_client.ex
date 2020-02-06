defmodule DockerStakeService.Blockchain.BlockchainClient do
  @moduledoc false

  @type public_address :: String.t()
  @type signature :: String.t()
  @type message :: String.t()
  @type token_address :: String.t()

  @callback verify_signature(public_address, signature, message) :: {:ok, String.t()}
  @callback get_address_balance(public_address, token_address) :: {:ok, String.t()}

  @implementation Application.get_env(:docker_stake_service, :blockchain_client_impl)

  defdelegate verify_signature(public_address, signature, message), to: @implementation
  defdelegate get_address_balance(public_address, token_address), to: @implementation
end
