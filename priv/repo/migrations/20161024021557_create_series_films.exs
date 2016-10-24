defmodule Cineaste.Repo.Migrations.CreateSeriesFilms do
  use Ecto.Migration

  def change do
    create table(:series_films, primary_key: false) do
      add :series_id, references(:series, type: :uuid)
      add :film_id, references(:films, type: :uuid)
      add :order, :integer, null: false
    end
  end
end
