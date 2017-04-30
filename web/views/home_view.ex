defmodule Cineaste.HomeView do
  use Cineaste.Web, :view
  alias Cineaste.S3View

  def display_banner() do
    url = S3View.get_display_banner()
    render "banner.html", banner_url: url
  end
end