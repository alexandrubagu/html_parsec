defmodule HTMLParsec.Core.Parsers.Image do
  @moduledoc false

  @behaviour HTMLParsec.Core.Parser

  @impl HTMLParsec.Core.Parser
  def key(), do: :images

  @impl HTMLParsec.Core.Parser
  def parse(html_tree), do: Floki.attribute(html_tree, "img", "src")
end
