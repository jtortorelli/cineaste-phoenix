defmodule Cineaste.PeopleView do
  use Cineaste.Web, :view

  def render_link(conn, view) do
    case view.type do
      "person" ->
        link "#{view.display_name}", to: people_path(conn, :show_person, view.id)
      "group" ->
        link "#{view.display_name}", to: people_path(conn, :show_group, view.id)
    end 
  end

end