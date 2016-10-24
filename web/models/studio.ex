defmodule Cineaste.Studio do
  use Cineaste.Web, :model
  
  @primary_key {:id, Ecto.UUID, []}
  @derive {Phoenix.Param, key: :id}
  schema "studios" do
    field :name, :string
  end
  
  def changset(studio, params \\ %{}) do
    studio
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end