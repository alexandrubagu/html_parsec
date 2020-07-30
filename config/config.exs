import Config

config :core,
  adapter: HTMLParsec.Core.HTTPClientAdapters.Hackney,
  parsers: [HTMLParsec.Core.Parsers.Anchor, HTMLParsec.Core.Parsers.Image]

import_config "#{Mix.env()}.exs"
