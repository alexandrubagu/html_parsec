# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :html_parsec,
  namespace: HTMLParsec

# Configures the endpoint
config :html_parsec, HTMLParsec.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "S7a6D2GAxKRdL0DiZpNvgeA5L0vu0MzC+E++NYTSN/UFPESovGYHJTJii0Li33y/",
  render_errors: [view: HTMLParsec.Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: HTMLParsec.PubSub,
  live_view: [signing_salt: "EHdvOQMr"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :html_parsec,
  adapter: HTMLParsec.Core.HTTPClientAdapters.Hackney,
  parsers: [HTMLParsec.Core.Parsers.Anchor, HTMLParsec.Core.Parsers.Image]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
