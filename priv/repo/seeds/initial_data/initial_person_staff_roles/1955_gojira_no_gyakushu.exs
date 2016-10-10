alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

godzilla_raids_again = Repo.one from f in Film, where: f.title == "Godzilla Raids Again"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

motoyoshi_oda = Repo.one(by_name.("Motoyoshi", "Oda"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
shigeru_kayama = Repo.one(by_name.("Shigeru", "Kayama"))
takeo_murata = Repo.one(by_name.("Takeo", "Murata"))
shigeaki_hidaka = Repo.one(by_name.("Shigeaki", "Hidaka"))
seiichi_endo = Repo.one(by_name.("Seiichi", "Endo"))
takeo_kita = Repo.one(by_name.("Takeo", "Kita"))
masanobu_miyazaki = Repo.one(by_name.("Masanobu", "Miyazaki"))
masaki_onuma = Repo.one(by_name.("Masaki", "Onuma"))
masaru_sato = Repo.one(by_name.("Masaru", "Sato"))
kazuji_taira = Repo.one(by_name.("Kazuji", "Taira"))

roles = [
  %StaffPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: motoyoshi_oda.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: shigeru_kayama.id,
    role: "Original Story",
    order: 2
  },
  %StaffPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: takeo_murata.id,
    role: "Screenplay",
    order: 3
  },
  %StaffPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: shigeaki_hidaka.id,
    role: "Screenplay",
    order: 4
  },
  %StaffPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: seiichi_endo.id,
    role: "Cinematography",
    order: 5
  },
  %StaffPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: takeo_kita.id,
    role: "Art Director",
    order: 6
  },
  %StaffPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: masanobu_miyazaki.id,
    role: "Sound Recording",
    order: 8
  },
  %StaffPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: masaki_onuma.id,
    role: "Lighting",
    order: 9
  },
  %StaffPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: masaru_sato.id,
    role: "Music",
    order: 10
  },
  %StaffPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: kazuji_taira.id,
    role: "Editor",
    order: 16
  }
]

from(role in StaffPersonRole, where: role.film_id == ^godzilla_raids_again.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
