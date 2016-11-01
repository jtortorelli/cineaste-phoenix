defmodule Cineaste.Repo.Migrations.AddPropsFieldForFilm do
  use Ecto.Migration

  def change do
    alter table(:films) do
      add :props, {:map, :string}
    end
  end
end
