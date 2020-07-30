defmodule HTMLParsec.Core.ParserManager.Logic do
  @moduledoc false

  defstruct [:response, data: %{}]

  def extract_links(url, adapter, parsers) do
    acc = initialize_accumulator(parsers)

    url
    |> fetch_content(adapter)
    |> extract_data(parsers, acc)
  end

  defp initialize_accumulator(parsers) do
    for parser <- parsers, into: %{}, do: {parser.accumulator_key, []}
  end

  defp fetch_content(url, adapter), do: adapter.fetch(url)

  defp extract_data(stream, parsers, acc) do
    Stream.map(stream, &apply_parsers(&1, parsers, acc))
  end

  defp apply_parsers(line, parsers, acc) do
    Enum.reduce(parsers, acc, fn parser, acc ->
      Map.put(acc, parser.accumulator_key, acc[parser.accumulator_key] ++ parser.parse(line))
    end)
  end
end
