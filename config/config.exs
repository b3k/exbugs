# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :exbugs, Exbugs.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "L4KzZhcxHHokjRkEg5qozVvOWRRL+wJKHmg11XPB+7MTxrMPSpQ21LnGbqX/4ds0",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Exbugs.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

# Configure template engines
config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

# Configure default locale
config :exbugs, Exbugs.Gettext, default_locale: "en"

# Configure scrivener_html
config :scrivener_html,
  routes_helper: Exbugs.Router.Helpers

# Configure guardian
config :guardian, Guardian,
  issuer: "Exbugs",
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: "lksdjowiurowieurlkjsdlwwer",
  serializer: Exbugs.GuardianSerializer
