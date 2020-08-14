defmodule HTMLParsec.Core.Parsers.Anchor do
  @moduledoc false

  @behaviour HTMLParsec.Core.Parser

  @impl HTMLParsec.Core.Parser
  def key(), do: :anchors

  @impl HTMLParsec.Core.Parser
  def parse(html_tree), do: Floki.attribute(html_tree, "a", "href")
end
