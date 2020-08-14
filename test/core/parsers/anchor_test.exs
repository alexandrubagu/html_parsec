defmodule HTMLParsec.Core.Parsers.AnchorTest do
  use ExUnit.Case, async: true

  alias HTMLParsec.Core.Parsers.Anchor

  test "returns anchor links" do
    assert [] == parse_anchor("")
    assert [] == parse_anchor("<a>Test</a>")
    assert ["link"] = parse_anchor(~s|<a href="link"></a>|)
    assert ["link"] = parse_anchor(~s|<p>text</p><a href="link"></a>|)
    assert ["link"] = parse_anchor(~s|<a href="link"></a><p>aaaa</p>|)
    assert ["link"] = parse_anchor(~s|<a href="link">Text</a>|)
    assert ["link"] = parse_anchor(~s|<a  href="link"> Text </a> |)
    assert ["link"] = parse_anchor(~s|<a target="_blank" href="link"></a>|)
    assert ["link"] = parse_anchor(~s|<a href="link" rel="alternate">Text</a>|)
    assert ["link"] = parse_anchor(~s|<a target="_parent" href="link" rel="help">Text</a>|)
  end

  defp parse_anchor(content) do
    content
    |> Floki.parse_fragment!()
    |> Anchor.parse()
  end
end
