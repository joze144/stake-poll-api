defmodule DockerStakeServiceWeb.Plug.VerifyHeaderOptional do
  @behaviour Plug

  import Plug.Conn
  alias DockerStakeService.Account

  def init(opts), do: opts

  def call(conn, _) do
    with ["Bearer " <> token] <- conn |> get_req_header("authorization"),
         {:ok, claims} <- Account.verify_jwt(token) do
      assign(conn, :select_chat_jwt_claims, claims)
    else
      _ ->
        assign(conn, :select_chat_jwt_claims, %{})
    end
  end
end
