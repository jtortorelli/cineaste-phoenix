defmodule Cineaste.HomeView do
  use Cineaste.Web, :view

  def display_banner() do
    url = Application.get_env(:cineaste, :s3)[:base_url] <> Application.get_env(:cineaste, :s3)[:site_images] <> "full-logo.jpg"
    render "banner.html", banner_url: url
  end
end