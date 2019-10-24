defmodule DockerStakeService.Account do
  @moduledoc false

  alias DockerStakeService.UserRepo

  def register(public_address) do
    UserRepo.register(public_address)
  end

  def login(public_address) do
    with user <- UserRepo.get_by_public_address(public_address),
         true <- user != nil do
      {:ok, generate_jwt(user)}
    else
      _ ->
        {:error, :bad_attempt}
    end
  end

  def generate_jwt(%UserRepo{id: id, public_address: public_address}) do
    JsonWebToken.sign(
      %{
        userid: id,
        publicaddress: public_address,
        exp: :os.system_time(:second) + 3600 * 360 * 24
      },
      %{
        key: Application.get_env(:stake_poll_api, :jwt_secret)
      }
    )
  end

  def verify_jwt(jwt) do
    jwt
    |> JsonWebToken.verify(%{key: Application.get_env(:stake_poll_api, :jwt_secret)})
    |> case do
         {:ok, claims} ->
           %{exp: exp} = claims

           case exp >= System.system_time(:second) do
             true -> {:ok, claims}
             false -> {:error, :token_expired}
           end

         _ ->
           {:error, :invalid_token}
       end
  end
end
