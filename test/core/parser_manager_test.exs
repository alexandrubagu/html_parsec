defmodule HTMLParsec.Core.ParserManagerTest do
  use ExUnit.Case

  alias HTMLParsec.PlugTestSample
  alias HTMLParsec.Core.Parsers.Anchor
  alias HTMLParsec.Core.Parsers.Image
  alias HTMLParsec.Core.HTTPClientAdapters.Hackney
  alias HTMLParsec.Core.ParserManager

  @adapter Hackney
  @parsers [Anchor, Image]
  @url "http://localhost:4545/combined"

  setup_all do
    child_spec = {Plug.Cowboy, scheme: :http, plug: PlugTestSample, options: [port: 4545]}
    start_supervised!(child_spec)
    :ok
  end

  describe "get_links/1" do
    setup do
      manager_child_spec = {ParserManager, [url: @url, adapter: @adapter, parsers: @parsers]}
      {:ok, parser_manager_pid: start_supervised!(manager_child_spec)}
    end

    test "returns parsed links after processing is done", %{parser_manager_pid: pid} do
      wait_until_processing_is_done(pid)

      assert %{
               anchor: ["anchor_link2", "anchor_link1"],
               image: ["image_link2.gif", "image_link1.gif"]
             } == ParserManager.get_links(pid)
    end
  end

  defp wait_until_processing_is_done(pid) do
    unless ParserManager.get_status(pid) == :done,
      do: wait_until_processing_is_done(pid)
  end
end
