defmodule Cineaste.Series do
  use Cineaste.Web, :model

  @primary_key {:id, Ecto.UUID, []}
  @derive {Phoenix.Param, key: :id}
  schema "series" do
    field(:name, :string)
    many_to_many(:films, Cineaste.Film, join_through: Cineaste.SeriesFilm)
  end

  def changeset(series, params \\ %{}) do
    series
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
