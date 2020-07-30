defmodule HTMLParsec.Core.ParserManager.LogicTest do
  use ExUnit.Case

  alias HTMLParsec.PlugTestSample
  alias HTMLParsec.Core.ParserManager.Logic
  alias HTMLParsec.Core.Parsers.Anchor
  alias HTMLParsec.Core.Parsers.Image
  alias HTMLParsec.Core.HTTPClientAdapters.Hackney

  setup_all do
    child_spec = {Plug.Cowboy, scheme: :http, plug: PlugTestSample, options: [port: 4546]}
    start_supervised(child_spec)

    :ok
  end

  @base_url "http://localhost:4546"

  describe "extract_links/3" do
    test "extracts images" do
      assert [
               %{"images" => ["link1", "link2"]},
               %{"images" => ["link3"]}
             ] = extract_links("#{@base_url}/images", _adapter = Hackney, _parsers = [Image])
    end

    test "extracts anchors" do
      assert [
               %{"anchors" => ["link1", "link2"]},
               %{"anchors" => ["link3"]}
             ] = extract_links("#{@base_url}/anchors", _adapter = Hackney, _parsers = [Anchor])
    end

    test "extracts images and anchors" do
      assert [
               %{"anchors" => ["anchor_link1"], "images" => ["image_link1.gif"]},
               %{"anchors" => ["anchor_link2"], "images" => []},
               %{"anchors" => [], "images" => ["image_link2.gif"]},
               %{"anchors" => [], "images" => []}
             ] = extract_links("#{@base_url}/combined", _adapter = Hackney, [Anchor, Image])
    end
  end

  defp extract_links(url, adapter, parsers) do
    url
    |> Logic.extract_links(adapter, parsers)
    |> Enum.into([])
  end
end
