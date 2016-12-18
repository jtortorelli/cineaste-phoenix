defmodule Cineaste.Repo.Migrations.AddPrimaryKeysToFilmImages do
  use Ecto.Migration

  def up do
    alter table(:film_images) do
      modify :type, :string, primary_key: true
      modify :file_name, :string, primary_key: true
      modify :film_id, :uuid, primary_key: true
    end
  end
  
  def down do
    alter table(:film_images) do
      modify :type, :string, primary_key: false
      modify :file_name, :string, primary_key: false
      modify :film_id, :uuid, primary_key: false
    end
  end
end
