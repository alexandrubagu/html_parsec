defmodule HTMLParsec.Core.Parsers.Anchor do
  @moduledoc """
  This could be done with Flock (https://github.com/philss/floki)
  """
  @behaviour HTMLParsec.Core.Parser

  @regex ~r/<a\s+(?:[^>]*?\s+)?href="([^"]*)"/

  @impl HTMLParsec.Core.Parser
  def key(), do: :anchor

  @impl HTMLParsec.Core.Parser
  def parse(string) do
    case Regex.scan(@regex, string) do
      [] -> nil
      [[_, link]] -> link
    end
  end
end
