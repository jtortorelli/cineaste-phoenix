defmodule Cineaste.PageController do
  use Cineaste.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
