alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.FilmImage


[filename | _] = System.argv
IO.inspect filename
true = File.exists?(filename)
true = File.regular?(filename)
body = File.read!(filename)
lines = String.split(body, "\n")
[uuid | file_names] = lines
film_model = Repo.get(Film, uuid)
IO.inspect film_model

convert_to_model = fn(file_name, uuid) ->
  IO.inspect(file_name)
  %FilmImage{
    film_id: uuid,
    type: "gallery",
    file_name: file_name
  }
end

film_images = Enum.map(file_names, fn(file_name) -> convert_to_model.(file_name, uuid) end)
from(film_image in FilmImage, where: film_image.film_id == ^uuid) |> Repo.delete_all

Enum.each(film_images, fn x -> Repo.insert! x end)