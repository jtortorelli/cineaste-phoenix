defmodule Cineaste.Repo.Migrations.AddPersonIdToFilmCastView do
  use Ecto.Migration

  def up do
    execute """
    DROP VIEW film_cast_view;
    """
    execute """
    CREATE VIEW film_cast_view AS
    SELECT r.film_id, p.id AS entity_id, r.roles, r.order, p.showcase, 'person' AS type, JSONB_BUILD_OBJECT('display_name', p.given_name || ' ' || p.family_name, 'sort_name', p.family_name || ' ' || p.given_name) AS names
    FROM actor_person_roles AS r
    JOIN people AS p
    ON p.id = r.person_id
    UNION
    SELECT r.film_id, g.id AS entity_id, r.roles, r.order, g.showcase, 'group' AS type, JSONB_BUILD_OBJECT('display_name', g.name, 'sort_name', regexp_replace(g.name, '^The ', '')) AS names
    FROM actor_group_roles AS r
    JOIN groups AS g
    ON g.id = r.group_id;
    """
  end

  def down do
      execute """
      DROP VIEW film_cast_view;
      """
      execute """
      CREATE VIEW film_cast_view AS
      SELECT r.film_id, r.roles, r.order, p.showcase, 'person' AS type, JSONB_BUILD_OBJECT('display_name', p.given_name || ' ' || p.family_name, 'sort_name', p.family_name || ' ' || p.given_name) AS names
      FROM actor_person_roles AS r
      JOIN people AS p
      ON p.id = r.person_id
      UNION
      SELECT r.film_id, r.roles, r.order, g.showcase, 'group' AS type, JSONB_BUILD_OBJECT('display_name', g.name, 'sort_name', regexp_replace(g.name, '^The ', '')) AS names
      FROM actor_group_roles AS r
      JOIN groups AS g
      ON g.id = r.group_id;
     """
  end
end
