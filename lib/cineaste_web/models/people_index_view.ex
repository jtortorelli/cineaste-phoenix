defmodule Cineaste.PeopleIndexView do
  use Cineaste.Web, :model

  @primary_key false
  schema "people_index_view" do
    field(:id, Ecto.UUID)
    field(:type, :string)
    field(:gender, :string)
    field(:sort_name, :string)
    field(:display_name, {:array, :string})
    field(:aliases, {:array, :string})
    field(:roles, {:array, :string})
    field(:members, {:array, :string})
  end

  def changeset(people_index_view, params \\ %{}) do
    people_index_view
    |> cast(params, [:id, :type, :sort_name, :display_name, :roles, :members])
    |> validate_required([:id, :type, :sort_name, :display_name, :roles, :members])
  end
end
