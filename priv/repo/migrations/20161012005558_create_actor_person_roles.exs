defmodule Cineaste.Repo.Migrations.CreateActorPersonRoles do
  use Ecto.Migration

  def change do
    create table(:actor_person_roles, primary_key: false) do
      add :film_id, references(:films, type: :uuid)
      add :person_id, references(:people, type: :uuid)
      add :roles, {:array, :string}, null: false
      add :order, :integer, default: 99
    end
  end
end
