defmodule Cineaste.Person do
  use Cineaste.Web, :model

  @primary_key {:id, Ecto.UUID, []}
  @derive {Phoenix.Param, key: :id}
  schema "people" do
    field :given_name, :string
    field :family_name, :string
    field :gender, :string, default: "U"
    field :showcase, :boolean, default: false
    field :original_name, :string
    field :japanese_name, :string
    field :birth_name, :string
    field :dob, {:map, :integer}
    field :dod, {:map, :integer}
    field :birth_place, :string
    field :death_place, :string
    field :aliases, {:array, :string}
    many_to_many :films_worked_on, Cineaste.Film, join_through: Cineaste.StaffPersonRole
    many_to_many :films_starred_in, Cineaste.Film, join_through: Cineaste.ActorPersonRole
  end

  def changset(person, params \\ %{}) do
     person
     |> cast(params, [:given_name, :family_name, :gender, :showcase])
     |> validate_required([:given_name, :family_name, :gender, :showcase])
  end
end
