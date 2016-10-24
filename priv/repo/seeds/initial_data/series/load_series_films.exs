alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Series
alias Cineaste.SeriesFilm

[filename | _] = System.argv
IO.inspect filename
true = File.exists?(filename)
true = File.regular?(filename)
body = File.read!(filename)
lines = String.split(body, "\n")
[series | films] = lines
series_model = Repo.one from s in Series, where: s.name == ^series

convert_to_model = fn(line, series_model) ->
  [order, film] = String.split(line, ",")
  film_model = Repo.one from f in Film, where: f.title == ^String.replace(film, "_", ",")
  %SeriesFilm{
    series_id: series_model.id,
    film_id: film_model.id,
    order: String.to_integer(order)
  }
end

series_films = Enum.map(films, fn(film) -> convert_to_model.(film, series_model) end)
from(sf in SeriesFilm, where: sf.series_id == ^series_model.id) |> Repo.delete_all
Enum.each(series_films, fn x -> Repo.insert! x end)