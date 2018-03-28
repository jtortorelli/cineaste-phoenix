defmodule Cineaste.Repo.Migrations.UseFullReleaseDateInFilmIndexView do
  use Ecto.Migration

  def up do
    execute """
      DROP VIEW film_index_view;
    """
    execute """
      CREATE VIEW film_index_view AS
      SELECT id,
      title,
      release_date,
      aliases
      FROM films
      WHERE showcase = true;
    """
  end

  def down do
    execute """
      DROP VIEW film_index_view;
    """
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
end
