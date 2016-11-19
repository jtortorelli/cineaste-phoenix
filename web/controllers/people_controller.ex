defmodule Cineaste.PeopleController do
  use Cineaste.Web, :controller
  alias Cineaste.PeopleIndexView


  def index(conn, _params) do
    people_index_views = Repo.all(PeopleIndexView) |> Enum.sort_by(fn(view) -> view.sort_name end)
    render conn, "index.html", people_index_views: people_index_views
  end

  def show_person(conn, %{"id" => id}) do
    render conn, "show_person.html", id: id
  end

  def show_group(conn, %{"id" => id}) do
    render conn, "show_group.html", id: id
  end
end
