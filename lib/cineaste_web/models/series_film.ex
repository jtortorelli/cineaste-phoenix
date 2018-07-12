defmodule Cineaste.SeriesFilm do
  use Cineaste.Web, :model

  @primary_key false
  schema "series_films" do
    belongs_to(:series, Cineaste.Series, type: Ecto.UUID)
    belongs_to(:film, Cineaste.Film, type: Ecto.UUID)
    field(:order, :integer)
  end

  def changeset(series_film, params \\ %{}) do
    series_film
    |> cast(params, [:series_id, :film_id, :order])
    |> validate_required([:series_id, :film_id, :order])
  end
end
