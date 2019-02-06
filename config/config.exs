# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_tail,
  ecto_repos: [PhoenixTail.Repo]

# Configures the endpoint
config :phoenix_tail, PhoenixTail.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/BlaEVrlgJTKrFweM+h+vEi92KhqQ9qEwl2pjZmvQlv/vnopgQih6mgZJ3n8WfWS",
  render_errors: [view: PhoenixTail.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixTail.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
