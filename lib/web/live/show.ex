defmodule HTMLParsec.Web.LiveParserManager.Show do
  @moduledoc false

  use Phoenix.LiveView

  alias HTMLParsec.Core
  alias HTMLParsec.Web.ParserManagerView

  def render(assigns), do: ParserManagerView.render("show.html", assigns)

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"url" => url}, _url, socket) do
    decoded_url = ParserManagerView.decode(url)
    if connected?(socket), do: Core.subscribe(decoded_url)
    {:noreply, socket |> assign(url: decoded_url) |> fetch()}
  end

  defp fetch(socket) do
    pid = Core.get_pid(socket.assigns.url)
    assign(socket, status: Core.get_status(pid), links: Core.get_links(pid))
  end

  def handle_info({:parser_manager_status_update, :processing}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_info({:parser_manager_status_update, :done}, socket) do
    {:noreply, fetch(socket)}
  end
end
