defmodule CineasteWeb.S3View do
  use Cineaste.Web, :view

  def get_gallery_url(film_id, size) do
    get_base_image_url()
    |> Kernel.<>(Application.get_env(:cineaste, :s3)[:film_galleries])
    |> Kernel.<>("/")
    |> Kernel.<>(film_id)
    |> Kernel.<>("/")
    |> Kernel.<>(size)
    |> Kernel.<>("/")
  end

  def get_poster_url(film_id) do
    get_base_image_url()
    |> Kernel.<>(Application.get_env(:cineaste, :s3)[:posters])
    |> Kernel.<>("/")
    |> Kernel.<>(film_id)
    |> Kernel.<>(".jpg")
  end

  def get_poster_url() do
    get_base_image_url()
    |> Kernel.<>(Application.get_env(:cineaste, :s3)[:posters])
    |> Kernel.<>("/")
  end

  def get_display_banner() do
    get_base_image_url()
    |> Kernel.<>(Application.get_env(:cineaste, :s3)[:site_images])
    |> Kernel.<>("/full-logo.jpg")
  end

  def get_profile_pic(type, id) do
    get_base_image_url()
    |> Kernel.<>(Application.get_env(:cineaste, :s3)[:profiles])
    |> Kernel.<>("/")
    |> Kernel.<>(type)
    |> Kernel.<>("/")
    |> Kernel.<>(id)
    |> Kernel.<>(".jpg")
  end

  def get_film_synopsis_url(film_id) do
    get_base_text_url()
    |> Kernel.<>(Application.get_env(:cineaste, :s3)[:synopses])
    |> Kernel.<>("/")
    |> Kernel.<>(film_id)
    |> Kernel.<>(".md")
  end

  def get_bio_url(type, id) do
    get_base_text_url()
    |> Kernel.<>(Application.get_env(:cineaste, :s3)[:bios])
    |> Kernel.<>("/")
    |> Kernel.<>(type)
    |> Kernel.<>("/")
    |> Kernel.<>(id)
    |> Kernel.<>(".md")
  end

  defp get_base_image_url() do
    Application.get_env(:cineaste, :s3)[:base_url]
    |> Kernel.<>(Application.get_env(:cineaste, :s3)[:images])
  end

  defp get_base_text_url() do
    Application.get_env(:cineaste, :s3)[:base_url]
    |> Kernel.<>(Application.get_env(:cineaste, :s3)[:text])
  end

end