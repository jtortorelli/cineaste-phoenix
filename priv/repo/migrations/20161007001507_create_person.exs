defmodule Cineaste.Repo.Migrations.CreatePerson do
  use Ecto.Migration

  def change do
    create table(:people, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :given_name, :string, null: false
      add :family_name, :string, null: false
      add :gender, :string, default: "U", null: false
      add :showcase, :boolean, default: false, null: false
      add :original_name, :string
      add :japanese_name, :string
      add :birth_name, :string
      add :dob, {:map, :integer}
      add :dod, {:map, :integer}
      add :birth_place, :string
      add :death_place, :string
      add :aliases, {:array, :string}
    end
  end
end
