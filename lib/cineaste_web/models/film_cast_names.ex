defmodule Cineaste.FilmCastNames do
  use Cineaste.Web, :model
  
  embedded_schema do
    field :display_name, :string
    field :sort_name, :string
  end
   
end