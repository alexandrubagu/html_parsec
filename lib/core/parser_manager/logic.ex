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
    stream
    |> Stream.map(&apply_parsers(&1, parsers))
    |> Stream.filter(&empty_result(&1, parsers))
  end

  defp apply_parsers(line, parsers) do
    for parser <- parsers, reduce: %{} do
      acc -> Map.put(acc, parser.key, parser.parse(line))
    end
  end

  defp empty_result(data, parsers) do
    succeeded_parsers =
      for parser <- parsers, Map.get(data, parser.key) do
        parser
      end

    succeeded_parsers != []
  end
end
