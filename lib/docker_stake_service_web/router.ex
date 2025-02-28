defmodule DockerStakeServiceWeb.Router do
  use DockerStakeServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :require_jwt do
    plug(DockerStakeServiceWeb.Plug.VerifyHeader)
  end

  pipeline :optional_jwt do
    plug(DockerStakeServiceWeb.Plug.VerifyHeaderOptional)
  end

  scope "/", DockerStakeServiceWeb do
    pipe_through([:api])

    get "/", PageController, :index
    post("/sign-up-address", UserController, :sign_up_address)
    post("/verify-signature", UserController, :verify_signature)
  end

  scope "/poll", DockerStakeServiceWeb do
    pipe_through([:api, :optional_jwt])

    post("/create", PollController, :create_poll)
    post("/fetch", PollController, :get_poll)
  end

  scope "/poll", DockerStakeServiceWeb do
    pipe_through([:api, :require_jwt])

    post("/vote", PollController, :vote_on_poll)
    post("/history", PollController, :get_poll_history)
  end
end
