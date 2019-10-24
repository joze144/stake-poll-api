defmodule DockerStakeServiceWeb.PollController do
  use DockerStakeServiceWeb, :controller

  alias DockerStakeService.Poll

  @eth_token_id "8bb6fd41-dc57-405f-87da-e372bc511efe"

  def create_poll(conn, %{"poll_id" => poll_id, "title" => title, "options" => options}) do
    with {:ok, poll} <- Poll.create_poll(poll_id, title, options, @eth_token_id) do
      conn |> put_status(:ok) |> render("show.json", poll: poll)
    else
      _ ->
        conn |> put_status(:bad_request) |> json(%{})
    end
  end

  def get_poll(conn, param) do


    conn |> put_status(:ok) |> json(%{})
  end

  def vote_on_poll(conn, param) do

  end
end
