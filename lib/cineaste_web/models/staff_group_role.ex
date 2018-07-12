defmodule Cineaste.StaffGroupRole do
  use Cineaste.Web, :model

  @primary_key false
  schema "staff_group_roles" do
    belongs_to(:film, Cineaste.Film, type: Ecto.UUID)
    belongs_to(:group, Cineaste.Group, type: Ecto.UUID)
    field(:role, :string)
    field(:order, :integer, default: 99)
  end

  def changset(staff_role, params \\ %{}) do
    staff_role
    |> cast(params, [:group_id, :film_id, :role])
    |> validate_required([:group_id, :film_id, :role])
  end
end
