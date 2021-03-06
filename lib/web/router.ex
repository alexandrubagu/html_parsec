defmodule HTMLParsec.Web.Router do
  use HTMLParsec.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HTMLParsec.Web.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HTMLParsec.Web do
    pipe_through :browser

    live "/", LiveParserManager.Index
    live "/parser-managers/new", LiveParserManager.New
    live "/parser-managers/:url", LiveParserManager.Show
  end

  # Other scopes may use custom stacks.
  # scope "/api", HTMLParsec.Web do
  #   pipe_through :api
  # end
end
