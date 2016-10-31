alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

last_war = Repo.one from f in Film, where: f.title == "The Last War"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

shue_matsubayashi = Repo.one(by_name.("Shue", "Matsubayashi"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
sanezumi_fujimoto = Repo.one(by_name.("Sanezumi", "Fujimoto"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
toshio_yasumi = Repo.one(by_name.("Toshio", "Yasumi"))
kaoru_mabuchi = Repo.one(by_name.("Kaoru","Mabuchi"))
rokuro_nishigaki = Repo.one(by_name.("Rokuro", "Nishigaki"))
takeo_kita = Repo.one(by_name.("Takeo", "Kita"))
teruaki_abe = Repo.one(by_name.("Teruaki", "Abe"))
fumio_yanoguchi = Repo.one(by_name.("Fumio", "Yanoguchi"))
hiromitsu_mori = Repo.one(by_name.("Hiromitsu", "Mori"))
ikuma_dan = Repo.one(by_name.("Ikuma", "Dan"))
koichi_iwashita = Repo.one(by_name.("Koichi","Iwashita"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))

roles = [
  %StaffPersonRole{
    film_id: last_war.id,
    person_id: shue_matsubayashi.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: last_war.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: last_war.id,
    person_id: sanezumi_fujimoto.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: last_war.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 2
  },
  %StaffPersonRole{
    film_id: last_war.id,
    person_id: toshio_yasumi.id,
    role: "Screenplay",
    order: 3
  },
  %StaffPersonRole{
    film_id: last_war.id,
    person_id: kaoru_mabuchi.id,
    role: "Screenplay",
    order: 4
  },
  %StaffPersonRole{
    film_id: last_war.id,
    person_id: rokuro_nishigaki.id,
    role: "Cinematography",
    order: 5
  },
  %StaffPersonRole{
    film_id: last_war.id,
    person_id: takeo_kita.id,
    role: "Art Director",
    order: 6
  },
  %StaffPersonRole{
    film_id: last_war.id,
    person_id: teruaki_abe.id,
    role: "Art Director",
    order: 7
  },
  %StaffPersonRole{
    film_id: last_war.id,
    person_id: fumio_yanoguchi.id,
    role: "Sound Recording",
    order: 8
  },
  %StaffPersonRole{
    film_id: last_war.id,
    person_id: hiromitsu_mori.id,
    role: "Lighting",
    order: 9
  },
  %StaffPersonRole{
    film_id: last_war.id,
    person_id: ikuma_dan.id,
    role: "Music",
    order: 10
  },
  %StaffPersonRole{
    film_id: last_war.id,
    person_id: koichi_iwashita.id,
    role: "Editor",
    order: 13
  },
  %StaffPersonRole{
    film_id: last_war.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Cinematography",
    order: 16
  }
]

from(role in StaffPersonRole, where: role.film_id == ^last_war.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
