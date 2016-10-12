alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

gargantuas = Repo.one from f in Film, where: f.title == "War of the Gargantuas"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

ishiro_honda = Repo.one(by_name.("Ishiro", "Honda"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
kenichiro_tsunoda = Repo.one(by_name.("Kenichiro", "Tsunoda"))
kaoru_mabuchi = Repo.one(by_name.("Kaoru","Mabuchi"))
hajime_koizumi = Repo.one(by_name.("Hajime", "Koizumi"))
takeo_kita = Repo.one(by_name.("Takeo", "Kita"))
norio_tone = Repo.one(by_name.("Norio", "Tone"))
toshio_takashima = Repo.one(by_name.("Toshio", "Takashima"))
akira_ifukube = Repo.one(by_name.("Akira", "Ifukube"))
ryohei_fujii = Repo.one(by_name.("Ryohei", "Fujii"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))
yasuyuki_inoue = Repo.one(by_name.("Yasuyuki", "Inoue"))
teruyoshi_nakano = Repo.one(by_name.("Teruyoshi", "Nakano"))

roles = [
  %StaffPersonRole{
    film_id: gargantuas.id,
    person_id: ishiro_honda.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: gargantuas.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: gargantuas.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: gargantuas.id,
    person_id: kenichiro_tsunoda.id,
    role: "Producer",
    order: 2
  },
  %StaffPersonRole{
    film_id: gargantuas.id,
    person_id: kaoru_mabuchi.id,
    role: "Screenplay",
    order: 3
  },
  %StaffPersonRole{
    film_id: gargantuas.id,
    person_id: ishiro_honda.id,
    role: "Screenplay",
    order: 4
  },
  %StaffPersonRole{
    film_id: gargantuas.id,
    person_id: hajime_koizumi.id,
    role: "Cinematography",
    order: 5
  },
  %StaffPersonRole{
    film_id: gargantuas.id,
    person_id: takeo_kita.id,
    role: "Art Director",
    order: 6
  },
  %StaffPersonRole{
    film_id: gargantuas.id,
    person_id: norio_tone.id,
    role: "Sound Recording",
    order: 7
  },
  %StaffPersonRole{
    film_id: gargantuas.id,
    person_id: toshio_takashima.id,
    role: "Lighting",
    order: 8
  },
  %StaffPersonRole{
    film_id: gargantuas.id,
    person_id: akira_ifukube.id,
    role: "Music",
    order: 9
  },
  %StaffPersonRole{
    film_id: gargantuas.id,
    person_id: ryohei_fujii.id,
    role: "Editor",
    order: 12
  },
  %StaffPersonRole{
    film_id: gargantuas.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Cinematography",
    order: 16
  },
  %StaffPersonRole{
    film_id: gargantuas.id,
    person_id: yasuyuki_inoue.id,
    role: "Special Effects Art Director",
    order: 19
  },
  %StaffPersonRole{
    film_id: gargantuas.id,
    person_id: teruyoshi_nakano.id,
    role: "Special Effects Assistant Director",
    order: 23
  }
]

from(role in StaffPersonRole, where: role.film_id == ^gargantuas.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
