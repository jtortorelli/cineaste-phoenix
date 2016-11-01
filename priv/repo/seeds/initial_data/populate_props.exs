alias Ecto
import Ecto.Query
import Ecto.Changeset
alias Cineaste.Repo
alias Cineaste.Film

films = Repo.all(Film)

populate_props = fn(film) ->
  original_title = film.original_title
  original_translation = film.original_translation
  original_transliteration = film.original_transliteration
  props = %{original_title: original_title, original_translation: original_translation, original_transliteration: original_transliteration}
  film
  |> change(props: props)
  |> Repo.update
end

Enum.map(films, fn(film) -> populate_props.(film) end)
