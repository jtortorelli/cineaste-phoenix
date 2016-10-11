alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

gorath = Repo.one from f in Film, where: f.title == "Gorath"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

ishiro_honda = Repo.one(by_name.("Ishiro", "Honda"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
jojiro_okami = Repo.one(by_name.("Jojiro", "Okami"))
kaoru_mabuchi = Repo.one(by_name.("Kaoru","Mabuchi"))
hajime_koizumi = Repo.one(by_name.("Hajime", "Koizumi"))
takeo_kita = Repo.one(by_name.("Takeo", "Kita"))
teruaki_abe = Repo.one(by_name.("Teruaki", "Abe"))
toshiya_ban = Repo.one(by_name.("Toshiya", "Ban"))
toshio_takashima = Repo.one(by_name.("Toshio", "Takashima"))
kan_ishii = Repo.one(by_name.("Kan", "Ishii"))
reiko_kaneko = Repo.one(by_name.("Reiko", "Kaneko"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))

roles = [
  %StaffPersonRole{
    film_id: gorath.id,
    person_id: ishiro_honda.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: gorath.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: gorath.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: gorath.id,
    person_id: jojiro_okami.id,
    role: "Original Story",
    order: 2
  },
  %StaffPersonRole{
    film_id: gorath.id,
    person_id: kaoru_mabuchi.id,
    role: "Screenplay",
    order: 3
  },
  %StaffPersonRole{
    film_id: gorath.id,
    person_id: hajime_koizumi.id,
    role: "Cinematography",
    order: 4
  },
  %StaffPersonRole{
    film_id: gorath.id,
    person_id: takeo_kita.id,
    role: "Art Director",
    order: 5
  },
  %StaffPersonRole{
    film_id: gorath.id,
    person_id: teruaki_abe.id,
    role: "Art Director",
    order: 6
  },
  %StaffPersonRole{
    film_id: gorath.id,
    person_id: toshiya_ban.id,
    role: "Sound Recording",
    order: 7
  },
  %StaffPersonRole{
    film_id: gorath.id,
    person_id: toshio_takashima.id,
    role: "Lighting",
    order: 8
  },
  %StaffPersonRole{
    film_id: gorath.id,
    person_id: kan_ishii.id,
    role: "Music",
    order: 9
  },
  %StaffPersonRole{
    film_id: gorath.id,
    person_id: reiko_kaneko.id,
    role: "Editor",
    order: 12
  },
  %StaffPersonRole{
    film_id: gorath.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Cinematography",
    order: 15
  }
]

from(role in StaffPersonRole, where: role.film_id == ^gorath.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
