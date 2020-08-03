defmodule HTMLParsec.Core do
  @moduledoc false

  alias HTMLParsec.Application
  alias HTMLParsec.Core.ParserManager

  @topic "url"
  @match_pattern {:"$1", :"$2", :_}
  @empty_guards []
  @body [{{:"$1", :"$2"}}]

  def subscribe(), do: Phoenix.PubSub.subscribe(HTMLParsec.PubSub, @topic)
  def subscribe(url), do: Phoenix.PubSub.subscribe(HTMLParsec.PubSub, "#{@topic}:#{url}")

  def fetch(url) do
    url
    |> Application.start_child()
    |> notify_subscribers(url)
  end

  def get_urls() do
    HTMLParsec.Registry
    |> Registry.select([{@match_pattern, @empty_guards, @body}])
    |> Enum.map(fn {url, _pid} -> url end)
  end

  def get_pid(url) do
    HTMLParsec.Registry
    |> Registry.select([{@match_pattern, [{:==, :"$1", url}], @body}])
    |> Enum.map(fn {_url, pid} -> pid end)
    |> List.first()
  end

  def get_links(pid), do: ParserManager.get_links(pid)
  def get_status(pid), do: ParserManager.get_status(pid)

  defp notify_subscribers({:ok, _pid}, url) do
    Phoenix.PubSub.broadcast(HTMLParsec.PubSub, @topic, {:parser_manager_created, url})
    {:ok, url}
  end

  defp notify_subscribers({:error, reason}, _event), do: {:error, reason}
end
