defmodule HTMLParsec.Core.Parsers.Image do
  @moduledoc """
  This could be done with Flock (https://github.com/philss/floki)
  """
  @behaviour HTMLParsec.Core.Parser

  @regex ~r/<img\s+(?:[^>]*?\s+)?src="([^"]*)"/

  @impl HTMLParsec.Core.Parser
  def key(), do: :image

  @impl HTMLParsec.Core.Parser
  def parse(string) do
    case Regex.scan(@regex, string) do
      [] -> nil
      [[_, link]] -> link
    end
  end
end
