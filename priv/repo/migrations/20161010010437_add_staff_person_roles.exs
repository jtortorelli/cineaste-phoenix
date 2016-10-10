defmodule Cineaste.Repo.Migrations.AddStaffPersonRoles do
  use Ecto.Migration

  def change do
    create table(:staff_person_roles, primary_key: false) do
      add :film_id, references(:films, type: :uuid)
      add :person_id, references(:people, type: :uuid)
      add :role, :string, null: false
      add :order, :integer, default: 99
    end
  end
end
