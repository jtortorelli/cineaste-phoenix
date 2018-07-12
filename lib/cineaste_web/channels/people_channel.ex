defmodule CineasteWeb.PeopleChannel do
  use Phoenix.Channel
  alias CineasteWeb.PeopleMonitor
  alias CineasteWeb.PeopleView

  def join("people:lobby", _message, socket) do
    {:ok, socket}
  end

  def handle_in("people:filter", %{"body" => searchTerm}, socket) do
    people =
      PeopleMonitor.get_state()
      |> PeopleView.filter_people_list(searchTerm)

    html =
      Phoenix.View.render_to_string(
        CineasteWeb.PeopleView,
        "people.html",
        people_index_views: people
      )

    push(socket, "people:filtered", %{html: html})
    {:noreply, socket}
  end
end
