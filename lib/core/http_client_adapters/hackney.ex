defmodule HTMLParsec.Core.HTTPClientAdapters.Hackney do
  @moduledoc false

  @behaviour HTMLParsec.Core.HTTPClientAdapter

  @impl HTMLParsec.Core.HTTPClientAdapter
  def fetch(url) do
    Stream.resource(
      fn -> start_fn(url) end,
      &next_fn/1,
      &stop_fn/1
    )
  end

  defp start_fn(url) do
    case :hackney.request(:get, url, [], "", [{:async}]) do
      {:ok, _status, _headers, ref} -> ref
      {:ok, _status, _headers} -> make_ref()
      {:error, error} -> raise "#{inspect(error)}"
    end
  end

  defp next_fn(ref) do
    case :hackney.stream_body(ref) do
      {:ok, fragment} -> {Floki.parse_fragment!(fragment), ref}
      :done -> {:halt, ref}
      {:error, _} -> {:halt, ref}
    end
  end

  defp stop_fn(ref), do: :hackney.stop_async(ref)
end
