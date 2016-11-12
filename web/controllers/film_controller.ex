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
    film_cast_views = Repo.all(from view in Cineaste.FilmCastView, where: view.film_id == ^film.id, order_by: view.order)
    top_billed_cast = Enum.filter(film_cast_views, fn x -> x.order < 99 end)
    other_cast = Enum.filter(film_cast_views, fn x -> x.order >= 99 end) |> Enum.sort_by(fn(view) -> view.names.sort_name end)
    film_synopsis = File.read!("web/static/assets/text/synopses/#{film.id}.txt")
    |> String.split("\n")
    |> tl
    |> Enum.map(fn x -> "<p>#{x}</p>" end)
    |> Enum.join
    render conn, "show.html", film: film, film_staff_views: film_staff_views, top_billed_cast: top_billed_cast, other_cast: other_cast, synopsis: film_synopsis
  end
  
  defp _render_film_page(conn, _) do
    _render_film_not_found_message(conn)
  end
  
  defp _render_film_not_found_message(conn) do
    conn
    |> put_status(404)
    |> render(Cineaste.ErrorView, :"404", message: "The thing was not found")
  end

end
