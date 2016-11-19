defmodule Cineaste.PeopleIndexView do
  use Cineaste.Web, :model
  
  @primary_key false
  schema "people_index_view" do
    field :id, Ecto.UUID
    field :type, :string
    field :sort_name, :string
    field :display_name, :string
  end
  
  def changeset(people_index_view, params \\ %{}) do
    people_index_view
    |> cast(params, [:id, :type, :sort_name, :display_name])
    |> validate_required([:id, :type, :sort_name, :display_name]) 
  end 
end