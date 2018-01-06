defmodule CineasteWeb.LayoutView do
  use Cineaste.Web, :view
  alias CineasteWeb.PageTitle

  def page_title(assigns) do
    PageTitle.page_title(assigns)
  end
end
