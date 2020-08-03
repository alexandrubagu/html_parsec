defmodule HTMLParsec.Core.HTTPClientAdapter do
  @moduledoc false
  @callback fetch(url :: binary) :: stream :: fun
end
