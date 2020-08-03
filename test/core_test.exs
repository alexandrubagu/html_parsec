defmodule HTMLParsec.CoreTest do
  use ExUnit.Case

  alias HTMLParsec.Core
  alias HTMLParsec.Core.Parsers.Anchor
  alias HTMLParsec.Core.Parsers.Image
  alias HTMLParsec.Core.HTTPClientAdapters.Hackney

  alias HTMLParsec.PlugTestSample
  alias HTMLParsec.Core.Parsers.Anchor
  alias HTMLParsec.Core.Parsers.Image
  alias HTMLParsec.Core.HTTPClientAdapters.Hackney
  alias HTMLParsec.Core.ParserManager

  @adapter Hackney
  @parsers [Anchor, Image]
  @anchors_url "http://localhost:4546/anchors"
  @images_url "http://localhost:4546/images"

  setup_all do
    child_spec = {Plug.Cowboy, scheme: :http, plug: PlugTestSample, options: [port: 4546]}
    start_supervised!(child_spec)
    :ok
  end

  describe "get_urls/1" do
    setup do
      manager1 = {ParserManager, [url: @anchors_url, adapter: @adapter, parsers: @parsers]}
      manager2 = {ParserManager, [url: @images_url, adapter: @adapter, parsers: @parsers]}

      start_supervised!(manager1)
      start_supervised!(manager2)

      :ok
    end

    test "returns a list of active parser managers" do
      assert [
               "http://localhost:4546/anchors",
               "http://localhost:4546/images"
             ] == Core.get_urls()
    end
  end

  describe "get_pid/1" do
    setup do
      manager = {ParserManager, [url: @anchors_url, adapter: @adapter, parsers: @parsers]}
      pid = start_supervised!(manager)

      {:ok, parser_manager_pid: pid}
    end

    test "returns the pid of parser managers for a given url", %{parser_manager_pid: pid} do
      assert pid == Core.get_pid(@anchors_url)
    end

    test "returns a list of active parser managers" do
      refute Core.get_pid("unknown_url")
    end
  end
end
