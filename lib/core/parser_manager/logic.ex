defmodule HTMLParsec.Core.ParserManager.Logic do
  @moduledoc false

  defstruct [:response, data: %{}]

  def extract_links(url, adapter, parsers) do
    url
    |> fetch_content(adapter)
    |> extract_data(parsers)
  end

  defp fetch_content(url, adapter), do: adapter.fetch(url)

  defp extract_data(stream, parsers) do
    Stream.map(stream, &apply_parsers(&1, parsers))
  end

  defp apply_parsers(html_tree, parsers) do
    for parser <- parsers, reduce: %{} do
      acc -> Map.put(acc, parser.key, parser.parse(html_tree))
    end
  end
end
