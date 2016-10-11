alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

human_vapor = Repo.one from f in Film, where: f.title == "The Human Vapor"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

ishiro_honda = Repo.one(by_name.("Ishiro", "Honda"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
kaoru_mabuchi = Repo.one(by_name.("Kaoru","Mabuchi"))
hajime_koizumi = Repo.one(by_name.("Hajime", "Koizumi"))
kiyoshi_shimizu = Repo.one(by_name.("Kiyoshi", "Shimizu"))
masao_fujiyoshi = Repo.one(by_name.("Masao", "Fujiyoshi"))
masanobu_miyazaki = Repo.one(by_name.("Masanobu", "Miyazaki"))
toshio_takashima = Repo.one(by_name.("Toshio", "Takashima"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))
kunio_miyauchi = Repo.one(by_name.("Kunio", "Miyauchi"))
kazuji_taira = Repo.one(by_name.("Kazuji", "Taira"))

roles = [
  %StaffPersonRole{
    film_id: human_vapor.id,
    person_id: ishiro_honda.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: human_vapor.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: human_vapor.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: human_vapor.id,
    person_id: kaoru_mabuchi.id,
    role: "Screenplay",
    order: 2
  },
  %StaffPersonRole{
    film_id: human_vapor.id,
    person_id: hajime_koizumi.id,
    role: "Cinematography",
    order: 3
  },
  %StaffPersonRole{
    film_id: human_vapor.id,
    person_id: kiyoshi_shimizu.id,
    role: "Art Director",
    order: 4
  },
  %StaffPersonRole{
    film_id: human_vapor.id,
    person_id: masao_fujiyoshi.id,
    role: "Sound Recording",
    order: 5
  },
  %StaffPersonRole{
    film_id: human_vapor.id,
    person_id: masanobu_miyazaki.id,
    role: "Sound Recording",
    order: 6
  },
  %StaffPersonRole{
    film_id: human_vapor.id,
    person_id: toshio_takashima.id,
    role: "Lighting",
    order: 7
  },
  %StaffPersonRole{
    film_id: human_vapor.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Cinematography",
    order: 9
  },
  %StaffPersonRole{
    film_id: human_vapor.id,
    person_id: kunio_miyauchi.id,
    role: "Music",
    order: 12
  },
  %StaffPersonRole{
    film_id: human_vapor.id,
    person_id: kazuji_taira.id,
    role: "Editor",
    order: 18
  }
]

from(role in StaffPersonRole, where: role.film_id == ^human_vapor.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
