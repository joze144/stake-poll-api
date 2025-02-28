defmodule DockerStakeService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      DockerStakeService.Repo,
      # Starts a worker by calling: DockerStakeService.Worker.start_link(arg)
      worker(DockerStakeService.BlockchainServer, [[name: DockerStakeService.BlockchainServer]]),
      # Start the endpoint when the application starts
      DockerStakeServiceWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DockerStakeService.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DockerStakeServiceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
