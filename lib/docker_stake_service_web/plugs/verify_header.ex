defmodule DockerStakeServiceWeb.Plug.VerifyHeader do
  @behaviour Plug

  @moduledoc false

  import Plug.Conn
  alias DockerStakeService.Account

  def init(opts), do: opts

  def call(conn, _) do
    with ["Bearer " <> token] <- conn |> get_req_header("authorization"),
         {:ok, claims} <- Account.verify_jwt(token) do
      assign(conn, :docker_stake_service_claims, claims)
    else
      _ -> conn |> send_resp(:unauthorized, "") |> halt
    end
  end
end
