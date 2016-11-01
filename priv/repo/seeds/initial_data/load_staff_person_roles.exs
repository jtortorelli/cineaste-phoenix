alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

[filename | _] = System.argv
IO.inspect filename
true = File.exists?(filename)
true = File.regular?(filename)
body = File.read!(filename)
lines = String.split(body, "\n")
[title | roles] = lines
film_model = Repo.one from f in Film, where: f.title == ^title
IO.inspect film_model

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

convert_to_model = fn(role, film_model) ->
  IO.inspect(role)
  [given_name, family_name, order, role] = String.split(role, ",")
  person_model = by_name.(given_name, family_name)
  %StaffPersonRole{
    film_id: film_model.id,
    person_id: person_model.id,
    order: String.to_integer(order),
    role: role
  }
end

staff_person_roles = Enum.map(roles, fn(role) -> convert_to_model.(role, film_model) end)

from(role in StaffPersonRole, where: role.film_id == ^film_model.id) |> Repo.delete_all

Enum.each(staff_person_roles, fn x -> Repo.insert! x end)