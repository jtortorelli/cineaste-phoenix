defmodule Cineaste.FilmController do
  use Cineaste.Web, :controller
  alias Cineaste.FilmIndexView
  alias Cineaste.Film

  def index(conn, _params) do
    film_index_views = Repo.all(Cineaste.FilmIndexView) |> Enum.sort_by(fn(view) -> FilmIndexView.sort_title(view) end) 
    render conn, "index.html", film_index_views: film_index_views
  end

  def show(conn, %{"id" => id}) do
    film = Repo.get!(Film, id)
    render conn, "show.html", film: film
  end

end
