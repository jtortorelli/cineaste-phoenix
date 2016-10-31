defmodule Cineaste.Staff do
  use Cineaste.Web, :model
  
  embedded_schema do
    field :person_id, Ecto.UUID
    field :name, :string
    field :showcase, :boolean
    field :type, :string
    field :order, :integer
  end
end