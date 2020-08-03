defmodule HTMLParsec.Core.Utils do
  @moduledoc false

  alias HTMLParsec.Core.Parser
  alias HTMLParsec.Core.HTTPClientAdapter

  def valid_adapter?(module), do: ensure_implements(module, HTTPClientAdapter)
  def valid_parsers?(modules), do: Enum.map(modules, &valid_parser?/1)
  def valid_parser?(module), do: ensure_implements(module, Parser)

  defp ensure_implements(module, behaviour) do
    all = Keyword.take(module.__info__(:attributes), [:behaviour])

    unless [behaviour] in Keyword.values(all) do
      raise "Expected #{inspect(module)} to implement #{inspect(behaviour)}"
    end

    module
  end
end
