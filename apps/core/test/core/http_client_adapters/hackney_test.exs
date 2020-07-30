defmodule HTMLParsec.Core.HTTPClientAdapters.HackneyTest do
  use ExUnit.Case

  alias HTMLParsec.PlugTestSample
  alias HTMLParsec.Core.HTTPClientAdapters.Hackney

  setup_all do
    child_spec = {Plug.Cowboy, scheme: :http, plug: PlugTestSample, options: [port: 4545]}
    start_supervised(child_spec)

    :ok
  end

  describe "fetch/1" do
    test "returns a stream with values separated by line" do
      assert ["Hello", "world!"] == fetch("http://localhost:4545")
    end

    test "returns an empty list if something went wrong" do
      assert [] == fetch("http://unknown_route.unknown_route")
    end
  end

  defp fetch(url) do
    url
    |> Hackney.fetch()
    |> Enum.into([])
  end
end
