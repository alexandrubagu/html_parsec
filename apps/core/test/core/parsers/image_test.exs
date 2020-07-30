defmodule HTMLParsec.Core.Parsers.ImageTest do
  use ExUnit.Case, async: true

  alias HTMLParsec.Core.Parsers.Image

  test "returns source image links" do
    assert [] == Image.parse("")
    assert [] == Image.parse("<img/>")
    assert ["link"] = Image.parse(~s|<img src="link"/>|)
    assert ["link"] = Image.parse(~s|<p>text</p><img src="link"/>|)
    assert ["link"] = Image.parse(~s|<img src="link"/><p>aaaa</p>|)
    assert ["link"] = Image.parse(~s|<img  src="link"/> Text|)
    assert ["link"] = Image.parse(~s|<img target="_blank" src="link"/>|)
    assert ["link"] = Image.parse(~s|<img src="link" rel="alternate">Text</a>|)
    assert ["link"] = Image.parse(~s|<img target="_parent" src="link" rel="help">Text</a>|)
    assert ["link1", "link2"] = Image.parse(~s|<img src="link1"/><img src="link2"/>|)
  end
end
