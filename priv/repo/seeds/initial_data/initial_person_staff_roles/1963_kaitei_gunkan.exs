alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

atragon = Repo.one from f in Film, where: f.title == "Atragon"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

ishiro_honda = Repo.one(by_name.("Ishiro", "Honda"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
shinichi_sekizawa = Repo.one(by_name.("Shinichi", "Sekizawa"))
shunro_oshikawa = Repo.one(by_name.("Shunro", "Oshikawa"))
hajime_koizumi = Repo.one(by_name.("Hajime", "Koizumi"))
takeo_kita = Repo.one(by_name.("Takeo", "Kita"))
masanao_uehara = Repo.one(by_name.("Masanao", "Uehara"))
shoshichi_kojima = Repo.one(by_name.("Shoshichi", "Kojima"))
akira_ifukube = Repo.one(by_name.("Akira", "Ifukube"))
ryohei_fujii = Repo.one(by_name.("Ryohei", "Fujii"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))
teruyoshi_nakano = Repo.one(by_name.("Teruyoshi", "Nakano"))

roles = [
  %StaffPersonRole{
    film_id: atragon.id,
    person_id: ishiro_honda.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: atragon.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: atragon.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: atragon.id,
    person_id: shinichi_sekizawa.id,
    role: "Screenplay",
    order: 2
  },
  %StaffPersonRole{
    film_id: atragon.id,
    person_id: shunro_oshikawa.id,
    role: "Original Story",
    order: 3
  },
  %StaffPersonRole{
    film_id: atragon.id,
    person_id: hajime_koizumi.id,
    role: "Cinematography",
    order: 4
  },
  %StaffPersonRole{
    film_id: atragon.id,
    person_id: takeo_kita.id,
    role: "Art Director",
    order: 5
  },
  %StaffPersonRole{
    film_id: atragon.id,
    person_id: masanao_uehara.id,
    role: "Sound Recording",
    order: 6
  },
  %StaffPersonRole{
    film_id: atragon.id,
    person_id: shoshichi_kojima.id,
    role: "Lighting",
    order: 7
  },
  %StaffPersonRole{
    film_id: atragon.id,
    person_id: akira_ifukube.id,
    role: "Music",
    order: 8
  },
  %StaffPersonRole{
    film_id: atragon.id,
    person_id: ryohei_fujii.id,
    role: "Editor",
    order: 11
  },
  %StaffPersonRole{
    film_id: atragon.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Cinematography",
    order: 15
  },
  %StaffPersonRole{
    film_id: atragon.id,
    person_id: teruyoshi_nakano.id,
    role: "Special Effects Assistant Director",
    order: 22
  }
]

from(role in StaffPersonRole, where: role.film_id == ^atragon.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
