alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

king_kong_escapes = Repo.one from f in Film, where: f.title == "King Kong Escapes"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

ishiro_honda = Repo.one(by_name.("Ishiro", "Honda"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
kaoru_mabuchi = Repo.one(by_name.("Kaoru","Mabuchi"))
arthur_rankin = Repo.one(by_name.("Arthur", "Rankin"))
hajime_koizumi = Repo.one(by_name.("Hajime", "Koizumi"))
takeo_kita = Repo.one(by_name.("Takeo", "Kita"))
shoichi_yoshizawa = Repo.one(by_name.("Shoichi", "Yoshizawa"))
toshio_takashima = Repo.one(by_name.("Toshio", "Takashima"))
akira_ifukube = Repo.one(by_name.("Akira", "Ifukube"))
ryohei_fujii = Repo.one(by_name.("Ryohei", "Fujii"))
yasuyuki_inoue = Repo.one(by_name.("Yasuyuki", "Inoue"))
teruyoshi_nakano = Repo.one(by_name.("Teruyoshi", "Nakano"))

roles = [
  %StaffPersonRole{
    film_id: king_kong_escapes.id,
    person_id: ishiro_honda.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: king_kong_escapes.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: king_kong_escapes.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: king_kong_escapes.id,
    person_id: kaoru_mabuchi.id,
    role: "Screenplay",
    order: 2
  },
  %StaffPersonRole{
    film_id: king_kong_escapes.id,
    person_id: arthur_rankin.id,
    role: "Technical Advisor",
    order: 3
  },
  %StaffPersonRole{
    film_id: king_kong_escapes.id,
    person_id: hajime_koizumi.id,
    role: "Cinematography",
    order: 4
  },
  %StaffPersonRole{
    film_id: king_kong_escapes.id,
    person_id: takeo_kita.id,
    role: "Art Director",
    order: 5
  },
  %StaffPersonRole{
    film_id: king_kong_escapes.id,
    person_id: shoichi_yoshizawa.id,
    role: "Sound Recording",
    order: 6
  },
  %StaffPersonRole{
    film_id: king_kong_escapes.id,
    person_id: toshio_takashima.id,
    role: "Lighting",
    order: 7
  },
  %StaffPersonRole{
    film_id: king_kong_escapes.id,
    person_id: akira_ifukube.id,
    role: "Music",
    order: 8
  },
  %StaffPersonRole{
    film_id: king_kong_escapes.id,
    person_id: ryohei_fujii.id,
    role: "Editor",
    order: 11
  },
  %StaffPersonRole{
    film_id: king_kong_escapes.id,
    person_id: yasuyuki_inoue.id,
    role: "Special Effects Art Director",
    order: 18
  },
  %StaffPersonRole{
    film_id: king_kong_escapes.id,
    person_id: teruyoshi_nakano.id,
    role: "Special Effects Assistant Director",
    order: 22
  }
]

from(role in StaffPersonRole, where: role.film_id == ^king_kong_escapes.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
