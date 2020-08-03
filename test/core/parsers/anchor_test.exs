defmodule HTMLParsec.Core.Parsers.AnchorTest do
  use ExUnit.Case, async: true

  alias HTMLParsec.Core.Parsers.Anchor

  test "returns anchor links" do
    assert nil == Anchor.parse("")
    assert nil == Anchor.parse("<a>Test</a>")
    assert "link" = Anchor.parse(~s|<a href="link"></a>|)
    assert "link" = Anchor.parse(~s|<p>text</p><a href="link"></a>|)
    assert "link" = Anchor.parse(~s|<a href="link"></a><p>aaaa</p>|)
    assert "link" = Anchor.parse(~s|<a href="link">Text</a>|)
    assert "link" = Anchor.parse(~s|<a  href="link"> Text </a> |)
    assert "link" = Anchor.parse(~s|<a target="_blank" href="link"></a>|)
    assert "link" = Anchor.parse(~s|<a href="link" rel="alternate">Text</a>|)
    assert "link" = Anchor.parse(~s|<a target="_parent" href="link" rel="help">Text</a>|)
  end
end
