defmodule Cineaste.FilmView do
  use Cineaste.Web, :view
  import Ecto.Query
  alias Cineaste.Repo
  alias Cineaste.Staff
  alias Cineaste.SeriesFilm
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
     render "aliases.html", aliases: aliases
  end
  
  def display_aliases(_) do
    ""
  end
  
  def display_release_date(date) do
    Timex.format!(date, "{Mfull} {D}, {YYYY}")
  end
  
  def display_series_info(%Cineaste.Film{} = film) do
    _display_series_info(Repo.preload(film, [:series])) 
  end
  
  defp _display_series_info(%Cineaste.Film{:series => [_h|_t]} = film) do
    series = List.first(film.series)
    series_film = Repo.one(from s in SeriesFilm, where: s.film_id == ^film.id and s.series_id == ^series.id)
    {:safe, precedent_template} = Repo.one(from s in SeriesFilm, where: s.series_id == ^series.id and s.order == ^(series_film.order - 1)) |> _display_series_precedent
    {:safe, antecedent_template} = Repo.one(from s in SeriesFilm, where: s.series_id == ^series.id and s.order == ^(series_film.order + 1)) |> _display_series_antecedent
    raw "#{precedent_template}#{antecedent_template}"
  end
  
  defp _display_series_info(_) do
    "" 
  end

  defp _display_series_precedent(%Cineaste.SeriesFilm{} = series_film) do
    film = Repo.preload(series_film, [:film]).film
    render "series_precedent.html", film: film
  end
  
  defp _display_series_precedent(_) do
    {:safe, ""}
  end
  
  defp _display_series_antecedent(%Cineaste.SeriesFilm{} = series_film) do
    film = Repo.preload(series_film, [:film]).film
    render "series_antecedent.html", film: film
  end
  
  defp _display_series_antecedent(_) do
    {:safe, ""}
  end

end
