defmodule HTMLParsec.Core do
  @moduledoc false

  alias HTMLParsec.Application

  def fetch(url), do: Application.start_child(url)
  def get_urls(), do: Registry.lookup(HTMLParsec.Registry, "url")
end
