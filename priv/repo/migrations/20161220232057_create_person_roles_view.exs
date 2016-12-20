defmodule Cineaste.Repo.Migrations.CreatePersonRolesView do
  use Ecto.Migration

  def up do
    execute """
    CREATE VIEW person_roles_view AS
    SELECT f.title AS film_title,
    f.release_date AS film_release_date,
    f.showcase AS film_showcase,
    f.id AS film_id,
    r.role,
    null AS characters,
    p.id AS person_id
    FROM staff_person_roles r
    JOIN films f ON f.id = r.film_id
    JOIN people p ON p.id = r.person_id
    UNION
    SELECT f.title AS film_title,
    f.release_date AS film_release_date,
    f.showcase AS film_showcase,
    f.id AS film_id,
    'Actor' AS role,
    r.roles AS characters,
    p.id AS person_id
    FROM actor_person_roles r
    JOIN films f ON f.id = r.film_id
    JOIN people p ON p.id = r.person_id
    ORDER BY person_id, role, film_release_date;
    """
  end
  
  def down do
    execute """
    DROP VIEW person_roles_view
    """
  end
end
