defmodule HTMLParsec.Core.Parser do
  @moduledoc false
  @callback parse(binary) :: [binary]
  @callback accumulator_key() :: binary
end
