defmodule Cineaste.Group do
  use Cineaste.Web, :model
  
  @primary_key {:id, Ecto.UUID, []}
  @derive {Phoenix.Param, key: :id}
  schema "groups" do
    field :name, :string
    field :showcase, :boolean, default: false
    field :active_start, :integer
    field :active_end, :integer
    field :props, {:map, :string}
    many_to_many :members, Cineaste.Person, join_through: Cineaste.GroupMembership
  end
  
  def changeset(group, params \\ %{}) do
    group
    |> cast(params, [:name, :showcase])
    |> validate_required([:name, :showcase]) 
  end
end