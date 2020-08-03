defmodule HTMLParsec.Application do
  @moduledoc false

  use Application

  import HTMLParsec.Core.Utils

  @adapter Application.compile_env!(:html_parsec, :adapter)
  @parsers Application.compile_env!(:html_parsec, :parsers)

  valid_adapter?(@adapter)
  valid_parsers?(@parsers)

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: HTMLParsec.DynamicSupervisor},
      {Registry, keys: :unique, name: HTMLParsec.Registry},
      HTMLParsec.Web.Telemetry,
      {Phoenix.PubSub, name: HTMLParsec.PubSub},
      HTMLParsec.Web.Endpoint
    ]

    opts = [strategy: :one_for_one, name: HTMLParsec.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    HTMLParsec.Web.Endpoint.config_change(changed, removed)
    :ok
  end

  def start_child(url) do
    spec = {HTMLParsec.Core.ParserManager, [url: url, adapter: @adapter, parsers: @parsers]}
    DynamicSupervisor.start_child(HTMLParsec.DynamicSupervisor, spec)
  end
end
