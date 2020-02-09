defmodule DockerStakeService.Blockchain.BlockchainClient do
  @moduledoc false

  require Logger

  def verify_signature(public_address, signature, message) do
    with true <- Application.get_env(:docker_stake_service, :blockchain_service_enabled) do
      body =
        %{public_address: public_address, signature: signature, message: message}
        |> Poison.encode!()

      get_service_base_url() <> "verify/signature"
      |> HTTPoison.post(body, get_headers())
      |> case do
           {:ok, %{status_code: 200, body: body}} ->
             with %{"valid" => valid} <- body |> Poison.decode!() do
               {:ok, valid}
             else
               e ->
                 Logger.error("Failed to validate: #{inspect(e)}")
                 {:error, :failed}
             end

           e ->
             Logger.error("Failed to validate: #{inspect(e)}")
             {:error, :failed}
         end
    else
      false ->
           {:ok, true}
    end
  end

  def get_address_balance(public_address, token_address) do
    with true <- Application.get_env(:docker_stake_service, :blockchain_service_enabled) do
      body =
        %{public_address: public_address, token_address: token_address}
        |> Poison.encode!()

      get_service_base_url() <> "account/balance"
      |> HTTPoison.post(body, get_headers())
      |> case do
           {:ok, %{status_code: 200, body: body}} ->
             with %{"address" => address, "balance" => balance} <- body |> Poison.decode!() do
               {:ok, %{public_address: String.downcase(address), balance: balance}}
             else
               e ->
                 Logger.error("Failed to get address balance: #{inspect(e)}")
                 {:error, :failed}
             end

           e ->
             Logger.error("Failed to get address balance: #{inspect(e)}")
             {:error, :failed}
         end
     else
      false ->
        {:ok, %{public_address: String.downcase(public_address), balance: 1000}}
     end
  end

  defp get_service_base_url() do
    Application.get_env(:docker_stake_service, :blockchain_service_url)
  end

  defp get_headers() do
    [{"Content-type", "application/json"}]
  end
end
