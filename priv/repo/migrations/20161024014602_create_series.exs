defmodule Cineaste.Repo.Migrations.CreateSeries do
  use Ecto.Migration

  def change do
    create table(:series, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
    end
  end
end
