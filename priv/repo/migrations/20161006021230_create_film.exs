defmodule Cineaste.Repo.Migrations.CreateFilm do
  use Ecto.Migration

  def change do
    create table(:films, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string, null: false
      add :release_date, :date, null: false
      add :duration, :integer, null: false
      add :showcase, :boolean, default: false
      add :original_title, :string
      add :original_transliteration, :string
      add :original_translation, :string
      add :aliases, {:array, :string}
    end
  end
end
