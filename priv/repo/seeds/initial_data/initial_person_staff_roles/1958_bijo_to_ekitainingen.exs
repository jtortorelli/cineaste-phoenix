alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

h_man = Repo.one from f in Film, where: f.title == "The H-Man"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

ishiro_honda = Repo.one(by_name.("Ishiro", "Honda"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
hideo_unagami = Repo.one(by_name.("Hideo", "Unagami"))
shinichi_sekizawa = Repo.one(by_name.("Shinichi", "Sekizawa"))
hajime_koizumi = Repo.one(by_name.("Hajime", "Koizumi"))
takeo_kita = Repo.one(by_name.("Takeo", "Kita"))
choshichiro_mikami = Repo.one(by_name.("Choshichiro", "Mikami"))
masanobu_miyazaki = Repo.one(by_name.("Masanobu", "Miyazaki"))
tsuruzo_nishikawa = Repo.one(by_name.("Tsuruzo", "Nishikawa"))
masaru_sato = Repo.one(by_name.("Masaru", "Sato"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))
kazuji_taira = Repo.one(by_name.("Kazuji", "Taira"))

roles = [
  %StaffPersonRole{
    film_id: h_man.id,
    person_id: ishiro_honda.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: h_man.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: h_man.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: h_man.id,
    person_id: hideo_unagami.id,
    role: "Original Story",
    order: 2
  },
  %StaffPersonRole{
    film_id: h_man.id,
    person_id: shinichi_sekizawa.id,
    role: "Screenplay",
    order: 3
  },
  %StaffPersonRole{
    film_id: h_man.id,
    person_id: hajime_koizumi.id,
    role: "Cinematography",
    order: 4
  },
  %StaffPersonRole{
    film_id: h_man.id,
    person_id: takeo_kita.id,
    role: "Art Director",
    order: 5
  },
  %StaffPersonRole{
    film_id: h_man.id,
    person_id: choshichiro_mikami.id,
    role: "Sound Recording",
    order: 6
  },
  %StaffPersonRole{
    film_id: h_man.id,
    person_id: masanobu_miyazaki.id,
    role: "Sound Recording",
    order: 7
  },
  %StaffPersonRole{
    film_id: h_man.id,
    person_id: tsuruzo_nishikawa.id,
    role: "Lighting",
    order: 8
  },
  %StaffPersonRole{
    film_id: h_man.id,
    person_id: masaru_sato.id,
    role: "Music",
    order: 9
  },
  %StaffPersonRole{
    film_id: h_man.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Cinematography",
    order: 11
  },
  %StaffPersonRole{
    film_id: h_man.id,
    person_id: kazuji_taira.id,
    role: "Editor",
    order: 16
  }
]

from(role in StaffPersonRole, where: role.film_id == ^h_man.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
