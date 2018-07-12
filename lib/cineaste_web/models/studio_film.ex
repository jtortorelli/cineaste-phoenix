defmodule Cineaste.StudioFilm do
  use Cineaste.Web, :model

  @primary_key false
  schema "studio_films" do
    belongs_to(:studio, Cineaste.Studio, type: Ecto.UUID)
    belongs_to(:film, Cineaste.Film, type: Ecto.UUID)
  end

  def changset(studio_film, params \\ %{}) do
    studio_film
    |> cast(params, [:studio_id, :film_id])
    |> validate_required([:studio_id, :film_id])
  end
end
