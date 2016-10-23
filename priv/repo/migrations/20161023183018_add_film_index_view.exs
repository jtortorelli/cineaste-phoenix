defmodule Cineaste.Repo.Migrations.AddFilmIndexView do
  use Ecto.Migration

  def up do
    execute """
      CREATE VIEW film_index_view AS
      SELECT id,
      title,
      EXTRACT(year from release_date) AS year,
      aliases
      FROM films;
    """
  end
  
  def down do
     execute """
     DROP VIEW film_index_view;
     """
  end
end
