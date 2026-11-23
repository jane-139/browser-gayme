defmodule BrowserGayme.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BrowserGaymeWeb.Telemetry,
      BrowserGayme.Repo,
      {DNSCluster, query: Application.get_env(:browser_gayme, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BrowserGayme.PubSub},
      # Start a worker by calling: BrowserGayme.Worker.start_link(arg)
      # {BrowserGayme.Worker, arg},
      # Start to serve requests, typically the last entry
      BrowserGaymeWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BrowserGayme.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BrowserGaymeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
