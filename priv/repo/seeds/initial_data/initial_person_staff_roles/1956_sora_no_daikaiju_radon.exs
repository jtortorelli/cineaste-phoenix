alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

rodan = Repo.one from f in Film, where: f.title == "Rodan"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

ishiro_honda = Repo.one(by_name.("Ishiro", "Honda"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
ken_kuronuma = Repo.one(by_name.("Ken","Kuronuma"))
takeo_murata = Repo.one(by_name.("Takeo", "Murata"))
kaoru_mabuchi = Repo.one(by_name.("Kaoru","Mabuchi"))
isamu_ashida = Repo.one(by_name.("Isamu","Ashida"))
takeo_kita = Repo.one(by_name.("Takeo", "Kita"))
masanobu_miyazaki = Repo.one(by_name.("Masanobu", "Miyazaki"))
shigeru_mori = Repo.one(by_name.("Shigeru","Mori"))
akira_ifukube = Repo.one(by_name.("Akira", "Ifukube"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
jun_fukuda = Repo.one(by_name.("Jun","Fukuda"))
koichi_iwashita = Repo.one(by_name.("Koichi","Iwashita"))

roles = [
  %StaffPersonRole{
    film_id: rodan.id,
    person_id: ishiro_honda.id,
    role: "Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: rodan.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: rodan.id,
    person_id: ken_kuronuma.id,
    role: "Original Story",
    order: 2
  },
  %StaffPersonRole{
    film_id: rodan.id,
    person_id: takeo_murata.id,
    role: "Screenplay",
    order: 3
  },
  %StaffPersonRole{
    film_id: rodan.id,
    person_id: kaoru_mabuchi.id,
    role: "Screenplay",
    order: 4
  },
  %StaffPersonRole{
    film_id: rodan.id,
    person_id: isamu_ashida.id,
    role: "Cinematography",
    order: 5
  },
  %StaffPersonRole{
    film_id: rodan.id,
    person_id: takeo_kita.id,
    role: "Art Director",
    order: 6
  },
  %StaffPersonRole{
    film_id: rodan.id,
    person_id: masanobu_miyazaki.id,
    role: "Sound Recording",
    order: 7
  },
  %StaffPersonRole{
    film_id: rodan.id,
    person_id: shigeru_mori.id,
    role: "Lighting",
    order: 7
  },
  %StaffPersonRole{
    film_id: rodan.id,
    person_id: akira_ifukube.id,
    role: "Music",
    order: 9
  },
  %StaffPersonRole{
    film_id: rodan.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: 10
  },
  %StaffPersonRole{
    film_id: rodan.id,
    person_id: jun_fukuda.id,
    role: "Assistant Director",
    order: 15
  },
  %StaffPersonRole{
    film_id: rodan.id,
    person_id: koichi_iwashita.id,
    role: "Editor",
    order: 16
  }
]

from(role in StaffPersonRole, where: role.film_id == ^rodan.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
