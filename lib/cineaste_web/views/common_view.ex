defmodule CineasteWeb.CommonView do
  use Cineaste.Web, :view

  def render_table_row(key, value), do: render "table_row.html", key: key, value: value

  def render_aliases_table_row(aliases), do: render "aliases.html", aliases: aliases
end