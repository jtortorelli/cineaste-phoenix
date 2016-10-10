alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

varan = Repo.one from f in Film, where: f.title == "Varan the Unbelievable"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

ishiro_honda = Repo.one(by_name.("Ishiro", "Honda"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
ken_kuronuma = Repo.one(by_name.("Ken","Kuronuma"))
shinichi_sekizawa = Repo.one(by_name.("Shinichi", "Sekizawa"))
hajime_koizumi = Repo.one(by_name.("Hajime", "Koizumi"))
kiyoshi_shimizu = Repo.one(by_name.("Kiyoshi", "Shimizu"))
wataru_konuma = Repo.one(by_name.("Wataru", "Konuma"))
masanobu_miyazaki = Repo.one(by_name.("Masanobu", "Miyazaki"))
mitsuo_kaneko = Repo.one(by_name.("Mitsuo", "Kaneko"))
akira_ifukube = Repo.one(by_name.("Akira", "Ifukube"))
koichi_iwashita = Repo.one(by_name.("Koichi","Iwashita"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))

roles = [
  %StaffPersonRole{
    film_id: varan.id,
    person_id: ishiro_honda.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: varan.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: varan.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: varan.id,
    person_id: ken_kuronuma.id,
    role: "Original Story",
    order: 2
  },
  %StaffPersonRole{
    film_id: varan.id,
    person_id: shinichi_sekizawa.id,
    role: "Screenplay",
    order: 3
  },
  %StaffPersonRole{
    film_id: varan.id,
    person_id: hajime_koizumi.id,
    role: "Cinematography",
    order: 4
  },
  %StaffPersonRole{
    film_id: varan.id,
    person_id: kiyoshi_shimizu.id,
    role: "Art Director",
    order: 5
  },
  %StaffPersonRole{
    film_id: varan.id,
    person_id: wataru_konuma.id,
    role: "Sound Recording",
    order: 6
  },
  %StaffPersonRole{
    film_id: varan.id,
    person_id: masanobu_miyazaki.id,
    role: "Sound Recording",
    order: 7
  },
  %StaffPersonRole{
    film_id: varan.id,
    person_id: mitsuo_kaneko.id,
    role: "Lighting",
    order: 8
  },
  %StaffPersonRole{
    film_id: varan.id,
    person_id: akira_ifukube.id,
    role: "Music",
    order: 9
  },
  %StaffPersonRole{
    film_id: varan.id,
    person_id: koichi_iwashita.id,
    role: "Editor",
    order: 12
  },
  %StaffPersonRole{
    film_id: varan.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Cinematography",
    order: 15
  }
]

from(role in StaffPersonRole, where: role.film_id == ^varan.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
