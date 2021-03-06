defmodule Cineaste.Repo.Migrations.UpdateFilmStaffViewQuery do
  use Ecto.Migration

  def up do
    execute """
    DROP VIEW film_staff_view;
    """
    execute """
    CREATE VIEW film_staff_view AS
    SELECT fsv.film_id, fsv.role, ARRAY_AGG(fsv.staff) as staff FROM
    (SELECT spr.film_id, spr.role, JSON_BUILD_OBJECT('person_id', p.id, 'name', p.given_name || ' ' || p.family_name, 'showcase', p.showcase, 'type', 'person', 'order', spr.order) AS staff
    FROM staff_person_roles AS spr
    JOIN people AS p
    ON p.id = spr.person_id
    UNION ALL
    SELECT sgr.film_id, sgr.role, JSON_BUILD_OBJECT('group_id', g.id, 'name', g.name, 'showcase', g.showcase, 'type', 'group', 'order', sgr.order) as staff
    FROM staff_group_roles AS sgr
    JOIN groups AS g
    on g.id = sgr.group_id) AS fsv
    GROUP BY fsv.film_id, fsv.role;
    """
  end

  def down do
    execute """
    DROP VIEW film_staff_view;
    """
    execute """
    CREATE VIEW film_staff_view AS
    SELECT spr.film_id, spr.role, ARRAY_AGG(JSON_BUILD_OBJECT('person_id', p.id, 'name', p.given_name || ' ' || p.family_name, 'showcase', p.showcase, 'type', 'person', 'order', spr.order)) AS staff
    FROM staff_person_roles AS spr
    JOIN people AS p
    ON p.id = spr.person_id
    GROUP BY spr.film_id, spr.role
    UNION ALL
    SELECT sgr.film_id, sgr.role, ARRAY_AGG(JSON_BUILD_OBJECT('group_id', g.id, 'name', g.name, 'showcase', g.showcase, 'type', 'group', 'order', sgr.order)) as staff
    FROM staff_group_roles AS sgr
    JOIN groups AS g
    on g.id = sgr.group_id
    GROUP BY sgr.film_id, sgr.role;
    """
  end
end
