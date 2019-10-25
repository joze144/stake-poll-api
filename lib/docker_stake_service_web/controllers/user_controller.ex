defmodule DockerStakeServiceWeb.UserController do
  use DockerStakeServiceWeb, :controller

  alias DockerStakeService.Account

  def sign_up_address(conn, %{"public_address" => public_address}) do
    with {:ok, user} <- Account.register(public_address) do
      conn |> put_status(:ok) |> render("show.json", user: user)
    else
      _ ->
        conn |> put_status(:bad_request) |> json(%{})
    end
  end

  def verify_signature(conn, %{"public_address" => public_address, "message" => _message, "signature" => _signature}) do
    with {:ok, user} <- Account.register(public_address) do
      IO.inspect(user)
      jwt = Account.generate_jwt(user)
      conn |> put_status(:ok) |> render("user_with_jwt.json", user: user, jwt: jwt)
    end
  end
end
