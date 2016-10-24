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
  end
end