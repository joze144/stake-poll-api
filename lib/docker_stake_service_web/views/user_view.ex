defmodule DockerStakeServiceWeb.UserView do
  use DockerStakeServiceWeb, :view

  def render("show.json", %{user: user}) do
    user
    |> Map.from_struct()
    |> Map.take([:id, :public_address])
  end

  def render("user_with_jwt.json", %{user: user, jwt: jwt}) do
    "show.json"
    |> render(%{user: user})
    |> Map.merge(%{jwt_token: "Bearer " <> jwt})
  end
end
