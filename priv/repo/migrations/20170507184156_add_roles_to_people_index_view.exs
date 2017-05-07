defmodule Cineaste.Repo.Migrations.AddRolesToPeopleIndexView do
  use Ecto.Migration

  def up do
    execute """
    DROP VIEW people_index_view;
    """
    execute """
    CREATE VIEW people_index_view AS
    SELECT p.id,
    'person' AS type,
    p.family_name || ' ' || p.given_name AS sort_name,
    p.family_name || ', ' || p.given_name AS display_name,
    (SELECT ARRAY(
      SELECT
      prv.role
      FROM person_roles_view as prv
      WHERE p.id = prv.person_id
      GROUP BY prv.role
      ORDER BY count(*) DESC
      LIMIT 3
    )) AS roles
    FROM people p
    WHERE p.showcase = true
    UNION
    SELECT g.id,
    'group' AS type,
    regexp_replace(g.name, '^The ', '') AS sort_name,
    g.name AS display_name,
    (SELECT ARRAY(
      SELECT
      grv.role
      FROM group_roles_view as grv
      WHERE g.id = grv.group_id
      GROUP BY grv.role
      ORDER BY count(*) DESC
      LIMIT 3
    )) AS roles
    FROM groups g
    WHERE g.showcase = true
    """
  end

  def down do
    execute """
    DROP VIEW people_index_view;
    """
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
end
