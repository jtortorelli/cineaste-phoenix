defmodule Cineaste.ActorGroupRole do
  use Cineaste.Web, :model
  
  @primary_key false
  schema "actor_group_roles" do
    belongs_to :group, Cineaste.Group, type: Ecto.UUID
    belongs_to :film, Cineaste.Film, type: Ecto.UUID
    field :roles, {:array, :string}
    field :order, :integer, default: 99
  end
  
  def changeset(actor_role, params \\ %{}) do
    actor_role
    |> cast(params, [:group_id, :film_id, :roles])
    |> validate_required([:group_id, :film_id, :roles]) 
  end
end