defmodule HTMLParsec.Core.Application do
  @moduledoc false

  use Application

  import HTMLParsec.Core.Utils

  @adapter Application.compile_env!(:core, :adapter)
  @parsers Application.compile_env!(:core, :parsers)

  valid_adapter?(@adapter)
  valid_parsers?(@parsers)

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: HTMLParsec.Core.DynamicSupervisor}
    ]

    opts = [strategy: :one_for_one, name: Core.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_child(url) do
    spec = {HTMLParsec.Core.ParserManager, url: url, adapter: @adapter, parsers: @parsers}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
