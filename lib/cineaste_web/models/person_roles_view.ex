defmodule Cineaste.PersonRolesView do
   use Cineaste.Web, :model
   
  @primary_key false
  schema "person_roles_view" do
    field :film_title, :string
    field :film_release_date, Ecto.Date
    field :film_showcase, :boolean
    field :film_id, Ecto.UUID
    field :role, :string
    field :characters, {:array, :string}
    field :person_id, Ecto.UUID
  end
  
  def changeset(person_roles_view, params \\ %{}) do
    person_roles_view
    |> cast(params, [:film_title, :film_release_date, :film_showcase, :film_id, :role, :person_id])
    |> cast_actor_role(params)
    |> validate_required([:film_title, :film_release_date, :film_showcase, :film_id, :role, :person_id]) 
  end
  
  def cast_actor_role(changeset, params) do
    case get_field(changeset, :role) do
      "Actor" -> cast(changeset, params, ~w(characters), ~w())
      _       -> cast(changeset, params, ~w(), ~w(characters)) 
    end 
  end
end