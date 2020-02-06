defmodule DockerStakeServiceWeb.PollController do
  use DockerStakeServiceWeb, :controller

  alias DockerStakeService.BlockchainServer
  alias DockerStakeService.{Poll, PollRepo}
  alias DockerStakeServiceWeb.PollRoom

  @eth_token_id "8bb6fd41-dc57-405f-87da-e372bc511efe"

  def create_poll(conn, %{"poll_id" => poll_id, "title" => title, "options" => options}) do
    user_id = get_user_id(conn.assigns.docker_stake_service_claims)
    options = options |> Enum.map(&validate_option/1)
    title = String.trim(title)
    with true <- length(options) > 1,
         true <- title != nil and title != "",
         {:ok, _} <- UUID.info(poll_id),
         {:ok, poll, user_vote} <- Poll.create_poll(poll_id, title, options, @eth_token_id, user_id) do
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
    public_address = get_user_public_address(conn.assigns.docker_stake_service_claims)
    with {:ok, _} <- UUID.info(poll_id),
         {:ok, _} <- UUID.info(poll_option_id),
         %{token_id: token_id} <- PollRepo.get_poll_by_id(poll_id),
         {:ok, poll} <- Poll.vote_on_poll(user_id, poll_id, poll_option_id) do
      BlockchainServer.update_account_balance(user_id, public_address, token_id)
      PollRoom.broadcast_pool(poll_id, Map.delete(poll, :user_vote))
      conn |> put_status(:ok) |> json(poll)
    else
      _ ->
        conn |> put_status(:bad_request) |> json(%{})
    end
  end

  def get_user_id(%{userid: user_id}), do: user_id

  def get_user_id(_), do: nil

  def get_user_public_address(%{publicaddress: public_address}), do: public_address

  def get_user_public_address(_), do: nil

  defp validate_option(%{"content" => c, "id" => id}) do
    c = String.trim(c)
    with {:ok, _} <- UUID.info(id),
         true <- c != nil and c != "" do
      %{"content" => c, "id" => id}
    else
      _ ->
        nil
    end
  end

  defp validate_option(_), do: nil
end
