defmodule Cineaste.FilmView do
  use Cineaste.Web, :view
  alias Ecto
  import Ecto.Query
  alias Cineaste.Repo
  alias Cineaste.Film
  alias Cineaste.SeriesFilm
  alias Cineaste.FilmImage
  alias Cineaste.CommonView
  require Logger

  def sorted_staff(staff), do: Enum.sort_by(staff, fn(x) -> x.order end)

  def display_original_title(%{"original_title" => title, "original_transliteration" => transliteration, "original_translation" => translation} = props) do
    Logger.debug "inside display_original_title"
    Logger.debug "value of props: #{inspect(props)}"
    render "original_title.html", title: title, transliteration: transliteration, translation: translation
  end

  def display_original_title(_), do: nil

  def display_aliases([_head | _tail] = aliases), do: CommonView.render_aliases_table_row(aliases)
  def display_aliases(_), do: nil

  def display_release_date(date), do: Timex.format!(date, "{Mfull} {D}, {YYYY}")

  def display_series_info(conn, %Film{} = film), do: _display_series_info(conn, Repo.preload(film, [:series]))
  defp _display_series_info(conn, %Film{:series => [_h|_t]} = film) do
    series = List.first(film.series)
    series_film = Repo.one(from s in SeriesFilm, where: s.film_id == ^film.id and s.series_id == ^series.id)
    {:safe, antecedent_template} = Repo.one(from s in SeriesFilm, where: s.series_id == ^series.id and s.order == ^(series_film.order - 1)) |> _display_series_antecedent(conn)
    {:safe, subsequent_template} = Repo.one(from s in SeriesFilm, where: s.series_id == ^series.id and s.order == ^(series_film.order + 1)) |> _display_series_subsequent(conn)
    raw "#{antecedent_template}#{subsequent_template}"
  end

  defp _display_series_info(_, _), do: nil

  defp _display_series_antecedent(%SeriesFilm{} = series_film, conn) do
    film = Repo.preload(series_film, [:film]).film
    if film.showcase do
      render "series_antecedent_with_link.html", film: film, conn: conn
    else
      render "series_antecedent.html", film: film
    end
  end

  defp _display_series_antecedent(_, _), do: {:safe, ""}

  defp _display_series_subsequent(%SeriesFilm{} = series_film, conn) do
    film = Repo.preload(series_film, [:film]).film
    if film.showcase do
      render "series_subsequent_with_link.html", film: film, conn: conn
    else
      render "series_subsequent.html", film: film
    end
  end

  defp _display_series_subsequent(_, _), do: {:safe, ""}

  def render_top_billed_cast(conn, [_h|_t] = top_billed_cast) do
    render "top_billed_cast.html", conn: conn, top_billed_cast: top_billed_cast
  end

  def render_top_billed_cast(_, _), do: nil

  def render_other_cast(conn, [_h|_t] = other_cast) do
    render "other_cast.html", conn: conn, other_cast: other_cast
  end

  def render_other_cast(_, _), do: nil

  def render_gallery(film_id) do
    s3_gallery_url = Application.get_env(:cineaste, :s3)[:base_url] <> Application.get_env(:cineaste, :s3)[:film_galleries]
    file_names = Repo.all(from image in FilmImage, where: image.film_id == ^film_id and image.type == "gallery", order_by: image.file_name)
    |> Enum.map(fn(x) -> x.file_name end)
    full_url = s3_gallery_url <> film_id <> "/full/"
    thumb_url = s3_gallery_url <> film_id <> "/thumbs/"
    render "gallery.html", film_id: film_id, file_names: file_names, full_url: full_url, thumb_url: thumb_url
  end

  def render_poster(film_id) do
    s3_poster_url = Application.get_env(:cineaste, :s3)[:base_url] <> Application.get_env(:cineaste, :s3)[:posters]
    s3_poster_url <> film_id <> ".jpg"
  end

  def render_people_link(conn, %{entity_id: id, names: %{display_name: text}, showcase: true, type: "person"}) do
    link "#{text}", to: people_path(conn, :show_person, id)
  end

  def render_people_link(conn, %{entity_id: id, names: %{display_name: text}, showcase: true, type: "group"}) do
    link "#{text}", to: people_path(conn, :show_group, id)
  end

  def render_people_link(_conn, %{names: %{display_name: text}, showcase: false}) do
    text
  end

end
