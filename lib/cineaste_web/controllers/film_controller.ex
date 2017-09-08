defmodule CineasteWeb.FilmController do
  use Cineaste.Web, :controller
  alias Cineaste.FilmIndexView
  alias Cineaste.FilmStaffView
  alias Cineaste.FilmCastView
  alias CineasteWeb.ErrorView
  alias CineasteWeb.S3View
  alias Cineaste.Film
  alias Cineaste.FilmImage
  alias CineasteWeb.FilmMonitor
  require Logger

  NimbleCSV.define(MyParser, [])


  def index(conn, _params) do
    film_index_views = Repo.all(FilmIndexView) |> Enum.sort_by(fn(view) -> FilmIndexView.sort_title(view) end)
    FilmMonitor.set_state(film_index_views)
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

    film_staff_views = Repo.all(from view in FilmStaffView, where: view.film_id == ^film.id)
    |> Enum.sort_by(fn(view) -> List.first(view.staff).order end)

    film_image_names = Repo.all(from image in FilmImage, where: image.film_id == ^film.id and image.type == "gallery", order_by: image.file_name)
    |> Enum.map(fn(x) -> x.file_name end)

    has_gallery = not Enum.empty?(film_image_names)

    film_cast_views = Repo.all(from view in FilmCastView, where: view.film_id == ^film.id, order_by: view.order)

    top_billed_cast = Enum.filter(film_cast_views, fn x -> x.order < 99 end)

    other_cast = Enum.filter(film_cast_views, fn x -> x.order >= 99 end) |> Enum.sort_by(fn(view) -> view.names.sort_name end)

    has_cast = not Enum.empty?(Enum.concat(top_billed_cast, other_cast))

    film_synopsis = HTTPoison.get!(S3View.get_film_synopsis_url(film.id)).body
    |> Earmark.as_html!

    credits = _get_film_credits(HTTPoison.get!(S3View.get_film_credits_url(film.id)))

    render conn, "show.html", film: film, film_staff_views: film_staff_views, top_billed_cast: top_billed_cast, other_cast: other_cast, has_cast: has_cast, synopsis: film_synopsis, gallery_images: film_image_names, has_gallery: has_gallery, credits: credits
  end

  defp _render_film_page(conn, _) do
    _render_film_not_found_message(conn)
  end

  defp _render_film_not_found_message(conn) do
    conn
    |> put_status(404)
    |> render(ErrorView, :"404", message: "The thing was not found")
  end

  defp _get_film_credits(%HTTPoison.Response{status_code: 200, body: body}) do
    MyParser.parse_string(body, headers: false)
    |> Enum.map(fn[a,b,c,d] -> "| #{a}<br/>#{c} | #{b}<br/>#{d} |" end)
    |> Enum.join("\n")
    |> Earmark.as_html!
    |> String.replace("<table>", "<table class=\"table table-nonfluid table-striped\">")
  end

  defp _get_film_credits(_) do
    nil
  end

end
