defmodule Cineaste.FilmController do
  use Cineaste.Web, :controller
  alias Cineaste.FilmIndexView

  def index(conn, _params) do
    film_index_views = Repo.all(Cineaste.FilmIndexView) |> Enum.sort_by(fn(view) -> FilmIndexView.sort_title(view) end) 
    render conn, "index.html", film_index_views: film_index_views
  end

  def show(conn, %{"id" => id}) do
    render conn, "show.html", id: id
  end

end
