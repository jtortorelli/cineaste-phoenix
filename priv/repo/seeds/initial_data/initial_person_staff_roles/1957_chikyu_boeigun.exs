alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

mysterians = Repo.one from f in Film, where: f.title == "The Mysterians"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

ishiro_honda = Repo.one(by_name.("Ishiro", "Honda"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
jojiro_okami = Repo.one(by_name.("Jojiro", "Okami"))
shigeru_kayama = Repo.one(by_name.("Shigeru", "Kayama"))
kaoru_mabuchi = Repo.one(by_name.("Kaoru","Mabuchi"))
hajime_koizumi = Repo.one(by_name.("Hajime", "Koizumi"))
teruaki_abe = Repo.one(by_name.("Teruaki", "Abe"))
masanobu_miyazaki = Repo.one(by_name.("Masanobu", "Miyazaki"))
kuichiro_kishida = Repo.one(by_name.("Kuichiro", "Kishida"))
akira_ifukube = Repo.one(by_name.("Akira", "Ifukube"))
koichi_iwashita = Repo.one(by_name.("Koichi","Iwashita"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))

roles = [
  %StaffPersonRole{
    film_id: mysterians.id,
    person_id: ishiro_honda.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: mysterians.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: mysterians.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: mysterians.id,
    person_id: jojiro_okami.id,
    role: "Original Story",
    order: 2
  },
  %StaffPersonRole{
    film_id: mysterians.id,
    person_id: shigeru_kayama.id,
    role: "Screenplay",
    order: 3
  },
  %StaffPersonRole{
    film_id: mysterians.id,
    person_id: kaoru_mabuchi.id,
    role: "Screenplay",
    order: 4
  },
  %StaffPersonRole{
    film_id: mysterians.id,
    person_id: hajime_koizumi.id,
    role: "Cinematography",
    order: 5
  },
  %StaffPersonRole{
    film_id: mysterians.id,
    person_id: teruaki_abe.id,
    role: "Art Director",
    order: 6
  },
  %StaffPersonRole{
    film_id: mysterians.id,
    person_id: masanobu_miyazaki.id,
    role: "Sound Recording",
    order: 7
  },
  %StaffPersonRole{
    film_id: mysterians.id,
    person_id: kuichiro_kishida.id,
    role: "Lighting",
    order: 8
  },
  %StaffPersonRole{
    film_id: mysterians.id,
    person_id: akira_ifukube.id,
    role: "Music",
    order: 9
  },
  %StaffPersonRole{
    film_id: mysterians.id,
    person_id: koichi_iwashita.id,
    role: "Editor",
    order: 12
  },
  %StaffPersonRole{
    film_id: mysterians.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Cinematography",
    order: 16
  }
]

from(role in StaffPersonRole, where: role.film_id == ^mysterians.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
