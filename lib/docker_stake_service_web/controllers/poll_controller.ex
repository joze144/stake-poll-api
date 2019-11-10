defmodule DockerStakeServiceWeb.PollController do
  use DockerStakeServiceWeb, :controller

  alias DockerStakeService.Poll
  alias DockerStakeServiceWeb.PollRoom

  @eth_token_id "8bb6fd41-dc57-405f-87da-e372bc511efe"

  def create_poll(conn, %{"poll_id" => poll_id, "title" => title, "options" => options}) do
    user_id = get_user_id(conn.assigns.docker_stake_service_claims)
    with {:ok, poll, user_vote} <- Poll.create_poll(poll_id, title, options, @eth_token_id, user_id) do
      conn |> put_status(:ok) |> render("show.json", poll: poll, user_vote: user_vote)
    else
      _ ->
        conn |> put_status(:bad_request) |> json(%{})
    end
  end

  def get_poll(conn, %{"poll_id" => poll_id}) do
    user_id = get_user_id(conn.assigns.docker_stake_service_claims)
    with {:ok, _} <- UUID.info(poll_id),
         %{} = poll <- Poll.get_poll(poll_id, user_id) do
      conn |> put_status(:ok) |> json(poll)
    else
      nil ->
        conn |> put_status(:bad_request) |> json(%{})
    end
  end

  def get_poll_history(conn, %{"page" => page}) do
    user_id = get_user_id(conn.assigns.docker_stake_service_claims)
    data = Poll.get_poll_history(user_id, page)
    conn |> put_status(:ok) |> render("history.json", data)
  end

  def vote_on_poll(conn, %{"poll_id" => poll_id, "option_id" => poll_option_id}) do
    user_id = get_user_id(conn.assigns.docker_stake_service_claims)
    with {:ok, _} <- UUID.info(poll_id),
         {:ok, _} <- UUID.info(poll_option_id),
         {:ok, poll} <- Poll.vote_on_poll(user_id, poll_id, poll_option_id) do
      PollRoom.broadcast_pool(poll_id, Map.delete(poll, :user_vote))
      conn |> put_status(:ok) |> json(poll)
    else
      _ ->
        conn |> put_status(:bad_request) |> json(%{})
    end
  end

  def get_user_id(%{userid: user_id}), do: user_id

  def get_user_id(_), do: nil
end
