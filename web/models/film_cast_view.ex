defmodule Cineaste.FilmCastView do
  use Cineaste.Web, :model

  @primary_key false
  schema "film_cast_view" do
    field :film_id, Ecto.UUID
    field :entity_id, Ecto.UUID
    field :roles, {:array, :string}
    field :order, :integer
    field :showcase, :boolean
    field :type, :string
    embeds_one :names, Cineaste.FilmCastNames
  end

  def changeset(film_cast_view, params \\ %{}) do
    film_cast_view
    |> cast(params, [:film_id, :entity_id, :roles, :order, :showcase, :type, :names])
    |> validate_required([:film_id, :entity_id, :roles, :order, :showcase, :type, :names]) 
  end
end
