defmodule HTMLParsec.Core.Parser do
  @moduledoc false
  @callback parse(binary) :: binary
  @callback key() :: atom
end
