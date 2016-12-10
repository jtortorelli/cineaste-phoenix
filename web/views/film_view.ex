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
  
  def sorted_staff(staff) do
     Enum.sort_by(staff, fn(x) -> x.order end)
  end
  
  def display_original_title(%{"original_title" => title, "original_transliteration" => transliteration, "original_translation" => translation} = props) do
    Logger.debug "inside display_original_title"
    Logger.debug "value of props: #{inspect(props)}"
    render "original_title.html", title: title, transliteration: transliteration, translation: translation
  end
  
  def display_original_title(_) do
    "" 
  end
  
  def display_aliases([_head | _tail] = aliases) do
    CommonView.render_aliases_table_row(aliases)
  end
  
  def display_aliases(_) do
    ""
  end
  
  def display_release_date(date) do
    Timex.format!(date, "{Mfull} {D}, {YYYY}")
  end
  
  def display_series_info(%Film{} = film) do
    _display_series_info(Repo.preload(film, [:series])) 
  end
  
  defp _display_series_info(%Film{:series => [_h|_t]} = film) do
    series = List.first(film.series)
    series_film = Repo.one(from s in SeriesFilm, where: s.film_id == ^film.id and s.series_id == ^series.id)
    {:safe, precedent_template} = Repo.one(from s in SeriesFilm, where: s.series_id == ^series.id and s.order == ^(series_film.order - 1)) |> _display_series_precedent
    {:safe, antecedent_template} = Repo.one(from s in SeriesFilm, where: s.series_id == ^series.id and s.order == ^(series_film.order + 1)) |> _display_series_antecedent
    raw "#{precedent_template}#{antecedent_template}"
  end
  
  defp _display_series_info(_) do
    "" 
  end

  defp _display_series_precedent(%SeriesFilm{} = series_film) do
    film = Repo.preload(series_film, [:film]).film
    render "series_precedent.html", film: film
  end
  
  defp _display_series_precedent(_) do
    {:safe, ""}
  end
  
  defp _display_series_antecedent(%SeriesFilm{} = series_film) do
    film = Repo.preload(series_film, [:film]).film
    render "series_antecedent.html", film: film
  end
  
  defp _display_series_antecedent(_) do
    {:safe, ""}
  end
  
  def render_top_billed_cast([_h|_t] = top_billed_cast) do
    render "top_billed_cast.html", top_billed_cast: top_billed_cast 
  end
  
  def render_top_billed_cast(_) do
    ""
  end
  
  def render_other_cast([_h|_t] = other_cast) do
    render "other_cast.html", other_cast: other_cast
  end
  
  def render_other_cast(_) do
    "" 
  end
  
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

end
