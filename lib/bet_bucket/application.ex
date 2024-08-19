defmodule BetBucket.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BetBucketWeb.Telemetry,
      BetBucket.Repo,
      {DNSCluster, query: Application.get_env(:bet_bucket, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BetBucket.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BetBucket.Finch},
      # Start a worker by calling: BetBucket.Worker.start_link(arg)
      # {BetBucket.Worker, arg},
      # Start to serve requests, typically the last entry
      BetBucketWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BetBucket.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BetBucketWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
