defmodule DockerStakeService.BitlyClient do
  @moduledoc false

  @endpoint "https://api-ssl.bitly.com/v4/"
  @common_headers [{"content-type", "application/json; charset=utf-8"}]

  def shorten_url(poll_id) do
    body = %{
      long_url: Application.get_env(:docker_stake_service, :url_domain) <> "poll/" <> poll_id
    } |> Poison.encode!()

    with true <- Application.get_env(:docker_stake_service, :enable_bitly),
         headers <- @common_headers ++ [{"Authorization", "Bearer " <> Application.get_env(:docker_stake_service, :bitly_token)}],
         {:ok, %{body: body}} <- @endpoint <> "shorten" |> HTTPoison.post(body, headers),
         %{link: link} <- body |> Poison.decode!() do
      {:ok, link}
    else
      _ ->
        {:ok, Application.get_env(:docker_stake_service, :url_domain) <> "poll/" <> poll_id}
    end
  end
end
