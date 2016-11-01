defmodule Cineaste.Repo.Migrations.DropOriginalTitleFieldsFromFilm do
  use Ecto.Migration

  def change do
    alter table(:films) do
      remove :original_title
      remove :original_transliteration
      remove :original_translation
    end
  end
end
