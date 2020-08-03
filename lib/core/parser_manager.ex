defmodule HTMLParsec.Core.ParserManager do
  @moduledoc false

  use GenServer
  alias HTMLParsec.Core.ParserManager.Logic

  @timer :timer.seconds(1)

  defstruct [:url, :adapter, :parsers, :status, links: %{}]

  def child_spec(opts) do
    url = Keyword.fetch!(opts, :url)

    %{
      id: url,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(opts) do
    url = Keyword.fetch!(opts, :url)
    name = {:via, Registry, {HTMLParsec.Registry, url}}
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  def init(opts) do
    state =
      %__MODULE__{
        url: Keyword.fetch!(opts, :url),
        adapter: Keyword.fetch!(opts, :adapter),
        parsers: Keyword.fetch!(opts, :parsers)
      }
      |> mark_as_processing()

    Process.send_after(self(), :process_url, @timer)

    {:ok, state}
  end

  def get_links(pid), do: GenServer.call(pid, :get_links)
  def get_status(pid), do: GenServer.call(pid, :get_status)

  def handle_call(:get_links, _from, state), do: {:reply, state.links, state}
  def handle_call(:get_status, _from, state), do: {:reply, state.status, state}

  def handle_info(:process_url, state) do
    state =
      state
      |> extract_links()
      |> summarize_links(state)
      |> mark_as_done()

    {:noreply, state}
  end

  defp extract_links(state), do: Logic.extract_links(state.url, state.adapter, state.parsers)

  defp summarize_links(stream, state) do
    Enum.reduce_while(stream, state, fn
      nil, acc -> {:halt, acc}
      data, acc -> {:cont, group_links_into_state_and_emit_events(data, acc)}
    end)
  end

  defp group_links_into_state_and_emit_events(data, %{links: links} = state) do
    new_links =
      Enum.reduce(data, links, fn
        {_parser_key, nil}, acc ->
          acc

        {parser_key, value}, acc ->
          previous_links = Map.get(acc, parser_key) || [value]
          Map.update(acc, parser_key, previous_links, &[value | &1])
      end)

    %{state | links: new_links}
  end

  defp mark_as_processing(state), do: %{state | status: :processing} |> notify_subscribers()
  defp mark_as_done(state), do: %{state | status: :done} |> notify_subscribers

  defp notify_subscribers(state) do
    Phoenix.PubSub.broadcast(
      HTMLParsec.PubSub,
      "url:#{state.url}",
      {:parser_manager_status_update, state.status}
    )

    state
  end
end
