defmodule Cineaste.Repo.Migrations.CreateFilmStaffView do
  use Ecto.Migration

  def up do
    execute """
      CREATE VIEW film_staff_view AS
      SELECT r.film_id, r.role, ARRAY_AGG(JSON_BUILD_OBJECT('person_id', p.id, 'name', p.given_name || ' ' || p.family_name, 'showcase', p.showcase, 'type', 'person', 'order', r.order)) AS staff
      FROM staff_person_roles AS r
      JOIN people AS p
      ON p.id = r.person_id
      GROUP BY r.film_id, r.role;
    """
  end
  
  def down do
     execute """
      DROP VIEW film_staff_view;
     """
  end
end
