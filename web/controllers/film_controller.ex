defmodule Cineaste.FilmController do
  use Cineaste.Web, :controller
  alias Cineaste.FilmIndexView
  alias Cineaste.Film

  def index(conn, _params) do
    film_index_views = Repo.all(Cineaste.FilmIndexView) |> Enum.sort_by(fn(view) -> FilmIndexView.sort_title(view) end) 
    render conn, "index.html", film_index_views: film_index_views
  end

  def show(conn, %{"id" => id}) do
    _find_film(conn, Ecto.UUID.cast(id))
  end
  
  defp _find_film(conn, {:ok, uuid}) do
    _render_film_page(conn, Repo.get(Film, uuid))
  end
  
  defp _find_film(conn, _) do
    _render_film_not_found_message(conn)
  end
  
  defp _render_film_page(conn, %Film{} = film) do
    film = Repo.preload(film, [:studios])
    film_staff_views = Repo.all(from view in Cineaste.FilmStaffView, where: view.film_id == ^film.id)
    |> Enum.sort_by(fn(view) -> List.first(view.staff).order end)
    render conn, "show.html", film: film, film_staff_views: film_staff_views
  end
  
  defp _render_film_page(conn, _) do
    _render_film_not_found_message(conn)
  end
  
  defp _render_film_not_found_message(conn) do
    conn
    |> put_status(404)
    |>render(Cineaste.ErrorView, :"404", message: "The thing was not found")
  end

end
