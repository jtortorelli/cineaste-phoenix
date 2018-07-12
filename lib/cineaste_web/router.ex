defmodule CineasteWeb.Router do
  use Cineaste.Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", CineasteWeb do
    # Use the default browser stack
    pipe_through(:browser)

    # get "/", PageController, :index
    get("/", HomeController, :index)
    get("/films", FilmController, :index)
    get("/films/:id", FilmController, :show)
    get("/people", PeopleController, :index)
    get("/people/person/:id", PeopleController, :show_person)
    get("/people/group/:id", PeopleController, :show_group)
    get("/about", AboutController, :index)
  end

  # Other scopes may use custom stacks.
  # scope "/api", Cineaste do
  #   pipe_through :api
  # end
end
