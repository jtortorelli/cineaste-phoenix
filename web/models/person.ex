defmodule Cineaste.Person do
  use Cineaste.Web, :model

  @primary_key {:id, Ecto.UUID, []}
  @derive {Phoenix.Param, key: :id}
  schema "people" do
    field :given_name, :string
    field :family_name, :string
    field :gender, :string, default: "U"
    field :showcase, :boolean, default: false
    field :other_names, {:map, :string}
    field :dob, {:map, :integer}
    field :dod, {:map, :integer}
    field :birth_place, :string
    field :death_place, :string
    field :aliases, {:array, :string}
    many_to_many :films_worked_on, Cineaste.Film, join_through: Cineaste.StaffPersonRole
    many_to_many :films_starred_in, Cineaste.Film, join_through: Cineaste.ActorPersonRole
  end

  def changset(person, params \\ %{}) do
     person
     |> cast(params, [:given_name, :family_name, :gender, :showcase])
     |> validate_required([:given_name, :family_name, :gender, :showcase])
  end
  
  def age(person) do
     _calculate_age(person.dob, person.dod)
  end
  
  def _calculate_age(%{"year" => dob_year, "month" => dob_month, "day" => dob_day}, %{"year" => dod_year, "month" => dod_month, "day" => dod_day}) do
    {:ok, dob_date} = Date.new(dob_year, dob_month, dob_day)
    {:ok, dod_date} = Date.new(dod_year, dod_month, dod_day)
    Timex.diff(dod_date, dob_date, :years)
  end
  
  def _calculate_age(%{"year" => dob_year, "month" => dob_month}, %{"year" => dod_year, "month" => dod_month}) do
    {:ok, dob_date} = Date.from(dob_year, dob_month, 1)
    {:ok, dod_date} = Date.new(dod_year, dod_month, 1)
    Timex.diff(dod_date, dob_date, :years)
  end
  
  def _calculate_age(%{"year" => dob_year}, %{"year" => dod_year}) do
    dod_year - dob_year 
  end
  
  def _calculate_age(%{"year" => year, "month" => month, "day" => day}, nil) do
    {:ok, dob_date} = Date.new(year, month, day)
    current_date = Timex.now
    Timex.diff(current_date, dob_date, :years)
  end
  
  def _calculate_age(%{"year" => year, "month" => month}, nil) do
    {:ok, dob_date} = Date.new(year, month, 1)
    current_date = Timex.now
    Timex.diff(current_date, dob_date, :years)
  end
  
  def _calculate_age(%{"year" => year}, nil) do
    {:ok, dob_date} = Date.new(year, 1, 1)
    current_date = Timex.now
    Timex.diff(current_date, dob_date, :years)
  end
  
  def calculate_age(_, _) do
    nil 
  end
end
