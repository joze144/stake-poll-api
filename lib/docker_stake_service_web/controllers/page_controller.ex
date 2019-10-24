defmodule DockerStakeServiceWeb.PageController do
  use DockerStakeServiceWeb, :controller

  def index(conn, _params) do
    conn |> put_status(:ok) |> json(%{text: "NICE"})
  end
end
