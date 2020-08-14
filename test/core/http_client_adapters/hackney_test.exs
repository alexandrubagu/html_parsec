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
      assert ["Hello\nworld!"] == fetch("http://localhost:4545")
    end

    test "returns an error if something went wrong" do
      assert_raise RuntimeError, fn ->
        fetch("http://hahaha-boom.abc.org")
      end
    end
  end

  defp fetch(url) do
    url
    |> Hackney.fetch()
    |> Enum.into([])
  end
end
