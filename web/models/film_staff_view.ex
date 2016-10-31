defmodule Cineaste.FilmStaffView do
  use Cineaste.Web, :model
  
  @primary_key false
  schema "film_staff_view" do
    field :film_id, Ecto.UUID
    field :role, :string
    embeds_many :staff, Cineaste.Staff
  end
  
  def changeset(film_staff_view, params \\ %{}) do
    film_staff_view
    |> cast(params, [:film_id, :role, :staff])
    |> validate_required([:film_id, :role, :staff])
  end
end