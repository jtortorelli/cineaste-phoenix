alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

godzilla_1954 = Repo.one from f in Film, where: f.title == "Godzilla, King of the Monsters"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

ishiro_honda = Repo.one(by_name.("Ishiro", "Honda"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
shigeru_kayama = Repo.one(by_name.("Shigeru", "Kayama"))
takeo_murata = Repo.one(by_name.("Takeo", "Murata"))
masao_tamai = Repo.one(by_name.("Masao", "Tamai"))
takeo_kita = Repo.one(by_name.("Takeo", "Kita"))
hisashi_shimonaga = Repo.one(by_name.("Hisashi", "Shimonaga"))
choshiro_ishii = Repo.one(by_name.("Choshiro", "Ishii"))
akira_ifukube = Repo.one(by_name.("Akira", "Ifukube"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
kazuji_taira = Repo.one(by_name.("Kazuji", "Taira"))

roles = [
  %StaffPersonRole{
    film_id: godzilla_1954.id,
    person_id: ishiro_honda.id,
    role: "Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: godzilla_1954.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: godzilla_1954.id,
    person_id: shigeru_kayama.id,
    role: "Original Story",
    order: 2
  },
  %StaffPersonRole{
    film_id: godzilla_1954.id,
    person_id: takeo_murata.id,
    role: "Screenplay",
    order: 3
  },
  %StaffPersonRole{
    film_id: godzilla_1954.id,
    person_id: ishiro_honda.id,
    role: "Screenplay",
    order: 4
  },
  %StaffPersonRole{
    film_id: godzilla_1954.id,
    person_id: masao_tamai.id,
    role: "Cinematography",
    order: 5
  },
  %StaffPersonRole{
    film_id: godzilla_1954.id,
    person_id: takeo_kita.id,
    role: "Art Director",
    order: 6
  },
  %StaffPersonRole{
    film_id: godzilla_1954.id,
    person_id: hisashi_shimonaga.id,
    role: "Sound Recording",
    order: 8
  },
  %StaffPersonRole{
    film_id: godzilla_1954.id,
    person_id: choshiro_ishii.id,
    role: "Lighting",
    order: 9
  },
  %StaffPersonRole{
    film_id: godzilla_1954.id,
    person_id: akira_ifukube.id,
    role: "Music",
    order: 10
  },
  %StaffPersonRole{
    film_id: godzilla_1954.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects",
    order: 11
  },
  %StaffPersonRole{
    film_id: godzilla_1954.id,
    person_id: kazuji_taira.id,
    role: "Editor",
    order: 16
  }
]

from(role in StaffPersonRole, where: role.film_id == ^godzilla_1954.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
