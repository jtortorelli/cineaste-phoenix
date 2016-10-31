alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Group
alias Cineaste.Film
alias Cineaste.ActorGroupRole

mothra = Repo.one from f in Film, where: f.title == "Mothra"
mvg = Repo.one from f in Film, where: f.title == "Mothra vs. Godzilla"
ghidorah = Repo.one from f in Film, where: f.title == "Ghidorah, the Three-Headed Monster"
sea_monster = Repo.one from f in Film, where: f.title == "Godzilla vs. the Sea Monster"

shobijin = Repo.one from g in Group, where: g.name == "The Peanuts"
bambi_pair = Repo.one from g in Group, where: g.name == "The Bambi Pair"

roles = [
  %ActorGroupRole{
    film_id: mothra.id,
    group_id: shobijin.id,
    roles: ["The Shobijin"],
    order: 4
  },
  %ActorGroupRole{
    film_id: mvg.id,
    group_id: shobijin.id,
    roles: ["The Shobijin"],
    order: 6
  },
  %ActorGroupRole{
    film_id: ghidorah.id,
    group_id: shobijin.id,
    roles: ["The Shobijin"],
    order: 5
  },
  %ActorGroupRole{
    film_id: sea_monster.id,
    group_id: bambi_pair.id,
    roles: ["The Shobijin"],
    order: 27
  }
]

from(role in ActorGroupRole, where: role.film_id in [^mothra.id, ^mvg.id, ^ghidorah.id, ^sea_monster.id]) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)