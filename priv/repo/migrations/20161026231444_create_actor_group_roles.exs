defmodule Cineaste.Repo.Migrations.CreateActorGroupRoles do
  use Ecto.Migration

  def change do
    create table(:actor_group_roles, primary_key: false) do
      add :film_id, references(:films, type: :uuid)
      add :group_id, references(:groups, type: :uuid)
      add :roles, {:array, :string}, null: false
      add :order, :integer, default: 99
    end
  end
end
