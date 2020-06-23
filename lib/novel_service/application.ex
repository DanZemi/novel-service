defmodule NovelService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      NovelService.Repo,
      # Start the Telemetry supervisor
      NovelServiceWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: NovelService.PubSub},
      # Start the Endpoint (http/https)
      NovelServiceWeb.Endpoint
      # Start a worker by calling: NovelService.Worker.start_link(arg)
      # {NovelService.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NovelService.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NovelServiceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
