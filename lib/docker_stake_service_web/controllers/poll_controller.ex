defmodule DockerStakeServiceWeb.PollController do
  use DockerStakeServiceWeb, :controller

  alias DockerStakeService.Poll

  @eth_token_id "8bb6fd41-dc57-405f-87da-e372bc511efe"

  def create_poll(conn, %{"poll_id" => poll_id, "title" => title, "options" => options} = p) do
    user_id = get_user_id(conn.assigns.docker_stake_service_claims)
    with {:ok, poll, user_vote} <- Poll.create_poll(poll_id, title, options, @eth_token_id, user_id) do
      conn |> put_status(:ok) |> render("show.json", poll: poll, user_vote: user_vote)
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

  def get_user_id(%{userid: user_id}), do: user_id

  def get_user_id(_), do: nil
end
