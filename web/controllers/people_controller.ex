defmodule Cineaste.PeopleController do
  use Cineaste.Web, :controller
  alias Cineaste.PeopleIndexView
  alias Cineaste.Person
  alias Cineaste.Group
  alias Cineaste.ErrorView
  alias Cineaste.PersonRolesView

  def index(conn, _params) do
    people_index_views = Repo.all(PeopleIndexView) |> Enum.sort_by(fn(view) -> view.sort_name end)
    render conn, "index.html", people_index_views: people_index_views
  end

  def show_person(conn, %{"id" => id}) do
    _find_person(conn, Ecto.UUID.cast(id))
  end

  def show_group(conn, %{"id" => id}) do
    _find_group(conn, Ecto.UUID.cast(id))
  end
  
  def _find_person(conn, {:ok, uuid}) do
     _render_person_page(conn, Repo.get(Person, uuid))
  end
  
  def _find_person(conn, _) do
     _render_page_not_found_message(conn)
  end
  
  def _render_person_page(conn, %Person{} = person) do
    roles = Repo.all(from view in PersonRolesView, where: view.person_id == ^person.id)
    bio = File.read!("web/static/assets/text/bios/people/#{person.id}.txt")
    |> String.split("\n")
    |> Enum.map(fn x -> "<p>#{x}</p>" end)
    |> Enum.join
    render conn, "show_person.html", person: person, bio: bio, roles: roles
  end
  
  def _render_person_page(conn, _) do
    _render_page_not_found_message(conn) 
  end
  
  def _find_group(conn, {:ok, uuid}) do
     _render_group_page(conn, Repo.get(Group, uuid))
  end
  
  def _find_group(conn, _) do
     _render_page_not_found_message(conn)
  end
  
  def _render_group_page(conn, %Group{} = group) do
     render conn, "show_group.html", group: group
  end
  
  def _render_group_page(conn, _) do
    _render_page_not_found_message(conn) 
  end
  

  
  def _render_page_not_found_message(conn) do
    conn
    |> put_status(404)
    |> render(ErrorView, :"404", message: "The thing was not found") 
  end
end
