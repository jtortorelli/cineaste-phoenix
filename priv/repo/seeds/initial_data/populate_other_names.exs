alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Person

people = Repo.all(Person)

populate_other_names = fn(%Person{} = person) ->
  other_names = %{}
  if person.original_name do
    other_names = Map.put(other_names, :original_name, person.original_name) 
  end
  if person.japanese_name do
    other_names = Map.put(other_names, :japanese_name, person.japanese_name) 
  end
  if person.birth_name do
    other_names = Map.put(other_names, :birth_name, person.birth_name) 
  end
  person_changeset = Ecto.Changeset.change person, other_names: other_names
  case Repo.update person_changeset do
    {:ok, struct} -> "succeeded for #{person.given_name} #{person.family_name}"
    {:error, changeset} -> "failed for #{person.given_name} #{person.family_name}" 
  end
end
  
Enum.map(people, fn(x) -> populate_other_names.(x) end)