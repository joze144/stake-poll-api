defmodule DockerStakeServiceWeb.UserSocket do
  use Phoenix.Socket
  require Logger

  ## Channels
  channel "private:*", DockerStakeServiceWeb.UserRoom
  channel "poll:*", DockerStakeServiceWeb.PollRoom

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(params, socket, _connect_info) do
    with true <- Map.has_key?(params, "token"),
         true <- params["token"] != nil and params["token"] != "",
         {:ok, claims} <- JsonWebToken.verify(params["token"], %{
           key: Application.get_env(:docker_stake_service, :jwt_secret)
         }) do
      if claims.exp < :os.system_time(:seconds) do
        Logger.info("user #{claims.userid} attempt connecting with expire token")
        :error
      else
        {:ok, assign(socket, :user_id, claims.userid)}
      end
    else
      false ->
        {:ok, socket}

      e ->
        Logger.error("JsonWebToken.verify error = #{e}, token = #{params["token"]}")
        :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     DockerStakeServiceWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
