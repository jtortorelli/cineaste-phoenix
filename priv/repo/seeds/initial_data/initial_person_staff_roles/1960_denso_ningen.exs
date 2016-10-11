alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

telegian = Repo.one from f in Film, where: f.title == "The Secret of the Telegian"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

jun_fukuda = Repo.one(by_name.("Jun","Fukuda"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
shinichi_sekizawa = Repo.one(by_name.("Shinichi", "Sekizawa"))
kazuo_yamada = Repo.one(by_name.("Kazuo", "Yamada"))
kyoe_hamagami = Repo.one(by_name.("Kyoe", "Hamagami"))
yoshio_nishikawa = Repo.one(by_name.("Yoshio", "Nishikawa"))
masanobu_miyazaki = Repo.one(by_name.("Masanobu", "Miyazaki"))
tsuruzo_nishikawa = Repo.one(by_name.("Tsuruzo", "Nishikawa"))
sei_ikeno = Repo.one(by_name.("Sei", "Ikeno"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))
kazuji_taira = Repo.one(by_name.("Kazuji", "Taira"))

roles = [
  %StaffPersonRole{
    film_id: telegian.id,
    person_id: jun_fukuda.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: telegian.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: telegian.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: telegian.id,
    person_id: shinichi_sekizawa.id,
    role: "Screenplay",
    order: 2
  },
  %StaffPersonRole{
    film_id: telegian.id,
    person_id: kazuo_yamada.id,
    role: "Cinematography",
    order: 3
  },
  %StaffPersonRole{
    film_id: telegian.id,
    person_id: kyoe_hamagami.id,
    role: "Art Director",
    order: 4
  },
  %StaffPersonRole{
    film_id: telegian.id,
    person_id: yoshio_nishikawa.id,
    role: "Sound Recording",
    order: 5
  },
  %StaffPersonRole{
    film_id: telegian.id,
    person_id: masanobu_miyazaki.id,
    role: "Sound Recording",
    order: 6
  },
  %StaffPersonRole{
    film_id: telegian.id,
    person_id: tsuruzo_nishikawa.id,
    role: "Lighting",
    order: 7
  },
  %StaffPersonRole{
    film_id: telegian.id,
    person_id: sei_ikeno.id,
    role: "Music",
    order: 8
  },
  %StaffPersonRole{
    film_id: telegian.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Cinematography",
    order: 10
  },
  %StaffPersonRole{
    film_id: telegian.id,
    person_id: kazuji_taira.id,
    role: "Editor",
    order: 15
  }
]

from(role in StaffPersonRole, where: role.film_id == ^telegian.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
