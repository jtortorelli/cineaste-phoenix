alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

mothra = Repo.one from f in Film, where: f.title == "Mothra"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

ishiro_honda = Repo.one(by_name.("Ishiro", "Honda"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
shinichiro_nakamura = Repo.one(by_name.("Shinichiro", "Nakamura"))
takehiko_fukunaga = Repo.one(by_name.("Takehiko", "Fukunaga"))
yoshie_hotta = Repo.one(by_name.("Yoshie", "Hotta"))
shinichi_sekizawa = Repo.one(by_name.("Shinichi", "Sekizawa"))
hajime_koizumi = Repo.one(by_name.("Hajime", "Koizumi"))
takeo_kita = Repo.one(by_name.("Takeo", "Kita"))
teruaki_abe = Repo.one(by_name.("Teruaki", "Abe"))
shoichi_fujinawa = Repo.one(by_name.("Shoichi", "Fujinawa"))
masanobu_miyazaki = Repo.one(by_name.("Masanobu", "Miyazaki"))
toshio_takashima = Repo.one(by_name.("Toshio", "Takashima"))
yuji_koseki = Repo.one(by_name.("Yuji", "Koseki"))
kazuji_taira = Repo.one(by_name.("Kazuji", "Taira"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))


roles = [
  %StaffPersonRole{
    film_id: mothra.id,
    person_id: ishiro_honda.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: mothra.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: mothra.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: mothra.id,
    person_id: shinichiro_nakamura.id,
    role: "Original Story",
    order: 2
  },
  %StaffPersonRole{
    film_id: mothra.id,
    person_id: takehiko_fukunaga.id,
    role: "Original Story",
    order: 3
  },
  %StaffPersonRole{
    film_id: mothra.id,
    person_id: yoshie_hotta.id,
    role: "Original Story",
    order: 4
  },
  %StaffPersonRole{
    film_id: mothra.id,
    person_id: shinichi_sekizawa.id,
    role: "Screenplay",
    order: 5
  },
  %StaffPersonRole{
    film_id: mothra.id,
    person_id: hajime_koizumi.id,
    role: "Cinematography",
    order: 6
  },
  %StaffPersonRole{
    film_id: mothra.id,
    person_id: takeo_kita.id,
    role: "Art Director",
    order: 7
  },
  %StaffPersonRole{
    film_id: mothra.id,
    person_id: teruaki_abe.id,
    role: "Art Director",
    order: 8
  },
  %StaffPersonRole{
    film_id: mothra.id,
    person_id: shoichi_fujinawa.id,
    role: "Sound Recording",
    order: 9
  },
  %StaffPersonRole{
    film_id: mothra.id,
    person_id: masanobu_miyazaki.id,
    role: "Sound Recording",
    order: 10
  },
  %StaffPersonRole{
    film_id: mothra.id,
    person_id: toshio_takashima.id,
    role: "Lighting",
    order: 11
  },
  %StaffPersonRole{
    film_id: mothra.id,
    person_id: yuji_koseki.id,
    role: "Music",
    order: 12
  },
  %StaffPersonRole{
    film_id: mothra.id,
    person_id: kazuji_taira.id,
    role: "Editor",
    order: 17
  },
  %StaffPersonRole{
    film_id: mothra.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Cinematography",
    order: 20
  }
]

from(role in StaffPersonRole, where: role.film_id == ^mothra.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
