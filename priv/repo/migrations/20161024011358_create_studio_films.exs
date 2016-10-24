defmodule Cineaste.Repo.Migrations.CreateStudioFilms do
  use Ecto.Migration

  def change do
    create table(:studio_films, primary_key: false) do
      add :studio_id, references(:studios, type: :uuid)
      add :film_id, references(:films, type: :uuid)
    end
  end
end
