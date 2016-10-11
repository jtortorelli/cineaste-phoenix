alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

battle_in_outer_space = Repo.one from f in Film, where: f.title == "Battle in Outer Space"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

ishiro_honda = Repo.one(by_name.("Ishiro", "Honda"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
jojiro_okami = Repo.one(by_name.("Jojiro", "Okami"))
shinichi_sekizawa = Repo.one(by_name.("Shinichi", "Sekizawa"))
hajime_koizumi = Repo.one(by_name.("Hajime", "Koizumi"))
teruaki_abe = Repo.one(by_name.("Teruaki", "Abe"))
rokuro_ishikawa = Repo.one(by_name.("Rokuro", "Ishikawa"))
choshichiro_mikami = Repo.one(by_name.("Choshichiro", "Mikami"))
masanobu_miyazaki = Repo.one(by_name.("Masanobu", "Miyazaki"))
akira_ifukube = Repo.one(by_name.("Akira", "Ifukube"))
kazuji_taira = Repo.one(by_name.("Kazuji", "Taira"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))

roles = [
  %StaffPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: ishiro_honda.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: jojiro_okami.id,
    role: "Original Story",
    order: 2
  },
  %StaffPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: shinichi_sekizawa.id,
    role: "Screenplay",
    order: 3
  },
  %StaffPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: hajime_koizumi.id,
    role: "Cinematography",
    order: 4
  },
  %StaffPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: teruaki_abe.id,
    role: "Art Director",
    order: 5
  },
  %StaffPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: rokuro_ishikawa.id,
    role: "Lighting",
    order: 6
  },
  %StaffPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: choshichiro_mikami.id,
    role: "Sound Recording",
    order: 7
  },
  %StaffPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: masanobu_miyazaki.id,
    role: "Sound Recording",
    order: 8
  },
  %StaffPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: akira_ifukube.id,
    role: "Music",
    order: 9
  },
  %StaffPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: kazuji_taira.id,
    role: "Editor",
    order: 11
  },
  %StaffPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Cinematography",
    order: 15
  }
]

from(role in StaffPersonRole, where: role.film_id == ^battle_in_outer_space.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
