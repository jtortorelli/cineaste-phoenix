defmodule Cineaste.CommonView do
  use Cineaste.Web, :view
  
  def render_table_row(key, value) do
     render "table_row.html", key: key, value: value
  end
  
  def render_aliases_table_row(aliases) do
    render "aliases.html", aliases: aliases 
  end
end