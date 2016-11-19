defmodule Cineaste.Repo.Migrations.CreatePeopleIndexView do
  use Ecto.Migration

  def up do
    execute """
    CREATE VIEW people_index_view AS
    SELECT p.id, 'person' AS type, p.family_name || ' ' || p.given_name AS sort_name, p.family_name || ', ' || p.given_name AS display_name
    FROM people p
    WHERE p.showcase = true
    UNION
    SELECT g.id, 'group' AS type, regexp_replace(g.name, '^The ', '') AS sort_name, g.name AS display_name
    FROM groups g
    WHERE g.showcase = true
    """
  end
  
  def down do
     execute """
     DROP VIEW people_index_view
     """
  end
end
