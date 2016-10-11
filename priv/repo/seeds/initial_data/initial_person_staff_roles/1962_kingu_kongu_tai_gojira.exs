alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

kkvg = Repo.one from f in Film, where: f.title == "King Kong vs. Godzilla"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

ishiro_honda = Repo.one(by_name.("Ishiro", "Honda"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
shinichi_sekizawa = Repo.one(by_name.("Shinichi", "Sekizawa"))
hajime_koizumi = Repo.one(by_name.("Hajime", "Koizumi"))
takeo_kita = Repo.one(by_name.("Takeo", "Kita"))
teruaki_abe = Repo.one(by_name.("Teruaki", "Abe"))
masao_fujiyoshi = Repo.one(by_name.("Masao", "Fujiyoshi"))
toshio_takashima = Repo.one(by_name.("Toshio", "Takashima"))
akira_ifukube = Repo.one(by_name.("Akira", "Ifukube"))
reiko_kaneko = Repo.one(by_name.("Reiko", "Kaneko"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))

roles = [
  %StaffPersonRole{
    film_id: kkvg.id,
    person_id: ishiro_honda.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: kkvg.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: kkvg.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: kkvg.id,
    person_id: shinichi_sekizawa.id,
    role: "Screenplay",
    order: 2
  },
  %StaffPersonRole{
    film_id: kkvg.id,
    person_id: hajime_koizumi.id,
    role: "Cinematography",
    order: 3
  },
  %StaffPersonRole{
    film_id: kkvg.id,
    person_id: takeo_kita.id,
    role: "Art Director",
    order: 4
  },
  %StaffPersonRole{
    film_id: kkvg.id,
    person_id: teruaki_abe.id,
    role: "Art Director",
    order: 5
  },
  %StaffPersonRole{
    film_id: kkvg.id,
    person_id: masao_fujiyoshi.id,
    role: "Sound Recording",
    order: 6
  },
  %StaffPersonRole{
    film_id: kkvg.id,
    person_id: toshio_takashima.id,
    role: "Lighting",
    order: 7
  },
  %StaffPersonRole{
    film_id: kkvg.id,
    person_id: akira_ifukube.id,
    role: "Music",
    order: 8
  },
  %StaffPersonRole{
    film_id: kkvg.id,
    person_id: reiko_kaneko.id,
    role: "Editor",
    order: 11
  },
  %StaffPersonRole{
    film_id: kkvg.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Cinematography",
    order: 14
  }
]

from(role in StaffPersonRole, where: role.film_id == ^kkvg.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
