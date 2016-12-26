defmodule Cineaste.Repo.Migrations.CreateGroupMemberships do
  use Ecto.Migration

  def change do
    create table(:group_memberships, primary_key: false) do
      add :group_id, references(:groups, type: :uuid)
      add :person_id, references(:people, type: :uuid)
    end
  end
end
