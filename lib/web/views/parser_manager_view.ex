defmodule HTMLParsec.Web.ParserManagerView do
  use HTMLParsec.Web, :view

  alias HTMLParsec.Web.LiveParserManager

  def encode(url) do
    url
    |> URI.encode()
    |> Base.encode64()
  end

  def decode(url) do
    url
    |> URI.decode()
    |> Base.decode64!()
  end
end
