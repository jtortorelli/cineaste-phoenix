defmodule :"Elixir.Cineaste.Repo.Migrations.Remove extra name fields from person" do
  use Ecto.Migration

  def change do
    alter table(:people) do
      remove :original_name
      remove :birth_name
      remove :japanese_name 
    end
  end
end
