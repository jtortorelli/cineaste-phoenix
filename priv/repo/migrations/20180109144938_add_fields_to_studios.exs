defmodule Cineaste.Repo.Migrations.AddFieldsToStudios do
  use Ecto.Migration

  def change do
    alter table(:studios) do
      add :props, {:map, :string}
    end
  end
end
