defmodule HTMLParsec.Web.LiveParserManager.New do
  @moduledoc false

  use Phoenix.LiveView

  alias HTMLParsec.Web.LiveParserManager
  alias HTMLParsec.Core
  alias HTMLParsec.Web.ParserManagerView
  alias HTMLParsec.Web.Router.Helpers, as: Routes

  def render(assigns), do: ParserManagerView.render("new.html", assigns)

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("save", %{"url" => url}, socket) do
    case Core.fetch(url) do
      {:ok, url} ->
        encoded_url = ParserManagerView.encode(url)

        {:noreply,
         redirect(socket, to: Routes.live_path(socket, LiveParserManager.Show, encoded_url))}

      {:error, _error} ->
        {:noreply, put_flash(socket, :danger, "can't create process manager")}
    end
  end
end
