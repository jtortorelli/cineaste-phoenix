alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Studio
alias Cineaste.StudioFilm

[filename | _] = System.argv
IO.inspect filename
true = File.exists?(filename)
true = File.regular?(filename)
body = File.read!(filename)
lines = String.split(body, "\n")
[studio | films] = lines
studio_model = Repo.one from s in Studio, where: s.name == ^studio

convert_to_model = fn(film, studio_model) ->
  film_model = Repo.one from f in Film, where: f.title == ^film
  %StudioFilm{
    studio_id: studio_model.id,
    film_id: film_model.id
  }
end

studio_films = Enum.map(films, fn(film) -> convert_to_model.(film, studio_model) end)
from(studio_film in StudioFilm, where: studio_film.studio_id == ^studio_model.id) |> Repo.delete_all
Enum.each(studio_films, fn x -> Repo.insert! x end)