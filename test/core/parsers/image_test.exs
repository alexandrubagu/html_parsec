defmodule HTMLParsec.Core.Parsers.ImageTest do
  use ExUnit.Case, async: true

  alias HTMLParsec.Core.Parsers.Image

  test "returns source image links" do
    assert nil == Image.parse("")
    assert nil == Image.parse("<img/>")
    assert "link" = Image.parse(~s|<img src="link"/>|)
    assert "link" = Image.parse(~s|<p>text</p><img src="link"/>|)
    assert "link" = Image.parse(~s|<img src="link"/><p>aaaa</p>|)
    assert "link" = Image.parse(~s|<img  src="link"/> Text|)
    assert "link" = Image.parse(~s|<img target="_blank" src="link"/>|)
    assert "link" = Image.parse(~s|<img src="link" rel="alternate" />|)
    assert "link" = Image.parse(~s|<img target="_parent" src="link" rel="help">|)
  end
end
