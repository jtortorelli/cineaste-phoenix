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
    film_staff_views = Repo.all(from view in Cineaste.FilmStaffView, where: view.film_id == ^film.id)
    |> Enum.sort_by(fn(view) -> List.first(view.staff).order end)
    render conn, "show.html", film: film, film_staff_views: film_staff_views
  end

end
