defmodule BskyBots.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BskyBotsWeb.Telemetry,
      BskyBots.Repo,
      {DNSCluster, query: Application.get_env(:bsky_bots, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BskyBots.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BskyBots.Finch},
      # Start a worker by calling: BskyBots.Worker.start_link(arg)
      # {BskyBots.Worker, arg},
      # Start to serve requests, typically the last entry
      BskyBotsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BskyBots.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BskyBotsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
