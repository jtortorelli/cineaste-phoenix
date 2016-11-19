defmodule Cineaste.Repo.Migrations.CreateFilmImages do
  use Ecto.Migration

  def change do
    create table(:film_images, primary_key: false) do
      add :film_id, references(:films, type: :uuid)
      add :type, :string, null: false
      add :file_name, :string, null: false
      add :caption, :string
    end
  end
end
