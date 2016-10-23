defmodule Cineaste.Repo.Migrations.AddFilmIndexView do
  use Ecto.Migration

  def up do
    execute """
      CREATE VIEW film_index_view AS
      SELECT id,
      title,
      CAST(EXTRACT(year from release_date) AS int) AS year,
      aliases
      FROM films
      WHERE showcase = true;
    """
  end
  
  def down do
     execute """
     DROP VIEW film_index_view;
     """
  end
end
