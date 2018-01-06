defmodule CineasteWeb.PageTitle do
  alias CineasteWeb.FilmView
  alias CineasteWeb.PeopleView
  alias CineasteWeb.AboutView
  @suffix "The Godzilla Cineaste"

  def page_title(assigns), do: assigns |> get |> put_suffix

  defp put_suffix(nil), do: @suffix
  defp put_suffix(title), do: title <> " - " <> @suffix

  defp get(%{view_module: FilmView, view_template: "index.html"}) do
    "Films"
  end

  defp get(%{view_module: FilmView, view_template: "show.html", film: film}) do
    film.title
  end

  defp get(%{view_module: PeopleView, view_template: "index.html"}) do
    "People"
  end

  defp get(%{view_module: PeopleView, view_template: "show_person.html", person: person}) do
    person.given_name <> " " <> person.family_name
  end

  defp get(%{view_module: PeopleView, view_template: "show_group.html", group: group}) do
    group.name
  end

  defp get(%{view_module: AboutView, view_template: "index.html"}) do
    "About"
  end

  defp get(_), do: nil

end