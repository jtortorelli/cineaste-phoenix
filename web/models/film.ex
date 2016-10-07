defmodule Cineaste.Film do
  use Cineaste.Web, :model

  @primary_key {:id, Ecto.UUID, []}
  @derive {Phoenix.Param, key: :id}
  schema "films" do
    field :title, :string
    field :release_date, Ecto.Date
    field :duration, :integer
    field :showcase, :boolean, default: false
    field :original_title, :string
    field :original_transliteration, :string
    field :original_translation, :string
    field :aliases, {:array, :string}
  end

  def changeset(film, params \\ %{}) do
    film
    |> cast(params, [:title, :release_date, :duration, :showcase])
    |> validate_required([:title, :release_date, :duration, :showcase])
  end
end
