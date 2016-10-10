alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

invisible_man = Repo.one from f in Film, where: f.title == "The Invisible Man"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

motoyoshi_oda = Repo.one(by_name.("Motoyoshi", "Oda"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
takeo_kita = Repo.one(by_name.("Takeo", "Kita"))
kei_beppu = Repo.one(by_name.("Kei", "Beppu"))
shigeaki_hidaka = Repo.one(by_name.("Shigeaki", "Hidaka"))
teruaki_abe = Repo.one(by_name.("Teruaki", "Abe"))
shoichi_fujinawa = Repo.one(by_name.("Shoichi", "Fujinawa"))
kuichiro_kishida = Repo.one(by_name.("Kuichiro", "Kishida"))
kyosuke_kami = Repo.one(by_name.("Kyosuke", "Kami"))
shuichi_ihara = Repo.one(by_name.("Shuichi", "Ihara"))

roles = [
  %StaffPersonRole{
    film_id: invisible_man.id,
    person_id: motoyoshi_oda.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: invisible_man.id,
    person_id: eiji_tsuburaya.id,
    role: "Cinematography",
    order: -1
  },
  %StaffPersonRole{
    film_id: invisible_man.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Supervisor",
    order: -1
  },
  %StaffPersonRole{
    film_id: invisible_man.id,
    person_id: takeo_kita.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: invisible_man.id,
    person_id: kei_beppu.id,
    role: "Original Story",
    order: 2
  },
  %StaffPersonRole{
    film_id: invisible_man.id,
    person_id: shigeaki_hidaka.id,
    role: "Screenplay",
    order: 3
  },
  %StaffPersonRole{
    film_id: invisible_man.id,
    person_id: teruaki_abe.id,
    role: "Art Director",
    order: 4
  },
  %StaffPersonRole{
    film_id: invisible_man.id,
    person_id: shoichi_fujinawa.id,
    role: "Sound Recording",
    order: 5
  },
  %StaffPersonRole{
    film_id: invisible_man.id,
    person_id: kuichiro_kishida.id,
    role: "Lighting",
    order: 6
  },
  %StaffPersonRole{
    film_id: invisible_man.id,
    person_id: kyosuke_kami.id,
    role: "Music",
    order: 7
  },
  %StaffPersonRole{
    film_id: invisible_man.id,
    person_id: shuichi_ihara.id,
    role: "Editor",
    order: 9
  }
]

from(role in StaffPersonRole, where: role.film_id == ^invisible_man.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
