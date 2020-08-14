defmodule HTMLParsec.Core.Parser do
  @moduledoc false
  @callback parse(Floki.html_tree()) :: [binary]
  @callback key() :: atom
end
