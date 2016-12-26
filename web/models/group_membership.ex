defmodule Cineaste.GroupMembership do
  use Cineaste.Web, :model
  
  @primary_key false
  schema "group_memberships" do
    belongs_to :group, Cineaste.Group, type: Ecto.UUID
    belongs_to :person, Cineaste.Person, type: Ecto.UUID 
  end
  
  def changeset(group_membership, params \\ %{}) do
    group_membership
    |> cast(params, [:group_id, :person_id])
    |> validate_required([:group_id, :person_id])
  end
end