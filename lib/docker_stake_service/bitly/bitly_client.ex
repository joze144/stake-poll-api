defmodule DockerStakeService.BitlyClient do
  @moduledoc false

  require Logger

  @endpoint "https://api-ssl.bitly.com/v4/"
  @common_headers [{"content-type", "application/json; charset=utf-8"}]

  def shorten_url(poll_id) do
    body = %{
      long_url: Application.get_env(:docker_stake_service, :url_domain) <> "poll/" <> poll_id
    } |> Poison.encode!()

    with true <- Application.get_env(:docker_stake_service, :enable_bitly) |> IO.inspect(),
         headers <- @common_headers ++ [{"Authorization", "Bearer " <> Application.get_env(:docker_stake_service, :bitly_token)}],
         {:ok, %{body: body}} <- @endpoint <> "shorten" |> HTTPoison.post(body, headers) |> IO.inspect(),
         %{link: link} <- body |> Poison.decode!() do
      {:ok, link}
    else
      false ->
        {:ok, Application.get_env(:docker_stake_service, :url_domain) <> "poll/" <> poll_id}

      e ->
        Logger.error("#{inspect(e)}")
        {:ok, Application.get_env(:docker_stake_service, :url_domain) <> "poll/" <> poll_id}
    end
  end
end
