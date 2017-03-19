# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :cineaste,
  ecto_repos: [Cineaste.Repo]

# Configures the endpoint
config :cineaste, Cineaste.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5PY/T5LmBMluz16Sx80Vd0yMeds2RCmbFn23ioFx7/0XNawFzL+tGjWjzsq8Ej1f",
  render_errors: [view: Cineaste.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Cineaste.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# S3 URLs
config :cineaste, :s3,
  base_url: "https://s3-us-west-2.amazonaws.com/cineaste/images/",
  posters: "posters/",
  film_galleries: "galleries/films/",
  person_profiles: "profiles/person/",
  group_profiles: "profiles/group/",
  site_images: "site/",
  cast: "casts/"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
