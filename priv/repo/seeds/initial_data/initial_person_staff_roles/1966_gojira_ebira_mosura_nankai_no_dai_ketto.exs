alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

sea_monster = Repo.one from f in Film, where: f.title == "Godzilla vs. the Sea Monster"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

jun_fukuda = Repo.one(by_name.("Jun", "Fukuda"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
shinichi_sekizawa = Repo.one(by_name.("Shinichi", "Sekizawa"))
kazuo_yamada = Repo.one(by_name.("Kazuo", "Yamada"))
takeo_kita = Repo.one(by_name.("Takeo", "Kita"))
shoichi_yoshizawa = Repo.one(by_name.("Shoichi", "Yoshizawa"))
norikazu_onda = Repo.one(by_name.("Norikazu", "Onda"))
masaru_sato = Repo.one(by_name.("Masaru", "Sato"))
ryohei_fujii = Repo.one(by_name.("Ryohei", "Fujii"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))
yasuyuki_inoue = Repo.one(by_name.("Yasuyuki", "Inoue"))
teruyoshi_nakano = Repo.one(by_name.("Teruyoshi", "Nakano"))

roles = [
  %StaffPersonRole{
    film_id: sea_monster.id,
    person_id: jun_fukuda.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: sea_monster.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: sea_monster.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: sea_monster.id,
    person_id: shinichi_sekizawa.id,
    role: "Screenplay",
    order: 2
  },
  %StaffPersonRole{
    film_id: sea_monster.id,
    person_id: kazuo_yamada.id,
    role: "Cinematography",
    order: 3
  },
  %StaffPersonRole{
    film_id: sea_monster.id,
    person_id: takeo_kita.id,
    role: "Art Director",
    order: 4
  },
  %StaffPersonRole{
    film_id: sea_monster.id,
    person_id: shoichi_yoshizawa.id,
    role: "Sound Recording",
    order: 5
  },
  %StaffPersonRole{
    film_id: sea_monster.id,
    person_id: norikazu_onda.id,
    role: "Lighting",
    order: 6
  },
  %StaffPersonRole{
    film_id: sea_monster.id,
    person_id: masaru_sato.id,
    role: "Music",
    order: 7
  },
  %StaffPersonRole{
    film_id: sea_monster.id,
    person_id: ryohei_fujii.id,
    role: "Editor",
    order: 10
  },
  %StaffPersonRole{
    film_id: sea_monster.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Assistant Director",
    order: 14
  },
  %StaffPersonRole{
    film_id: sea_monster.id,
    person_id: yasuyuki_inoue.id,
    role: "Special Effects Art Director",
    order: 17
  },
  %StaffPersonRole{
    film_id: sea_monster.id,
    person_id: teruyoshi_nakano.id,
    role: "Special Effects Assistant Director",
    order: 21
  }
]

from(role in StaffPersonRole, where: role.film_id == ^sea_monster.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
