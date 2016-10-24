defmodule Cineaste.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :showcase, :boolean, default: false, null: false
      add :active_start, :integer
      add :active_end, :integer
      add :props, {:map, :string}
    end
  end
end
