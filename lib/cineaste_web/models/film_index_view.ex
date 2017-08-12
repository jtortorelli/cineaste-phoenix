defmodule Cineaste.FilmIndexView do
  use Cineaste.Web, :model

  @primary_key false
  @derive {Poison.Encoder, except: [:__meta__]}
  schema "film_index_view" do
    field :id, Ecto.UUID
    field :title, :string
    field :year, :integer
    field :aliases, {:array, :string}
  end

  def changeset(film_index_view, params \\ %{}) do
     film_index_view
     |> cast(params, [:id, :title, :year])
     |> validate_required([:id, :title, :year])
  end

  def sort_title(film_index_view) do
    if (String.starts_with?(film_index_view.title, "The ")) do
      String.trim_leading(film_index_view.title, "The ")
    else
      film_index_view.title
    end
  end
end
