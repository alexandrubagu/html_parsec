defmodule HTMLParsec.Core.Parsers.Anchor do
  @moduledoc """
  This could be done with Flock (https://github.com/philss/floki)
  """
  @behaviour HTMLParsec.Core.Parser

  @regex ~r/<a\s+(?:[^>]*?\s+)?href="([^"]*)"/

  @impl HTMLParsec.Core.Parser
  def key(), do: :anchor

  @doc """
  Assuming the html will be properly formatted (one tag per line)
  """
  @impl HTMLParsec.Core.Parser
  def parse(string) do
    case Regex.scan(@regex, string) do
      [] -> nil
      [data | _] -> List.last(data)
    end
  end
end
