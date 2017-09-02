defmodule CineasteWeb.FilmChannel do
  use Phoenix.Channel
  require Logger
  alias CineasteWeb.FilmMonitor
  alias CineasteWeb.FilmView

  def join("film:lobby", _message, socket) do
    {:ok, socket}
  end

  def handle_in("film:filter", %{"body" => searchTerm}, socket) do
    films = FilmMonitor.get_state
    |> FilmView.filter_film_list(searchTerm)
    html = Phoenix.View.render_to_string(CineasteWeb.FilmView, "films.html", film_index_views: films)
    push socket, "film:filtered", %{html: html}
    {:noreply, socket}
  end
end