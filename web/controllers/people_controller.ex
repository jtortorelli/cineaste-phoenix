defmodule Cineaste.PeopleController do
  use Cineaste.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show_person(conn, %{"id" => id}) do
    render conn, "show_person.html", id: id
  end

  def show_group(conn, %{"id" => id}) do
    render conn, "show_group.html", id: id
  end
end
