defmodule Cineaste.FilmView do
  use Cineaste.Web, :view
  alias Cineaste.Staff
  
  def sorted_staff(staff) do
     Enum.sort_by(staff, fn(x) -> x.order end)
  end
end
