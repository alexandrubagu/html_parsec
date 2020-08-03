defmodule HTMLParsec.Web.LiveParserManager.Index do
  @moduledoc false

  use Phoenix.LiveView

  alias HTMLParsec.Core
  alias HTMLParsec.Web.ParserManagerView

  def render(assigns), do: ParserManagerView.render("index.html", assigns)

  def mount(_params, _session, socket) do
    if connected?(socket), do: Core.subscribe()
    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, urls: Core.get_urls())}
  end

  def handle_info({:parser_manager_created, _}, socket) do
    {:noreply, assign(socket, urls: Core.get_urls())}
  end
end
