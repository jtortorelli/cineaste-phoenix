defmodule Cineaste.Repo.Migrations.AddStaffGroupRolesTable do
  use Ecto.Migration

  def change do
    create table(:staff_group_roles, primary_key: false) do
      add :film_id, references(:films, type: :uuid)
      add :group_id, references(:groups, type: :uuid)
      add :role, :string, null: false
      add :order, :integer, default: 99
    end
  end
end
