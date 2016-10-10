defmodule Cineaste.StaffPersonRole do
  use Cineaste.Web, :model

  @primary_key false
  schema "staff_person_roles" do
    belongs_to :person, Cineaste.Person
    belongs_to :film, Cineaste.Film
    field :role, :string
    field :order, :integer, default: 99
  end

  def changset(staff_role, params \\ {}) do
    staff_role
    |> cast(params, [:person_id, :film_id, :role])
    |> validate_required([:person_id, :film_id, :role])
  end
end
