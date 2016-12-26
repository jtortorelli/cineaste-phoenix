defmodule Cineaste.Repo.Migrations.CreateGroupRolesView do
  use Ecto.Migration

  def up do
    execute """
    CREATE VIEW group_roles_view AS
    SELECT f.title AS film_title,
    f.release_date AS film_release_date,
    f.showcase AS film_showcase,
    f.id AS film_id,
    'Actor' AS role,
    r.roles AS characters,
    g.id AS group_id
    FROM actor_group_roles r
    JOIN films f ON f.id = r.film_id
    JOIN groups g ON g.id = r.group_id
    ORDER BY group_id, role, film_release_date;
    """
  end
  
  def down do
    execute """
    DROP VIEW group_roles_view
    """ 
  end
end
