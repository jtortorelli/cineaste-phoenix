defmodule Cineaste.FilmImage do
  use Cineaste.Web, :model
  
  @primary_key false
  schema "film_images" do
    field :type, :string
    field :file_name, :string
    field :caption, :string
    belongs_to :film, Cineaste.Film, type: Ecto.UUID
  end
  
  def changeset(film_image, params \\ %{}) do
    film_image
    |> cast(params, [:type, :file_name, :film_id])
    |> validate_required([:type, :file_name, :film_id])
  end
end