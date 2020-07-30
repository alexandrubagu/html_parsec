defmodule HTMLParsec.Core.Parsers.Anchor do
  @moduledoc false
  @behaviour HTMLParsec.Core.Parser

  @regex ~r/<a\s+(?:[^>]*?\s+)?href="([^"]*)"/

  @impl HTMLParsec.Core.Parser
  def accumulator_key(), do: "anchors"

  @impl HTMLParsec.Core.Parser
  def parse(string) do
    case Regex.scan(@regex, string) do
      [] -> []
      result -> Enum.map(result, fn [_, link] -> link end)
    end
  end
end
