defmodule Cineaste.FilmIndexView do
  use Cineaste.Web, :model

  @primary_key false
  schema "film_index_view" do
    field :id, Ecto.UUID
    field :title, :string
    field :release_date, :date
    field :aliases, {:array, :string}
  end

  def changeset(film_index_view, params \\ %{}) do
     film_index_view
     |> cast(params, [:id, :title, :release_date])
     |> validate_required([:id, :title, :release_date])
  end

  def sort_title(film_index_view) do
    if (String.starts_with?(film_index_view.title, "The ")) do
      String.trim_leading(film_index_view.title, "The ")
      |> String.replace(~r/[\.,'-]/, "")
      |> String.replace(" ", "")
      |> String.downcase()
    else
      String.replace(film_index_view.title, ~r/[\.,'-]/, "")
      |> String.replace(" ", "")
      |> String.downcase()
    end
  end
end
