defmodule Cineaste.Repo.Migrations.MakeFilmRuntimeOptional do
  use Ecto.Migration

  def up do
    alter table(:films) do
      modify :duration, :integer, null: true
    end
  end
  
  def down do
    alter table(:films) do
      modify :duration, :integer, null: false
    end
  end
end
