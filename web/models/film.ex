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
    many_to_many :staff, Cineaste.Person, join_through: Cineaste.StaffPersonRole
    many_to_many :cast, Cineaste.Person, join_through: Cineaste.ActorPersonRole
    many_to_many :studio, Cineaste.Studio, join_through: Cineaste.StudioFilm
  end

  def changeset(film, params \\ %{}) do
    film
    |> cast(params, [:title, :release_date, :duration, :showcase])
    |> validate_required([:title, :release_date, :duration, :showcase])
  end
  
  def sort_title(film) do
    if (String.starts_with?(film.title, "The ")) do
      String.trim_leading(film.title, "The ")
    else
      film.title
    end
  end
end
