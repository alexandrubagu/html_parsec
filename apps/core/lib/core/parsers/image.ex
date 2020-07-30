defmodule HTMLParsec.Core.Parsers.Image do
  @moduledoc false
  @behaviour HTMLParsec.Core.Parser

  @regex ~r/<img\s+(?:[^>]*?\s+)?src="([^"]*)"/

  @impl HTMLParsec.Core.Parser
  def accumulator_key(), do: "images"

  @impl HTMLParsec.Core.Parser
  def parse(string) do
    case Regex.scan(@regex, string) do
      [] -> []
      result -> Enum.map(result, fn [_, link] -> link end)
    end
  end
end
