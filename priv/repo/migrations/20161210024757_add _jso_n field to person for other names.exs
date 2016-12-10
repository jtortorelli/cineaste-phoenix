defmodule :"Elixir.Cineaste.Repo.Migrations.Add JSON field to person for other names" do
  use Ecto.Migration

  def change do
    alter table(:people) do
      add :other_names, {:map, :string}
    end
  end
end
