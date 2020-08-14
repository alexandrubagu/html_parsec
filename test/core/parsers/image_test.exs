defmodule HTMLParsec.Core.Parsers.ImageTest do
  use ExUnit.Case, async: true

  alias HTMLParsec.Core.Parsers.Image

  test "returns source image links" do
    assert [] == parse_image("")
    assert [] == parse_image("<img/>")
    assert ["link"] = parse_image(~s|<img src="link"/>|)
    assert ["link"] = parse_image(~s|<p>text</p><img src="link"/>|)
    assert ["link"] = parse_image(~s|<img src="link"/><p>aaaa</p>|)
    assert ["link"] = parse_image(~s|<img  src="link"/> Text|)
    assert ["link"] = parse_image(~s|<img target="_blank" src="link"/>|)
    assert ["link"] = parse_image(~s|<img src="link" rel="alternate" />|)
    assert ["link"] = parse_image(~s|<img target="_parent" src="link" rel="help">|)
  end

  defp parse_image(content) do
    content
    |> Floki.parse_fragment!()
    |> Image.parse()
  end
end
