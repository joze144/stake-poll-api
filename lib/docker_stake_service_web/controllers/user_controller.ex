defmodule DockerStakeServiceWeb.UserController do
  use DockerStakeServiceWeb, :controller

  alias DockerStakeService.Account
  alias DockerStakeService.Blockchain.BlockchainClient
  alias DockerStakeService.BlockchainServer
  alias DockerStakeService.UserBalanceRepo

  @eth_token_id "8bb6fd41-dc57-405f-87da-e372bc511efe"

  def sign_up_address(conn, %{"public_address" => public_address}) do
    with {:ok, user} <- Account.register(public_address) do
      conn |> put_status(:ok) |> render("show.json", user: user)
    else
      _ ->
        conn |> put_status(:bad_request) |> json(%{})
    end
  end

  def verify_signature(conn, %{"public_address" => public_address, "message" => message, "signature" => signature}) do
    with {:ok, true} <- BlockchainClient.verify_signature(public_address, signature, message),
         {:ok, %{id: user_id} = user} <- Account.register(public_address) do
      BlockchainServer.update_account_balance(user_id, public_address, @eth_token_id)
      jwt = Account.generate_jwt(user)
      balances = UserBalanceRepo.get_user_balances(user_id)
      conn |> put_status(:ok) |> render("user_with_jwt.json", user: user, jwt: jwt, balances: balances)
    end
  end
end
