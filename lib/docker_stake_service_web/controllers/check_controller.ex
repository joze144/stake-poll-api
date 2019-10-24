defmodule DockerStakeServiceWeb.CheckController do
  use DockerStakeServiceWeb, :controller

  def check(conn, param) do
    IO.inspect(conn)
    IO.inspect(param)
    conn |> put_status(:ok) |> json(%{})
  end
end
